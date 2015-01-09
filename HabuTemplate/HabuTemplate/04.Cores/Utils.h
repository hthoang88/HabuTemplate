//
//  Utils.h
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (void)showHUDForView:(UIView*)v;
+ (void)showHUDForView:(UIView*)v message:(NSString*)msg;
+ (void)hideHUDForView:(UIView*)v;

//Object
+ (NSString*)autoDescribe:(id)instance;

+ (NSString *)getRandStringLength:(int)len;
@end
