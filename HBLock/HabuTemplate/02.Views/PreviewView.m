//
//  PreviewView.m
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "PreviewView.h"
#import "SPUserResizableView.h"

@implementation PreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PreviewView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:self.imgNumberpad.frame];
        userResizableView.contentView = self.imgNumberpad;
        [self addSubview:userResizableView];
    }
    return self;
}

- (IBAction)btnCloseTouchUpInside:(id)sender {
    [self removeFromSuperview];
}
@end
