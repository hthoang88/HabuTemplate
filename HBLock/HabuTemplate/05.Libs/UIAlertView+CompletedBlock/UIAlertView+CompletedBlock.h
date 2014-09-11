//
//  UIAlertView+CompletedBlock.h
//  MTS
//
//  Created by admin on 02.07.13.
//  Copyright (c) 2013 InnoTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (CompletedBlock)
- (id)initWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initSecureAlertWithTitle:(NSString *)title
                       message:(NSString *)message
                    completion:(void (^)(BOOL cancelled, NSInteger buttonIndex, NSString *input))completion
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
                tag:(NSInteger)tag
         completion:(void (^)(NSInteger alertTag, BOOL cancelled, NSInteger buttonIndex))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initInputWithTitle:(NSString *)title
            message:(NSString *)message
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex, NSString *input))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
