//
//  EffectCameraView_2_5.m
//  VISIKARD
//
//  Created by Tai Truong on 3/4/13.
//
//

#import "EffectCameraView_2_5.h"
#import "Define.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>

#define ANIMATION_DURATION 0.8f
#define FILTER_ICON_WIDTH           66
#define ICON_SIZE_HEIGHT            76
#define IMAGE_ICON_SIZE             56
#define ICON_MARGIN                 0
#define ICON_PADDING                0
#define LABEL_VIEW_TAG      10000
#define BORDER_VIEW_TAG     20000
#define ICON_VIEW_TAG       30000
#define CROPVIEW_IMAGE_POS_Y        40
#define CAMERAVIEW_SUBVIEW_PADDING 0

@interface EffectCameraView_2_5()

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@end

@implementation EffectCameraView_2_5
{
    // using to enhance photo
    CIContext *context;
    CIImage *beginImage;
    CGRect portraitViewRect;
   
    float currenRadius;
}

@synthesize originalImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init {
    self = [[[NSBundle mainBundle] loadNibNamed:[self.class description] owner:self options:nil] objectAtIndex:0];

    if (self) {
        context = [CIContext contextWithOptions:nil];
        
        [self initCameraView];
       
        flgFromNewAlbumView = YES;
        
        //
        _photoSelectBtn.layer.cornerRadius = 4.0f;
        _photoSelectBtn.layer.masksToBounds = YES;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (index != NSNotFound) {
                    if (index == group.numberOfAssets - 1) {
                        UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                        [_photoSelectBtn setBackgroundImage:image forState:UIControlStateNormal];
                    }
                    
                }
            }];
        } failureBlock:nil];
        
        _cancelButton.imageView .contentMode = UIViewContentModeScaleAspectFit;
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_white_cancel"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_white_cancel"] forState:UIControlStateHighlighted];
        
        [_flashBtn setTitle:@"Auto" forState:UIControlStateNormal];
    }

    return self;
}

-(id)initWithFlag:(BOOL)isFromSignUp {
    self = [self init];
    
    return self;
}

-(id)initFromNewAlbumView {
    self = [self init];
    
    flgFromNewAlbumView = YES;
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)initCameraView
{
    self.cameraView.hidden = self.cameraMenuView.hidden = NO;
    CGRect imgRect = self.frame;
    imgRect.size.height = 384;
    CGFloat offsetY = 0;
    if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
        offsetY = -60;
        imgRect.size.height = 472;
    }
    float delta = 60;//new layout
    self.cameraView.frame = CGRectMake(0, offsetY, WIDTH_SCREEN, HEIGH_SCREEN - HEIGHT_STATUS_BAR + delta);
    for (UIView *subView in self.cameraView.subviews)
    {
        CGRect r = subView.frame;
        r.origin.y = r.origin.y - offsetY;
        subView.frame = r;
    }
    _viewType = enumPhotoViewType_Camera;
}

-(void)changeImagePreviewViewWithAnimation
{
//    self.photoSelectBtn.enabled = NO;
//    self.viewForCaseFromNewAlbumView.hidden = YES;
//    self.bg_viewForCaseFromNewAlbumView.hidden = self.viewForCaseFromNewAlbumView.hidden;
//    // show photo with filter
//    [self setupImageFilter:_filterListView.selectedIndexPath.row];
//    
//    [UIView transitionFromView:self.cameraView toView:self.imagePreviewMenuView duration:ANIMATION_DURATION options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionShowHideTransitionViews  completion:nil];
//    [UIView transitionFromView:self.cameraMenuView toView:self.viewForEffectsBottom duration:ANIMATION_DURATION options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionShowHideTransitionViews  completion:^(BOOL finished) {
//        self.btnRotate.frame = CGRectMake((self.frame.size.width - self.btnRotate.frame.size.width)/2, self.viewForEffectsBottom.frame.origin.y - self.btnRotate.frame.size.height - 5, self.btnRotate.frame.size.width, self.btnRotate.frame.size.height);
//        self.btnRotate.hidden = NO;
//    }];
//    _viewType = enumPhotoViewType_Preview;
}

-(void)changeBackToCameraViewWithAnimation
{
    // show photo with filter
//    [_stillCamera resumeCameraCapture];
//    self.btnRotate.hidden = YES;
//    [self setupFilter:_filterListView.selectedIndexPath.row];
//    
//    [UIView transitionFromView:self.imagePreviewMenuView toView:self.cameraView duration:ANIMATION_DURATION options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionShowHideTransitionViews  completion:^(BOOL finished) {
//        
//    }];
//    [UIView transitionFromView:self.viewForEffectsBottom toView:self.cameraMenuView duration:ANIMATION_DURATION options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionShowHideTransitionViews  completion:^(BOOL finished) {
//        [self sendSubviewToBack:self.cameraView];
//    }];
//    _viewType = enumPhotoViewType_Camera;
}

