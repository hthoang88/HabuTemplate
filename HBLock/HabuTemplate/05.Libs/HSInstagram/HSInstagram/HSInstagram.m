//
//  HSInstagram.m
//  HSInstagram
//
//  Created by Harminder Sandhu on 12-01-18.
//  Copyright (c) 2012 Pushbits. All rights reserved.
//

#import "HSInstagram.h"

#import "AFJSONRequestOperation.h"

NSString * const kInstagramBaseURLString = @"https://api.instagram.com/v1/";

//NSString * const kClientId = @"791c5e2aaecf4ddc8af6b29593b26e62";
NSString * const kClientId = @"9496fa4209764716a61bbba8296d3ce4";// TaiT 2013/01/24
//NSString * const kClientId = @"950f815248e346719c851b73c7d9b864";
NSString * const kRedirectUrl = @"http://www.habutechs.blogspot.com:6868/HBLock/callbackcode";// TaiT 2013/01/24
//NSString * const kRedirectUrl = @"http://www.visikard.com";
//oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=likes+comments+basic
// Endpoints
NSString * const kLocationsEndpoint = @"locations/search";
NSString * const kLocationsMediaRecentEndpoint = @"locations/%@/media/recent";
NSString * const kUserMediaRecentEndpoint = @"users/%@/media/recent";
NSString * const kAuthenticationEndpoint = 
    @"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token";
//    @"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token]";
//thaibinh076@gmail.com/
@implementation HSInstagram

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithBaseURL:(NSURL *)url 
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

+ (HSInstagram *)sharedClient 
{
    static HSInstagram * _sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kInstagramBaseURLString]];
    });
    
    return _sharedClient;
}

@end
