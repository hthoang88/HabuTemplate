//
//  PreviewView.m
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "PreviewView.h"
#import "SPUserResizableView.h"
#import "UIImage+HBLock.h"

@interface PreviewView (){
    SPUserResizableView *userResizableView;
}
@end


@implementation PreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PreviewView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        userResizableView = [[SPUserResizableView alloc] initWithFrame:self.imgNumberpad.frame];
        userResizableView.contentView = self.imgNumberpad;
        [self addSubview:userResizableView];
    }
    return self;
}

- (IBAction)btnCloseTouchUpInside:(id)sender {
    if (self.completeBlock) {
        self.completeBlock(nil, YES);
    }
    [self removeFromSuperview];
}
- (IBAction)btnDoneTouchUpInside:(id)sender {
    userResizableView.hidden = YES;
    UIImage *image = [self captureView:self];
    
    CGSize size = userResizableView.contentView.frame.size;
    CGPoint point = CGPointMake(userResizableView.frame.origin.x + userResizableView.contentView.frame.origin.x, userResizableView.frame.origin.y + userResizableView.contentView.frame.origin.y);
    image = [image imageByCropWithNewSize:size point:point];

    
    if (self.completeBlock) {
        self.completeBlock(image, NO);
    }
    [self removeFromSuperview];
}

- (UIImage*)captureView:(UIView *)yourView
{
    //this function return image with low quality
    UIGraphicsBeginImageContext(yourView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [yourView.layer renderInContext:context];
    UIImage *imageCaptureRect = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCaptureRect;
}

@end
