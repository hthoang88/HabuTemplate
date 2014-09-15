/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageManager.h"
#import "UIImage+GIF.h"
#import <objc/message.h>

@interface SDWebImageCombinedOperation : NSObject <SDWebImageOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic) void (^cancelBlock)();
@property (strong, nonatomic) NSOperation *cacheOperation;
@property (retain, nonatomic) NSURL *url;

@end

@interface SDWebImageManager ()

@property (strong, nonatomic, readwrite) SDImageCache *imageCache;
@property (strong, nonatomic, readwrite) SDWebImageDownloader *imageDownloader;
@property (strong, nonatomic) NSMutableArray *failedURLs;
@property (strong, nonatomic) NSMutableArray *runningOperations;

@end

@implementation SDWebImageManager

+ (id)sharedManager
{
    static dispatch_once_t once;
    static SDWebImageManager* instance;
    dispatch_once(&once, ^{
        instance = self.new;
        instance.imageDownloader.maxConcurrentDownloads = 100;
    });
    return instance;
}

- (id)init
{
    if ((self = [super init]))
    {
        _imageCache = [self createCache];
        _imageDownloader = SDWebImageDownloader.new;
        _failedURLs = NSMutableArray.new;
        _runningOperations = NSMutableArray.new;
    }
    return self;
}

- (SDImageCache *)createCache
{
    return [SDImageCache sharedImageCache];
}

- (NSString *)cacheKeyForURL:(NSURL *)url
{
    if (self.cacheKeyFilter)
    {
        return self.cacheKeyFilter(url);
    }
    else
    {
        return [url absoluteString];
    }
}

- (id<SDWebImageOperation>)downloadWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedWithFinishedBlock)completedBlock
{
    
    //NSLog(@"--------=%i",_runningOperations.count);
    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, XCode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    if ([url isKindOfClass:NSString.class])
    {
        url = [NSURL URLWithString:(NSString *)url];
    }

    // Prevents app crashing on argument type error like sending NSNull instead of NSURL
    if (![url isKindOfClass:NSURL.class])
    {
        url = nil;
    }

    __block SDWebImageCombinedOperation *operation = SDWebImageCombinedOperation.new;
    __weak SDWebImageCombinedOperation *weakOperation = operation;
    
    BOOL isFailedUrl = NO;
    @synchronized(self.failedURLs)
    {
        isFailedUrl = [self.failedURLs containsObject:url];
    }

    if (!url || !completedBlock || (!(options & SDWebImageRetryFailed) && isFailedUrl))
    {
        if (completedBlock)
        {
            dispatch_main_sync_safe(^
            {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
                completedBlock(url, nil, error, SDImageCacheTypeNone, YES);
            });
        }
        return operation;
    }

    @synchronized(self.runningOperations)
    {
//        for (SDWebImageCombinedOperation *op in self.runningOperations)
//        {
//            if ([[op.url absoluteString] isEqualToString:url.absoluteString]) {
//                NSLog(@"aaaaaa");
//                return op;
//            }
//        }
        operation.url = url;
        
        [self.runningOperations addObject:operation];
    }
    NSString *key = [self cacheKeyForURL:url];

    operation.cacheOperation = [self.imageCache queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType)
    {
        if (operation.isCancelled)
        {
            @synchronized(self.runningOperations)
            {
                [self.runningOperations removeObject:operation];
            }

            return;
        }

        if ((!image || options & SDWebImageRefreshCached) && (![self.delegate respondsToSelector:@selector(imageManager:shouldDownloadImageForURL:)] || [self.delegate imageManager:self shouldDownloadImageForURL:url]))
        {
            if (image && options & SDWebImageRefreshCached)
            {
                dispatch_main_sync_safe(^
                {
                    // If image was found in the cache bug SDWebImageRefreshCached is provided, notify about the cached image
                    // AND try to re-download it in order to let a chance to NSURLCache to refresh it from server.
                    completedBlock(url, image, nil, cacheType, YES);
                });
            }

            // download if no image or requested to refresh anyway, and download allowed by delegate
            SDWebImageDownloaderOptions downloaderOptions = 0;
            if (options & SDWebImageLowPriority) downloaderOptions |= SDWebImageDownloaderLowPriority;
            if (options & SDWebImageProgressiveDownload) downloaderOptions |= SDWebImageDownloaderProgressiveDownload;
            if (options & SDWebImageRefreshCached) downloaderOptions |= SDWebImageDownloaderUseNSURLCache;
            if (options & SDWebImageHighestPriority) downloaderOptions |= SDWebImageDownloaderHighestPriority;
            if (image && options & SDWebImageRefreshCached)
            {
                // force progressive off if image already cached but forced refreshing
                downloaderOptions &= ~SDWebImageDownloaderProgressiveDownload;
                // ignore image read from NSURLCache if image if cached but force refreshing
                downloaderOptions |= SDWebImageDownloaderIgnoreCachedResponse;
            }
            id<SDWebImageOperation> subOperation = [self.imageDownloader downloadImageWithURL:url options:downloaderOptions progress:progressBlock completed:^(UIImage *downloadedImage, NSData *data, NSError *error, BOOL finished)
            {                
                if (weakOperation.isCancelled)
                {
                    dispatch_main_sync_safe(^
                    {
                        completedBlock(url, nil, nil, SDImageCacheTypeNone, finished);
                    });
                }
                else if (error)
                {
                    dispatch_main_sync_safe(^
                    {
                        completedBlock(url, nil, error, SDImageCacheTypeNone, finished);
                    });
                    
                    //Don't set url is faile if request time out or error domains
                    if (error.code != NSURLErrorNotConnectedToInternet &&
                        error.code != NSURLErrorTimedOut &&
                        error.code != -1100)
                    {
                        @synchronized(self.failedURLs)
                        {
                            [self.failedURLs addObject:url];
                        }
                    }
                }
                else
                {
                    BOOL cacheOnDisk = !(options & SDWebImageCacheMemoryOnly);

                    if (options & SDWebImageRefreshCached && image && !downloadedImage)
                    {
                        // Image refresh hit the NSURLCache cache, do not call the completion block
                    }
                    // NOTE: We don't call transformDownloadedImage delegate method on animated images as most transformation code would mangle it
                    else if (downloadedImage && !downloadedImage.images && [self.delegate respondsToSelector:@selector(imageManager:transformDownloadedImage:withURL:)])
                    {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                        {
                            UIImage *transformedImage = [self.delegate imageManager:self transformDownloadedImage:downloadedImage withURL:url];

                            dispatch_main_sync_safe(^
                            {
                                completedBlock(url, transformedImage, nil, SDImageCacheTypeNone, finished);
                            });

                            if (transformedImage && finished)
                            {
                                NSData *dataToStore = [transformedImage isEqual:downloadedImage] ? data : nil;
                                [self.imageCache storeImage:transformedImage imageData:dataToStore forKey:key toDisk:cacheOnDisk];
                            }
                        });
                    }
                    else
                    {
                        dispatch_main_sync_safe(^
                        {
                            completedBlock(url, downloadedImage, nil, SDImageCacheTypeNone, finished);
                        });

                        if (downloadedImage && finished)
                        {
                            [self.imageCache storeImage:downloadedImage imageData:data forKey:key toDisk:cacheOnDisk];
                        }
                    }
                }

                if (finished)
                {
                    @synchronized(self.runningOperations)
                    {
                        [self.runningOperations removeObject:operation];
                    }
                }
            }];
            operation.cancelBlock = ^{[subOperation cancel];};
        }
        else if (image)
        {
            dispatch_main_sync_safe(^
            {
                completedBlock(url, image, nil, cacheType, YES);
            });
            @synchronized(self.runningOperations)
            {
                [self.runningOperations removeObject:operation];
            }
        }
        else
        {
            // Image not in cache and download disallowed by delegate
            dispatch_main_sync_safe(^
            {
                completedBlock(url, nil, nil, SDImageCacheTypeNone, YES);
            });
            @synchronized(self.runningOperations)
            {
                [self.runningOperations removeObject:operation];
            }
        }
    }];

    return operation;
}

