//
//  EffectCameraView_2_5.h
//  VISIKARD
//
//  Created by Tai Truong on 3/4/13.
//
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"


@class EffectCameraView_2_5;

@protocol EffectCameraView_2_5_Delegate <NSObject>

@optional
-(BOOL)effectCameraViewShouldCancel:(EffectCameraView_2_5*)view;
-(void)effectCameraViewDidCancel:(EffectCameraView_2_5*)view;
-(void)effectCameraView:(EffectCameraView_2_5*)view didSavePhoto:(UIImage*)filteredImage originalImage:(UIImage*)originalImage filterNumber:(NSInteger)filterIndex;
-(void)effectCameraView:(EffectCameraView_2_5*)view didSavePhoto:(UIImage*)filteredImage fullSizeFilteredImage:(UIImage*)fullFilterdImage originalImage:(UIImage*)originalImage filterNumber:(NSInteger)filterIndex;

-(void)effectCameraViewDidRetake:(EffectCameraView_2_5*)view;
@end


@interface EffectCameraView_2_5 : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate>
{
    GPUImageStillCamera                 *_stillCamera;
    GPUImageOutput<GPUImageInput>       *_filter, *_cropFilter, *_originalFilter;
    GPUImagePicture                     *sourcePicture, *_originalPicture;
    UIImage                             *_nonCropOriginalImage;//*originalImage,
    enumPhotoViewType                   _viewType;
    BOOL                                flgFromNewAlbumView;
    NSString                            *accessToken;
}
@property (strong, nonatomic) UIImage               *originalImage;

@property (weak, nonatomic) IBOutlet GPUImageView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *cameraMenuView;


@property (weak, nonatomic) IBOutlet UIButton *flashBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnFlashIcon;

@property (weak, nonatomic) IBOutlet UIButton *photoSelectBtn;


@property (weak, nonatomic) id<EffectCameraView_2_5_Delegate> delegate;
@property (weak, nonatomic) UIViewController *parentViewController;

//Property to disable filer image function
@property (assign, nonatomic) BOOL disableFilterImage;


- (IBAction)capturePhoto:(id)sender;
- (IBAction)changeFlashModeTouchUpInside:(id)sender;
- (IBAction)changeCameraSideTouchUpInside:(id)sender;//change camera
- (IBAction)cancelTouchUpInside:(id)sender;
- (IBAction)libraryTouchUpInside:(id)sender;


- (void)close;
- (void)show;

-(id)initWithFlag:(BOOL)isFromSignUp;
-(id)initFromNewAlbumView;

-(void)changeImagePreviewViewWithAnimation;

@property (weak, nonatomic) IBOutlet UILabel *lbAddPhoto;
@property (weak, nonatomic) IBOutlet UIView *addPhotoHeaderView;

@end


@interface UIImage (Rotate)
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
@end