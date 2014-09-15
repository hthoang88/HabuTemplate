//
//  APIManager.m
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager
+ (APIManager*)sharedManager
{
    static APIManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[APIManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
//        sharedClient.securityPolicy.SSLPinningMode = AFSSLPinningModeCertificate;
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

    switch (type) {
            
        case ENUM_API_REQUEST_TYPE_CHECK_SHOW_INVITE:
            break;
            
        case ENUM_API_REQUEST_TYPE_GET_FB_LIST_FRIENDS:
        {
            NSString *accessToken = params[@"accessToken"];
            https://graph.facebook.com/me/friends?limit=25&offset=25&access_token=%@&format=json
            
            path = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?fields=id,name&access_token=%@&limit=25&offset=25&format=json", accessToken];
            [self executedOperation:&operation
                           withType:type
                         methodKind:methodKind
                               view:view
                               path:path
                             params:nil
                              block:block
                       failureBlock:failureBlock];
            break;
        }
    }
//    path = @"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json";
//    [self executedOperation:&operation
//                   withType:type
//                 methodKind:methodKind
//                       view:view
//                       path:path
//                     params:nil
//                      block:block
//               failureBlock:failureBlock];
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
        request = [self requestWithMethod:@"GET" path:path parameters:params];
    } else request = [self requestWithMethod:@"POST" path:path parameters:params];
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
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    operation.userInfo = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:type]] forKeys:@[@"type"]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"API Success %@", operation.request.URL.absoluteString);
        if (view) {
            [Utils hideHUDForView:view];
        }
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSError* error;
            responseObject = [NSJSONSerialization
                                  JSONObjectWithData:responseObject
                                  options:kNilOptions 
                                  error:&error];
        }
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

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSParameterAssert(method);
    
    if (!path) {
        path = @"";
    }
    
    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
//    [request setAllHTTPHeaderFields:self.defaultHeaders];
    
    if (parameters) {
        if ([method isEqualToString:@"GET"] || [method isEqualToString:@"HEAD"] || [method isEqualToString:@"DELETE"]) {
            url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:[path rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding)]];
            [request setURL:url];
        } else {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
            NSError *error = nil;
            
            switch (self.parameterEncoding) {
                case AFFormURLParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding) dataUsingEncoding:self.stringEncoding]];
                    break;
                case AFJSONParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]];
                    break;
                case AFPropertyListParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/x-plist; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:parameters format:NSPropertyListXMLFormat_v1_0 options:0 error:&error]];
                    break;
            }
            
            if (error) {
                NSLog(@"%@ %@: %@", [self class], NSStringFromSelector(_cmd), error);
            }
        }
    }
    
	return request;
}
@end