-(void)close
{
    [_stillCamera stopCameraCapture];
    
    [ UIView beginAnimations:@"BringDownCameraView" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(bringDownCameraViewCompletion:finished:context:)];
    self.frame = CGRectMake(0, self.parentViewController.view.frame.size.height, WIDTH_SCREEN, self.parentViewController.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)show
{
    // Present Up View animation
    [ UIView beginAnimations:@"BringUpCameraView" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.frame = CGRectMake(0, 0, WIDTH_SCREEN, self.parentViewController.view.frame.size.height);
    [UIView commitAnimations];
    
    // Fade in/out animation
    //    [UIView transitionWithView:self.parentViewController.view duration:ANIMATION_DURATION options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    //        [self.parentViewController.view addSubview:self];
    //    } completion:nil];
}

- (void) bringDownCameraViewCompletion:(NSString *) aniname finished:(BOOL) finished context:(void *) context {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(effectCameraViewDidCancel:)]) {
        [self.delegate effectCameraViewDidCancel:self];
    }
}

#pragma mark - Actions

- (IBAction)capturePhoto:(id)sender {
    [sender setEnabled:NO];
    
    // get non-crop image
    [_stillCamera capturePhotoAsImageProcessedUpToFilter:_originalFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        _nonCropOriginalImage = processedImage;
        // Save to assets library
        CGFloat scaleRatio = (CGFloat)640.0 / processedImage.size.width;
        CGSize newsize = CGSizeMake(640.0, _nonCropOriginalImage.size.height * scaleRatio);
        NSLog(@"Newsize %f %f", newsize.width, newsize.height);
        UIGraphicsBeginImageContext(newsize);
        [_nonCropOriginalImage drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
        _nonCropOriginalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        originalImage = [_nonCropOriginalImage copy];//[UIImage imageWithCGImage:tmp];
        // release the memory
        //        CGImageRelease(tmp);
        [sender setEnabled:YES];

        if (self.disableFilterImage) {
            if ([self.delegate respondsToSelector:@selector(effectCameraView:didSavePhoto:originalImage:filterNumber:)]) {
                [self.delegate effectCameraView:self didSavePhoto:nil originalImage:originalImage filterNumber:0];
            }
        }else{
            [self changeImagePreviewViewWithAnimation];
        }
    }];
    [_stillCamera pauseCameraCapture];
}

- (IBAction)changeFlashModeTouchUpInside:(id)sender {
    UIButton *button = (UIButton*)sender;
    button.tag += 1;
    [_stillCamera.inputCamera lockForConfiguration:nil];
    if(button.tag%3 == 1) {
        [_flashBtn setTitle:@"Off" forState:UIControlStateNormal];
        [_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOff];
    } else if (button.tag%3 == 0) {
        [_flashBtn setTitle:@"Auto" forState:UIControlStateNormal];
        [_stillCamera.inputCamera  setFlashMode:AVCaptureFlashModeAuto];
    }else
    {
        [_flashBtn setTitle:@"On" forState:UIControlStateNormal];
        [_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
    }
    [_stillCamera.inputCamera unlockForConfiguration];
}

- (IBAction)changeCameraSideTouchUpInside:(id)sender {
    [_stillCamera rotateCamera];
    
    // check flash is support on device
    self.flashBtn.enabled = [_stillCamera.inputCamera isFlashAvailable];
    //hidden flash buttons for front camera
    self.btnFlashIcon.hidden  = self.flashBtn.hidden = _stillCamera.cameraPosition ==AVCaptureDevicePositionFront;
}

- (IBAction)cancelTouchUpInside:(id)sender {

    [_stillCamera.inputCamera lockForConfiguration:nil];
    if ([_stillCamera.inputCamera isFlashAvailable]) {
        [_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeAuto];
        [_stillCamera.inputCamera unlockForConfiguration];
    }
    if ([self.delegate respondsToSelector:@selector(effectCameraViewShouldCancel:)]) {
        if([self.delegate effectCameraViewShouldCancel:self])
            [self close];
    }
    else {
        [self close];
    }
}

- (IBAction)libraryTouchUpInside:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    imagePickerController.allowsEditing = YES;
    [self.parentViewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark VKCameraRollViewControllerDelegate

- (void)selectedPhotos:(NSArray*)dataArray {
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _nonCropOriginalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.disableFilterImage) {
        if ([self.delegate respondsToSelector:@selector(effectCameraView:didSavePhoto:originalImage:filterNumber:)]) {
            [self.delegate effectCameraView:self didSavePhoto:nil originalImage:originalImage filterNumber:0];
        }
    }else{
        [self changeImagePreviewViewWithAnimation];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
CGFloat degreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat radiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (Rotate)
- (UIImage *)imageRotatedByRadians:(CGFloat)radians {
    return [self imageRotatedByDegrees:radiansToDegrees(radians)];
}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    // Rotate the image context
    CGContextRotateCTM(bitmap, degreesToRadians(degrees));
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
