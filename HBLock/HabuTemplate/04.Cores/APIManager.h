//
//  APIManager.h
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface APIManager : AFHTTPClient

+ (APIManager*)sharedManager;

- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type
                            andPostMethodKind:(BOOL)methodKind
                                    andParams:(NSMutableDictionary *)params
                                       inView:(UIView *)view
                                completeBlock:(void (^)(id responseObject))block;
- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type
                            andPostMethodKind:(BOOL)methodKind
                shouldCancelAllCurrentRequest:(BOOL)shouldCancel
                                    andParams:(NSMutableDictionary *)params
                                       inView:(UIView *)view
                                completeBlock:(void (^)(id responseObject))block;

- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type
                            andPostMethodKind:(BOOL)methodKind
                                    andParams:(NSMutableDictionary *)params
                                       inView:(UIView *)view
                shouldCancelAllCurrentRequest:(BOOL)shouldCancel
                                completeBlock:(void (^)(id responseObject))block
                                 failureBlock:(void (^)(NSError *error))failureBlock;

- (void)cancelAllOperations;
@end
