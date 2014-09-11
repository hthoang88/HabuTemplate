//
//  UIAlertView+CompletedBlock.m
//  MTS
//
//  Created by admin on 02.07.13.
//  Copyright (c) 2013 InnoTech. All rights reserved.
//

#import "UIAlertView+CompletedBlock.h"
#import <objc/runtime.h>

static char const * const alertCompletionBlockTag = "alertCompletionBlock";
static int defaultTag = 1111111;

@implementation UIAlertView (CompletedBlock)

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil ];
    self.tag = defaultTag;
    if (self) {
        objc_setAssociatedObject(self, alertCompletionBlockTag, completion, OBJC_ASSOCIATION_COPY);
        
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}

- (id)initSecureAlertWithTitle:(NSString *)title
                       message:(NSString *)message
                    completion:(void (^)(BOOL cancelled, NSInteger buttonIndex, NSString *input))completion
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil ];
    self.alertViewStyle = UIAlertViewStyleSecureTextInput;
        self.tag = defaultTag;
    if (self) {
        objc_setAssociatedObject(self, alertCompletionBlockTag, completion, OBJC_ASSOCIATION_COPY);
        
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
                tag:(NSInteger)tag
         completion:(void (^)(NSInteger alertTag, BOOL cancelled, NSInteger buttonIndex))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil ];
    self.tag = tag;
    if (self) {
        objc_setAssociatedObject(self, alertCompletionBlockTag, completion, OBJC_ASSOCIATION_COPY);
        
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
    
}

- (id)initInputWithTitle:(NSString *)title
                 message:(NSString *)message
              completion:(void (^)(BOOL cancelled, NSInteger buttonIndex, NSString *input))completion
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil ];
    self.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.tag = defaultTag;
    if (self) {
        objc_setAssociatedObject(self, alertCompletionBlockTag, completion, OBJC_ASSOCIATION_COPY);
        
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}


#pragma mark - Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    id completion = objc_getAssociatedObject(self, alertCompletionBlockTag);
    if (self.tag != defaultTag) {
        [self completeWithTag:completion index:buttonIndex];
    }else{
        if (self.alertViewStyle == UIAlertViewStyleSecureTextInput ||
            self.alertViewStyle == UIAlertViewStylePlainTextInput) {
            [self completeWithSecure:completion index:buttonIndex];
        } else{
            [self complete:completion index:buttonIndex];
        }
    }
}

- (void) complete:(void (^)(BOOL cancelled, NSInteger buttonIndex))block index:(NSInteger)buttonIndex {
    BOOL _cancelled = (buttonIndex == self.cancelButtonIndex);
    block(_cancelled, buttonIndex );
    
    objc_removeAssociatedObjects(block);
}

- (void) completeWithTag:(void (^)(NSInteger alertTag, BOOL cancelled, NSInteger buttonIndex))block index:(NSInteger)buttonIndex {
    BOOL _cancelled = (buttonIndex == self.cancelButtonIndex);
    block(self.tag, _cancelled, buttonIndex );
    
    objc_removeAssociatedObjects(block);
}

- (void) completeWithSecure:(void (^)(BOOL cancelled, NSInteger buttonIndex, NSString *input))block index:(NSInteger)buttonIndex {
    NSString *secureInput =  [self textFieldAtIndex:0].text;
    if (!secureInput) {
        secureInput = @"";
    }
    BOOL _cancelled = (buttonIndex == self.cancelButtonIndex);
    block(_cancelled, buttonIndex, secureInput);
    
    objc_removeAssociatedObjects(block);
}

@end
