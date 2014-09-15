//
//  PreviewView.h
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewView : UIView
@property (weak, nonatomic) IBOutlet UIView *headerView;
- (IBAction)btnCloseTouchUpInside:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgNumberpad;
@property (weak, nonatomic) IBOutlet UIView *targetView;

@property (nonatomic, copy) void(^completeBlock)(UIImage *image, BOOL isCancel);

@end
