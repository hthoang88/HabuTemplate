//
//  APIManager.m
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "APIManager.h"
#import <objc/runtime.h>

@implementation APIManager
+ (APIManager*)sharedManager
{
    static APIManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[APIManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        sharedClient.securityPolicy.SSLPinningMode = AFSSLPinningModeCertificate;
        [sharedClient.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    });
    
    return sharedClient;
}

- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type
                            andPostMethodKind:(BOOL)methodKind
                                    andParams:(NSMutableDictionary *)params
                                       inView:(UIView *)view
                                completeBlock:(void (^)(id responseObject))block
{
    return [self operationWithType:type
                 andPostMethodKind:methodKind
     shouldCancelAllCurrentRequest:NO
                         andParams:params
                            inView:view
                     completeBlock:block];
}

- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type
                            andPostMethodKind:(BOOL)methodKind
                shouldCancelAllCurrentRequest:(BOOL)shouldCancel
                                    andParams:(NSMutableDictionary *)params
                                       inView:(UIView *)view
                                completeBlock:(void (^)(id responseObject))block
{
    return [self operationWithType:type
                 andPostMethodKind:methodKind
                         andParams:params
                            inView:view
     shouldCancelAllCurrentRequest:shouldCancel
                     completeBlock:block
                      failureBlock:nil];
}

- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type
                            andPostMethodKind:(BOOL)methodKind
                                    andParams:(NSMutableDictionary *)params
                                       inView:(UIView *)view
                shouldCancelAllCurrentRequest:(BOOL)shouldCancel
                                completeBlock:(void (^)(id responseObject))block
                                 failureBlock:(void (^)(NSError *error))failureBlock
{
    if (!shouldCancel) {
        NSLog(@"Cancel operation");
        [self cancelAllOperations];
    }
    NSString *path = nil;
    AFHTTPRequestOperation *operation;

//    switch (type) {
//        case ENUM_API_REQUEST_TYPE_GET_RTUI_COUPONS_CATEGORY:
//        {
//            path = STRING_REQUEST_URL_GET_RTUI_COUPONS_CATEGORY;
//            
//            [self executedOperation:params path:path methodKind:methodKind block:block failureBlock:failureBlock view:view type:type operation_p:&operation queue:queue];
//            break;
//        }
//    }
    path = @"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json";
    [self executedOperation:&operation
                   withType:type
                 methodKind:methodKind
                       view:view
                       path:path
                     params:nil
                      block:block
               failureBlock:failureBlock];
    return operation;
}

- (AFHTTPRequestOperation *)operationWithTypePath:(NSString*)path inView:(UIView *)view
                                    completeBlock:(void (^)(id responseObject))block
                                     failureBlock:(void (^)(NSError *error))failureBlock
{
    AFHTTPRequestOperation *operation;
    [self executedOperation:&operation
                   withType:ENUM_API_REQUEST_TYPE_INVALID
                 methodKind:NO
                       view:view
                       path:path
                     params:nil
                      block:block
               failureBlock:failureBlock];
    return operation;
}

- (void)executedOperation:(AFHTTPRequestOperation **)operation
                 withType:(ENUM_API_REQUEST_TYPE)type
               methodKind:(BOOL)methodKind
                     view:(UIView *)view
                     path:(NSString *)path
                   params:(NSMutableDictionary *)params
                    block:(void (^)(id))block
             failureBlock:(void (^)(id))blockFailure
{
    NSMutableURLRequest *request;
    if (!methodKind) {
        request = [self.requestSerializer requestWithMethod:@"GET"
                                                  URLString:path
                                                 parameters:params
                                                      error:nil];
    } else request = [self.requestSerializer requestWithMethod:@"POST"
                                                     URLString:path
                                                    parameters:params
                                                         error:nil];
    request.timeoutInterval = TIMER_REQUEST_TIMEOUT;
    
    *operation = [self constructOperationwithType:type
                                       andRequest:request
                                           inView:view
                                    completeBlock:block
                                     failureBlock:blockFailure];
    BOOL queue = NO;
    if (!queue) [self enqueueHTTPRequestOperation:*operation];

}

- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
    [self.operationQueue addOperation:operation];
}

- (AFHTTPRequestOperation *)constructOperationwithType:(ENUM_API_REQUEST_TYPE)type
                                            andRequest:(NSURLRequest *)request
                                                inView:(UIView *)view
                                         completeBlock:(void (^)(id))block
                                          failureBlock:(void (^)(id))blockFailure
{
    if (view != nil) {
        [Utils showHUDForView:view];
    }
    
    AFHTTPRequestOperation *operation= [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [AFHTTPRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html",nil]];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    operation.userInfo = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:type]] forKeys:@[@"type"]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"API Success %@", operation.request.URL.absoluteString);
        if (view) {
            [Utils hideHUDForView:view];
        }
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", string);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"API Fail %@", operation.request.URL.absoluteString);
        if (view) {
            [Utils hideHUDForView:view];
        }
        NSLog(@"API failure %@", operation.request.URL.absoluteString);
        NSLog(@"%@ %@",operation.responseString,error);
        
        if (blockFailure) {
            blockFailure(operation.responseString);
        }
        
    }];
    return operation;
}

- (void)cancelAllOperations
{
    if (self.operationQueue.operations.count > 0) {
        [self.operationQueue cancelAllOperations];
    }
}

@end

// Workaround for change in imp_implementationWithBlock() with Xcode 4.5
#if defined(__IPHONE_6_0) || defined(__MAC_10_8)
#define AF_CAST_TO_BLOCK id
#else
#define AF_CAST_TO_BLOCK __bridge void *
#endif


@implementation AFHTTPRequestOperation (contentType)

+ (NSSet *)acceptableContentTypes {
    return nil;
}

+ (void)addAcceptableContentTypes:(NSSet *)contentTypes {
    NSMutableSet *mutableContentTypes = [[NSMutableSet alloc] initWithSet:[self acceptableContentTypes] copyItems:YES];
    [mutableContentTypes unionSet:contentTypes];
    AFSwizzleClassMethodWithClassAndSelectorUsingBlock([self class], @selector(acceptableContentTypes), ^(__unused id _self) {
        return mutableContentTypes;
    });
}
static void AFSwizzleClassMethodWithClassAndSelectorUsingBlock(Class klass, SEL selector, id block) {
    Method originalMethod = class_getClassMethod(klass, selector);
    IMP implementation = imp_implementationWithBlock((AF_CAST_TO_BLOCK)block);
    class_replaceMethod(objc_getMetaClass([NSStringFromClass(klass) UTF8String]), selector, implementation, method_getTypeEncoding(originalMethod));
}
@end
