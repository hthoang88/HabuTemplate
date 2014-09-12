//
//  MainViewController.m
//  HBLock
//
//  Created by Hoang Ho on 9/11/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "MainViewController.h"
#import "UIActionSheet+Blocks.h"
#import "EffectCameraView_2_5.h"
#import "UIAlertView+CompletedBlock.h"
#import "PhotoItem.h"
#import "PatternModel.h"
#import "PatternLibaryViewController.h"
#import "PreviewViewController.h"

@interface MainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, EffectCameraView_2_5_Delegate>{
    UIButton *activeButton;
    BOOL isShowingMenu;
    enumPhoneType phoneType;
}

@property (nonatomic, strong) EffectCameraView_2_5 *cameraHome;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isShowingMenu = YES;
    [self showTopAndBottomView:YES];
    //    [self addLongestureForButton:self.btn0];
    //    [self addLongestureForButton:self.btn1];
    //    [self addLongestureForButton:self.btn2];
    //    [self addLongestureForButton:self.btn3];
    //    [self addLongestureForButton:self.btn4];
    //    [self addLongestureForButton:self.btn5];
    //    [self addLongestureForButton:self.btn6];
    //    [self addLongestureForButton:self.btn7];
    //    [self addLongestureForButton:self.btn8];
    //    [self addLongestureForButton:self.btn9];
}

- (EffectCameraView_2_5 *)cameraHome
{
    if (!_cameraHome) {
        _cameraHome = [[EffectCameraView_2_5 alloc] init];
    }
    
    return _cameraHome;
}

- (void)setPattern:(PatternModel *)pattern
{
    _pattern = pattern;
    self.imgBackground.image = [UIImage imageWithData:pattern.screenShot];
    for (int i = 0; i < pattern.items.count; i++) {
        PhotoItem *photoItem = [pattern.items allObjects][i];
        if (photoItem.itemIndex.intValue == 0) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn0];
        }else if (photoItem.itemIndex.intValue == 1) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn1];
        }else if (photoItem.itemIndex.intValue == 2) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn2];
        }else if (photoItem.itemIndex.intValue == 3) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn3];
        }else if (photoItem.itemIndex.intValue == 4) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn4];
        }else if (photoItem.itemIndex.intValue == 5) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn5];
        }else if (photoItem.itemIndex.intValue == 6) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn6];
        }else if (photoItem.itemIndex.intValue == 7) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn7];
        }else if (photoItem.itemIndex.intValue == 8) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn8];
        }else if (photoItem.itemIndex.intValue == 9) {
            [self changeImage:[UIImage imageWithData:photoItem.content] forNumpadButton:self.btn9];
        }
    }
}

- (void)changeImage:(UIImage*)img forNumpadButton:(UIButton*)button
{
    button.layer.borderWidth = 0.0f;
    button.layer.cornerRadius = activeButton.frame.size.width/2;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setBackgroundImage:img forState:UIControlStateHighlighted];
}

#pragma mark - UI Events

- (IBAction)btnNumberTouchUpInside:(id)sender
{
    activeButton = sender;
    [self showSelectPhotoView];
}

- (IBAction)btnSaveTouchUpInside:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initInputWithTitle:@"Enter a name for your pattern" message:@"" completion:^(BOOL cancelled, NSInteger buttonIndex, NSString *input) {
        if (!cancelled) {
            NSString *patternId = [Utils getRandStringLength:RANDOM_STRING_LENGHT];
            NSString *patternName = input;
            self.topView.hidden = self.bottomView.hidden = YES;
            [PatternModel insertParternWithPatternId:patternId
                                         patternName:patternName
                                           phoneType:phoneType
                                          background:self.imgBackground.image
                                           screeShot:[self toImage]
                                          photoItems:[self getPhotoItemOfCurrentPattern]];
            self.topView.hidden = self.bottomView.hidden = NO;
        }
    } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [alert show];
}

- (IBAction)btnShareTouchUpInside:(id)sender {
}

- (IBAction)btnYourLibraryTouchUpInside:(id)sender {
    PatternLibaryViewController *library = [[PatternLibaryViewController alloc] init];
    [self presentViewController:library animated:YES completion:nil];
}

- (IBAction)btnMoreIconTouchUpInside:(id)sender {
}

- (IBAction)btnSelectBackgroundTouchUpInside:(id)sender {
    [self showSelectPhotoView];
}

- (IBAction)btnAboutTouchUpInside:(id)sender {
}
- (IBAction)btnTakePhotoTouchUpInside:(id)sender {
    self.cameraHome.frame = CGRectMake(0, self.view.frame.size.height, WIDTH_SCREEN, self.view.frame.size.height);
    self.cameraHome.delegate = self;
    self.cameraHome.parentViewController = self;
    [self.view addSubview:self.cameraHome];
    [self.cameraHome show];
}

