//
//  PreviewViewController.h
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface PreviewViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgNumberPad;
@property (strong, nonatomic) UIImage *currentImage;
@end
