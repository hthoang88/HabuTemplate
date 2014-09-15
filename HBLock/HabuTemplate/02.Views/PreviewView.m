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

@interface PreviewView ()<SPUserResizableViewDelegate>
{
    SPUserResizableView *resizeableView;
}
@end


@implementation PreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PreviewView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.multipleTouchEnabled = YES;
        resizeableView = [[SPUserResizableView alloc] initWithFrame:self.imgNumberpad.frame];
        resizeableView.contentView = self.imgNumberpad;
        [self addSubview:resizeableView];
        [self bringSubviewToFront:resizeableView];
        resizeableView.delegate = self;
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
    resizeableView.hidden = YES;
    self.headerView.hidden = YES;
    UIImage *image = [self captureView:self];
    
    CGSize size = resizeableView.contentView.frame.size;
    CGPoint point = CGPointMake(resizeableView.frame.origin.x + resizeableView.contentView.frame.origin.x, resizeableView.frame.origin.y + resizeableView.contentView.frame.origin.y);
    image = [image imageByCropWithNewSize:size point:point];

    
    if (self.completeBlock) {
        if (self.targetView) {
            if ([self.targetView isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton*)self.targetView;
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                [btn setBackgroundImage:image forState:UIControlStateHighlighted];
            }else if([self.targetView isKindOfClass:[UIImageView class]]){
                UIImageView *imgView = (UIImageView*)self.targetView;
                imgView.image = image;
            }
        }
        self.completeBlock(image, NO);
    }
    [self removeFromSuperview];
}


#pragma mark - SPUserResizableViewDelegate

// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView
{
    [self bringSubviewToFront:userResizableView];
}

// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView
{
    [self bringSubviewToFront:self.headerView];
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
