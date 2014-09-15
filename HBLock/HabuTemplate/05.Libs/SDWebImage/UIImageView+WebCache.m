/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "objc/runtime.h"
#import "SDWebImageManager.h"
#import "UIImage+HBLock.h"

#define kMaxLoadImageTryTime    2

static char operationKey;
static char operationArrayKey;

@implementation UIImageView (WebCache)
static char UIB_PROPERTY_KEY;
@dynamic scaleOption;

- (void)setScaleOption:(NSString *)option
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, option, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)scaleOption
{
    return (NSString *)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock
{
//    [self cancelCurrentImageLoad];

    // TaiT: no need to scale placeholder image, it causes low performance
    self.image = placeholder;
    // set place holder image
    if ([self.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSizeLarger]) {
        //     // added by seng
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2 - 11.0f),CGRectGetHeight(self.frame) / 2, 22.0f, 22.0f);
        
        activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview: activityView];
        [activityView startAnimating];
    }

    
    if (url)
    {
        __weak UIImageView *wself = self;

        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options|SDWebImageLowPriority progress:progressBlock completed:^(NSURL *requestURL, UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
        {
            if (!wself)
                return;
            dispatch_main_sync_safe(^
            {
                __strong UIImageView *sself = wself;
                if (!sself)
                    return;
                if (image)
                {
                    // scale image
                    if ([sself.scaleOption isEqual: enumWebImageScaleOption_FullFill]) {
                        [sself setImage:image];
                    }
                    else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScaleToFill]) {
                        
                        [sself setImage:[image imageByScalingToSize:sself.frame.size withOption:enumImageScalingType_Center_ScaleSize]];
                    }
                    else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScaleToWidth_Top]) {
                        [sself setImage:[image imageByScalingToSize:sself.frame.size withOption:enumImageScalingType_Top]];
                    }
                    else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSize]) {
                        
                        UIImage *thumbnailPhoto = [sself cropCenterAndScaleImageToSize:CGSizeMake(85.0,85.0) selectedImage:image];
                        
                        [sself setImage:thumbnailPhoto];
                    }
                    else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSizeLarger]) {
                        //UIImage *thumbnailPhoto = [self cropCenterAndScaleImageToSize:CGSizeMake(240.0,195.0) selectedImage:image];
                        UIImage *thumbnailPhoto = [sself cropCenterAndScaleImageToSize:CGSizeMake(240.0,220.0) selectedImage:image];
                        [sself setImage:thumbnailPhoto];
                    }
                    
                    else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoFullSize]) {
                        UIImage *thumbnailPhoto = [sself cropCenterAndScaleImageToSize:CGSizeMake(320.0,220.0) selectedImage:image];
                        [sself setImage:thumbnailPhoto];
                    } else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoCenterFullSize]) {
                        UIImage *thumbnailPhoto = [image imageByScalingToSize:CGSizeMake(sself.frame.size.width,sself.frame.size.height) withOption:enumImageScalingType_Center_FullSize];
                        [sself setImage:thumbnailPhoto];
                    }
                    else {
                        [sself setImage:image];
                    }
                    
