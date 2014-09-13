//
//  Utils.h
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDevice+Resolutions.h"

@interface Utils : NSObject
+ (void)showHUDForView:(UIView*)v;
+ (void)showHUDForView:(UIView*)v message:(NSString*)msg;
+ (void)hideHUDForView:(UIView*)v;

//Object
+ (NSString*)autoDescribe:(id)instance;

+ (NSURL *)applicationDocumentsDirectory;

+ (NSString *)getRandStringLength:(int)len;

+ (int)getDeviceHeight;
+ (int)getDeviceWidth;
@end