- (IBAction)btnLibraryTouchUpInside:(id)sender {
    [self hideSelectPhotoView];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)btnFacebookTouchUpInside:(id)sender {
}

- (IBAction)btnInstagramTouchUpInside:(id)sender {
}

- (IBAction)btnMoreTouchUpInside:(id)sender {
}

- (IBAction)btnCloseSelectPhotoViewTouchUpInside:(id)sender {
    [self hideSelectPhotoView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.selectPhotoView.superview) {
        [self hideSelectPhotoView];
    }else{
        isShowingMenu = !isShowingMenu;
        [self showTopAndBottomView:isShowingMenu];
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* _nonCropOriginalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (activeButton) {
        [self changeImage:_nonCropOriginalImage forNumpadButton:activeButton];
        activeButton = nil;
    }else{
        self.imgBackground.image = _nonCropOriginalImage;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    PreviewViewController *previewVC = [[PreviewViewController alloc] init];
    previewVC.currentImage = _nonCropOriginalImage;
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Helpers

- (void)addLongestureForButton:(UIButton*)btn
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [btn addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    
}

- (void)showSelectPhotoView
{
    [self.view addSubview:self.selectPhotoView];
    [self.view bringSubviewToFront:self.selectPhotoView];
    self.selectPhotoView.frame = RECT_WITH_Y(self.selectPhotoView.frame, -self.selectPhotoView.frame.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        self.selectPhotoView.frame = RECT_WITH_Y(self.selectPhotoView.frame, (self.view.frame.size.height - self.selectPhotoView.frame.size.height) / 2);
    }];
}

- (void)hideSelectPhotoView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.selectPhotoView.frame = RECT_WITH_Y(self.selectPhotoView.frame, -self.selectPhotoView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.selectPhotoView removeFromSuperview];
    }];
}

- (void)showTopAndBottomView:(BOOL)show
{
    CGRect oldTopFrame = show ? RECT_WITH_Y(self.topView.frame, - self.topView.frame.size.height) : self.topView.frame;
    CGRect newTopFrame = show ? RECT_WITH_Y(self.topView.frame, 0) : RECT_WITH_Y(self.topView.frame, - self.topView.frame.size.height);
    
    CGRect oldBottomFrame = show ? RECT_WITH_Y(self.bottomView.frame, self.view.frame.size.height) : self.bottomView.frame;
    CGRect newBottomFrame = show ? RECT_WITH_Y(self.bottomView.frame, self.view.frame.size.height - self.bottomView.frame.size.height) : RECT_WITH_Y(self.bottomView.frame,self.view.frame.size.height);
    
    self.topView.frame  = oldTopFrame;
    self.bottomView.frame = oldBottomFrame;
    [UIView animateWithDuration:0.5f animations:^{
        self.topView.frame = newTopFrame;
        self.bottomView.frame = newBottomFrame;
    }];
}

- (NSMutableSet*)getPhotoItemOfCurrentPattern
{
    NSMutableSet *set = [NSMutableSet set];
    PhotoItem *item0 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:0
                                                content:[self.btn0 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    PhotoItem *item1 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:1
                                                content:[self.btn1 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    PhotoItem *item2 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:2
                                                content:[self.btn2 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    PhotoItem *item3 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:3
                                                content:[self.btn3 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    PhotoItem *item4 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:4
                                                content:[self.btn4 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    PhotoItem *item5 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:5
                                                content:[self.btn5 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    PhotoItem *item6 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:6
                                                content:[self.btn6 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    PhotoItem *item7 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:7
                                                content:[self.btn7 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    PhotoItem *item8 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:8
                                                content:[self.btn8 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    PhotoItem *item9 = [PhotoItem insertPhotoItemWithId:[Utils getRandStringLength:RANDOM_STRING_LENGHT]
                                              itemIndex:9
                                                content:[self.btn9 backgroundImageForState:UIControlStateNormal]
                                                pattern:nil];
    
    [set addObject:item0];
    [set addObject:item1];
    [set addObject:item2];
    [set addObject:item3];
    [set addObject:item4];
    [set addObject:item5];
    [set addObject:item6];
    [set addObject:item7];
    [set addObject:item8];
    [set addObject:item9];
    return set;
}

- (UIImage*)toImage
{
    return [self imageWithView:self.view];
    return [self captureView:self.view withRect:self.view.bounds];
}

- (UIImage*)captureView:(UIView *)yourView withRect:(CGRect)rect {
    //this function return image with low quality
    UIGraphicsBeginImageContext(yourView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [yourView.layer renderInContext:context];
    UIImage *imageCaptureRect = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCaptureRect;
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