//                    sself.image = image;
                    [sself setNeedsLayout];
                }
                if (completedBlock && finished)
                {
                    completedBlock(image, error, cacheType);
                }
                
                // remove acitivity indicator
                NSArray *subviews = [sself subviews];
                for (UIView *activityView in subviews)
                {
                    if ([activityView isKindOfClass:[UIActivityIndicatorView class]])
                    {
                        [(UIActivityIndicatorView*)activityView stopAnimating];
                        [activityView removeFromSuperview];
                        break;
                    }
                }
            });
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs
{
    [self cancelCurrentArrayLoad];
    __weak UIImageView *wself = self;

    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];

    for (NSURL *logoImageURL in arrayOfURLs)
    {
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:logoImageURL options:0 progress:nil completed:^(NSURL *requestURL, UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
        {
            if (!wself) return;
            dispatch_main_sync_safe(^
            {
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image)
                {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages)
                    {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }

    objc_setAssociatedObject(self, &operationArrayKey, [NSArray arrayWithArray:operationsArray], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cancelCurrentImageLoad
{
    // Cancel in progress downloader from queue
    id<SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)cancelCurrentArrayLoad
{
    // Cancel in progress downloader from queue
    NSArray *operations = objc_getAssociatedObject(self, &operationArrayKey);
    for (id<SDWebImageOperation> operation in operations)
    {
        if (operation)
        {
            [operation cancel];
        }
    }
    objc_setAssociatedObject(self, &operationArrayKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Utilities methods
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize selectedImage:(UIImage*) image {
	UIImage *scaledImage = [self rescaleImageToSize:[self calculateNewSizeForCroppingBox:cropSize selectedImage:image] selectedImage:image];
    
    NSLog(@"width:%f height:%f",scaledImage.size.width,scaledImage.size.height);
    
    CGRect cropedImageRect = CGRectMake((scaledImage.size.width-cropSize.width)/2, (scaledImage.size.height-cropSize.height)/2, cropSize.width, cropSize.height);
    
    //CGRect cropedImageRect = CGRectMake((image.size.width-cropSize.width)/2, (image.size.height-cropSize.height)/2, cropSize.width, cropSize.height);
    
	return [self cropImageToRect:cropedImageRect selectedImage:scaledImage];
}

- (UIImage *)cropImageToRect:(CGRect)cropRect selectedImage:(UIImage*)image {
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	// Draw view into context
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (image.size.height - cropRect.size.height) , image.size.width, image.size.height);
	CGContextDrawImage(ctx, drawRect, image.CGImage);
	
	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the drawing
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox selectedImage:(UIImage*)image {
	// Make the shortest side be equivalent to the cropping box.
	CGFloat newHeight, newWidth;
	if (image.size.width < image.size.height) {
		newWidth = croppingBox.width;
		newHeight = (image.size.height / image.size.width) * croppingBox.width;
	} else {
		newHeight = croppingBox.height;
		newWidth = (image.size.width / image.size.height) *croppingBox.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (UIImage *)rescaleImageToSize:(CGSize)size selectedImage:(UIImage*)image {
	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:rect];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
}
@end


@implementation UIImageView (WebCache_Custom)

- (void)setImageWithListURL:(NSArray *)urls firstPlaceHolder:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock urlIndex:(int)index
{
    __weak UIImageView *wself = self;
    [self setImageWithURL:urls[index] placeholderImage:placeholder options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            if (index == urls.count - 1) {
                if (completedBlock) {
                    completedBlock(image, error, cacheType);
                }
            }else{
                int nextIndex = index + 1;
                [wself setImageWithListURL:urls firstPlaceHolder:image completed:completedBlock urlIndex:nextIndex];
            }
        }else{
            NSLog(@"WTF ============> %@",error);
            if (index < urls.count - 1) {//continue loading next image if current request failed
                int nextIndex = index + 1;
                [wself setImageWithListURL:urls firstPlaceHolder:placeholder completed:completedBlock urlIndex:nextIndex];
            }
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock webCompletionBlock:(SDWebImageCompletedWithFinishedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock webCompletionBlock:completedBlock tryTime:1];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock webCompletionBlock:(SDWebImageCompletedWithFinishedBlock)completedBlock tryTime:(int)tryTime
{
    self.image = placeholder;
    // set place holder image
    if ([self.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSizeLarger]) {
        //     // added by seng
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2 - 11.0f),CGRectGetHeight(self.frame) / 2, 22.0f, 22.0f);
        
        activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview: activityView];
        [activityView startAnimating];
    }
    
    
    if (url)
    {
        __weak UIImageView *wself = self;
        
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options|SDWebImageLowPriority progress:progressBlock completed:^(NSURL *requestURL, UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (!wself)
                 return;
             dispatch_main_sync_safe(^
             {
                 __strong UIImageView *sself = wself;
                 if (!sself)
                     return;
                 if (error) {
                     //If It's a request time out or domain error and try time less than kMaxLoadImageTryTime => Try downloading image again
                     if (error.code == NSURLErrorTimedOut ||
                         error.code == -1100 && tryTime < kMaxLoadImageTryTime) {
                         int nextTryTime = tryTime + 1;
                         [self setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock webCompletionBlock:completedBlock tryTime:nextTryTime];
                         return;
                     }
                 }
                 if (image)
                 {
                     // scale image
                     if ([sself.scaleOption isEqual: enumWebImageScaleOption_FullFill]) {
                         [sself setImage:image];
                     }
                     else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScaleToFill]) {
                         
                         [sself setImage:[image imageByScalingToSize:sself.frame.size withOption:enumImageScalingType_Center_ScaleSize]];
                     }
                     else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScaleToWidth_Top]) {
                         [sself setImage:[image imageByScalingToSize:sself.frame.size withOption:enumImageScalingType_Top]];
                     }
                     else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSize]) {
                         
                         UIImage *thumbnailPhoto = [sself cropCenterAndScaleImageToSize:CGSizeMake(85.0,85.0) selectedImage:image];
                         
                         [sself setImage:thumbnailPhoto];
                     }
                     else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSizeLarger]) {
                         //UIImage *thumbnailPhoto = [self cropCenterAndScaleImageToSize:CGSizeMake(240.0,195.0) selectedImage:image];
                         UIImage *thumbnailPhoto = [sself cropCenterAndScaleImageToSize:CGSizeMake(240.0,220.0) selectedImage:image];
                         [sself setImage:thumbnailPhoto];
                     }
                     
                     else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoFullSize]) {
                         UIImage *thumbnailPhoto = [sself cropCenterAndScaleImageToSize:CGSizeMake(320.0,220.0) selectedImage:image];
                         [sself setImage:thumbnailPhoto];
                     } else if ([sself.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoCenterFullSize]) {
                         UIImage *thumbnailPhoto = [image imageByScalingToSize:CGSizeMake(sself.frame.size.width,sself.frame.size.height) withOption:enumImageScalingType_Center_FullSize];
                         [sself setImage:thumbnailPhoto];
                     }
                     else {
                         [sself setImage:image];
                     }
                     
                     //                    sself.image = image;
                     [sself setNeedsLayout];
                 }
                 if (completedBlock && finished)
                 {
                     completedBlock(requestURL, image, error, cacheType, finished);
                 }
                 
                 // remove acitivity indicator
                 NSArray *subviews = [sself subviews];
                 for (UIView *activityView in subviews)
                 {
                     if ([activityView isKindOfClass:[UIActivityIndicatorView class]])
                     {
                         [(UIActivityIndicatorView*)activityView stopAnimating];
                         [activityView removeFromSuperview];
                         break;
                     }
                 }
             });
         }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setImageWithListURL:(NSArray *)urls firstPlaceHolder:(UIImage *)placeholder webCompletionBlock:(SDWebImageCompletedWithFinishedBlock)completedBlock urlIndex:(int)index
{
    __weak UIImageView *wself = self;
      [self setImageWithURL:urls[index] placeholderImage:placeholder options:0 progress:nil webCompletionBlock:^(NSURL *requestURL, UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
          if (image) {
              if (index == urls.count - 1) {
                  if (completedBlock) {
                      completedBlock(requestURL, image, error, cacheType,finished);
                  }
              }else{
                  int nextIndex = index + 1;
                  [wself setImageWithListURL:urls firstPlaceHolder:image webCompletionBlock:completedBlock urlIndex:nextIndex];
              }
          }else{
              NSLog(@"WTF ============> %@",error);
              if (index < urls.count - 1) {//continue loading next image if current request failed
                  int nextIndex = index + 1;
                  [wself setImageWithListURL:urls firstPlaceHolder:placeholder webCompletionBlock:completedBlock urlIndex:nextIndex];
              }
          }
      }];
}
@end

