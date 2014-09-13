//
//  HBLockCameraView.h
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBLockCameraViewDelegate <NSObject>
@optional
- (void)HBLockCameraDidSelectLibrary;
- (void)HBLockDidCancel;
- (void)HBLockDidTakeImage:(UIImage*)img;
@end

@interface HBLockCameraView : UIView
@property (weak, nonatomic) id<HBLockCameraViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnLibrary;
@property (weak, nonatomic) IBOutlet UIButton *btnCapture;
- (IBAction)btnLibraryTouchUpInside:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFlash;
- (IBAction)btnFlashTouchUpInside:(id)sender;


- (IBAction)btnCaptureTouchUpInside:(id)sender;
- (void)starCemera;
@end