#pragma mark - Additional Methods

- (UIImage *)imageWithURL:(NSURL *)url
{
    return [self.imageCache imageFromMemoryCacheForKey:[url absoluteString]];
}

-(void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)target
{
    [self downloadWithURL:url delegate:target retryFailed:NO lowPriority:NO];
}

-(void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)target retryFailed:(BOOL)isRetry lowPriority:(BOOL)isLowPriority
{
    SDWebImageOptions option = 0;
    option = isRetry ? SDWebImageRetryFailed : option;
    option = isLowPriority ? (option | SDWebImageLowPriority) : option;

    
    self.delegate = target;
    [self downloadWithURL:url options:option progress:nil completed:^(NSURL* requestURL, UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image) {
            // success
            if ([target respondsToSelector:@selector(webImageManager:didFinishWithImage:)]) {
                [target webImageManager:self didFinishWithImage:image];
            }
        }
        else {
            // failed
            if ([target respondsToSelector:@selector(webImageManager:didFailWithError:)]) {
                [target webImageManager:self didFailWithError:error];
            }
        }
    }];
}

-(void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)target retryFailed:(BOOL)isRetry
{
    [self downloadWithURL:url delegate:target retryFailed:isRetry lowPriority:NO];
}

- (void)cancelAll
{
    @synchronized(self.runningOperations)
    {
        [self.runningOperations makeObjectsPerformSelector:@selector(cancel)];
        [self.runningOperations removeAllObjects];
    }
}

- (BOOL)isRunning
{
    return self.runningOperations.count > 0;
}

//New method

/**
 * Check if image has already been cached
 */
- (BOOL)cachedImageExistsForURL:(NSURL *)url
{
    NSString *key = [self cacheKeyForURL:url];
    if ([self.imageCache imageFromMemoryCacheForKey:key] != nil) return YES;
    return [self.imageCache diskImageExistsWithKey:key];
}

- (BOOL)diskImageExistsForURL:(NSURL *)url
{
    NSString *key = [self cacheKeyForURL:url];
    return [self.imageCache diskImageExistsWithKey:key];
}

@end

@implementation SDWebImageCombinedOperation

- (void)setCancelBlock:(void (^)())cancelBlock
{
    if (self.isCancelled)
    {
        if (cancelBlock) cancelBlock();
    }
    else
    {
        _cancelBlock = [cancelBlock copy];
    }
}

- (void)cancel
{
    self.cancelled = YES;
    if (self.cacheOperation)
    {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    if (self.cancelBlock)
    {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
}

@end