@implementation SDWebImageManager (WebCache_Custom)

- (void)downloadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock webCompletionBlock:(SDWebImageCompletedWithFinishedBlock)completedBlock
{
    [self downloadImageWithURL:url options:options progress:progressBlock webCompletionBlock:completedBlock tryTime:1];
}


- (void)downloadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock webCompletionBlock:(SDWebImageCompletedWithFinishedBlock)completedBlock tryTime:(int)tryTime
{
    
    if (url)
    {
        __weak SDWebImageManager *wself = self;
        
        [self downloadWithURL:url options:options|SDWebImageLowPriority progress:nil completed:^(NSURL *requestURL, UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                __strong SDWebImageManager *sself = wself;
                if (!sself)
                    return;
                if (error) {
                    //If It's a request time out or domain error and try time less than kMaxLoadImageTryTime => Try downloading image again
                    if ((error.code == NSURLErrorTimedOut || error.code == -1100) && tryTime < kMaxLoadImageTryTime) {
                        int nextTryTime = tryTime + 1;
                        [self downloadImageWithURL:url options:options progress:progressBlock webCompletionBlock:completedBlock tryTime:nextTryTime];
                        return;
                    }
                }
                
                if (completedBlock && finished)
                {
                    completedBlock(requestURL, image, error, cacheType, finished);
                }
        }];
    }
}

-(void)downloadImageWithListURL:(NSArray *)urls progressBlock:(SDImageDonwloadPartialProgressBlock)progressBlock webCompletionBlock:(SDWebImageCompletedWithFinishedBlock)completedBlock urlIndex:(int)index
{
    __weak SDWebImageManager *wself = self;
    [self downloadImageWithURL:urls[index] options:0 progress:nil webCompletionBlock:^(NSURL *requestURL, UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image) {
            // call progress block after finish downloading one image
            if (progressBlock) {
                progressBlock(requestURL, image, index, error, cacheType, finished);
            }
            
            if (index == urls.count - 1) {
                if (completedBlock) {
                    completedBlock(requestURL, image, error, cacheType,finished);
                }
            }else{
                int nextIndex = index + 1;
                [wself downloadImageWithListURL:urls progressBlock:progressBlock webCompletionBlock:completedBlock urlIndex:nextIndex];
            }
        }else{
            NSLog(@"WTF ============> %@",error);
            if (index < urls.count - 1) {//continue loading next image if current request failed
                int nextIndex = index + 1;
                [wself downloadImageWithListURL:urls progressBlock:progressBlock webCompletionBlock:completedBlock urlIndex:nextIndex];
            }
        }
    }];
}

@end
