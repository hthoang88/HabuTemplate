//
//  HBLockCameraView.m
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "HBLockCameraView.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface HBLockCameraView(){
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageView *primaryView;
}

@end


@implementation HBLockCameraView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HBLockCameraView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        primaryView = [[GPUImageView alloc] initWithFrame:frame];
        primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        stillCamera = [[GPUImageStillCamera alloc] init];
        stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        filter = [[GPUImageBrightnessFilter alloc] init];
        [stillCamera addTarget:filter];
        [filter addTarget:primaryView];
        [self addSubview:primaryView];
        [self sendSubviewToBack:primaryView];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (index != NSNotFound) {
                    if (index == group.numberOfAssets - 1) {
                        UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                        [self.btnLibrary setBackgroundImage:image forState:UIControlStateNormal];
                        self.btnLibrary.layer.borderWidth = 0.5f;
                        self.btnLibrary.layer.borderColor = [UIColor orangeColor].CGColor;
                    }
                    
                }
            }];
        } failureBlock:nil];
    }
    return self;
}

- (void)starCemera
{
    [stillCamera startCameraCapture];
}

- (IBAction)btnLibraryTouchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(HBLockCameraDidSelectLibrary)]) {
        [self.delegate performSelector:@selector(HBLockCameraDidSelectLibrary) withObject:nil];
    }
}

- (IBAction)btnFlashTouchUpInside:(id)sender {
}

- (IBAction)btnCaptureTouchUpInside:(id)sender {
    [sender setEnabled:NO];
    
    // get non-crop image
    [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(HBLockDidTakeImage:)]) {
            [self.delegate performSelector:@selector(HBLockDidTakeImage:) withObject:processedImage];
        }
    }];
    [stillCamera pauseCameraCapture];
}

- (IBAction)btnCancelTouchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(HBLockDidCancel)]) {
        [self.delegate performSelector:@selector(HBLockDidCancel) withObject:nil];
    }
}

- (IBAction)btnSwitchCameraTouchUpInside:(id)sender {
     [stillCamera rotateCamera];
    self.btnFlash.hidden  = stillCamera.cameraPosition ==AVCaptureDevicePositionFront;
}
@end
