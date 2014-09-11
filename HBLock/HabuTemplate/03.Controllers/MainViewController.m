//
//  MainViewController.m
//  HBLock
//
//  Created by Hoang Ho on 9/11/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "MainViewController.h"
#import "UIActionSheet+Blocks.h"

@interface MainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIButton *activeButton;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - UI Events

- (IBAction)btnNumberTouchUpInside:(id)sender
{
    activeButton = sender;
    [self showSelectPhotoView];
}

- (IBAction)btnSaveTouchUpInside:(id)sender {
}

- (IBAction)btnShareTouchUpInside:(id)sender {
}

- (IBAction)btnYourLibraryTouchUpInside:(id)sender {
}

- (IBAction)btnMoreIconTouchUpInside:(id)sender {
}
- (IBAction)btnAboutTouchUpInside:(id)sender {
}
- (IBAction)btnTakePhotoTouchUpInside:(id)sender {
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.selectPhotoView.superview) {
        [self hideSelectPhotoView];
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* _nonCropOriginalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    activeButton.layer.borderWidth = 0.0f;
    activeButton.layer.cornerRadius = activeButton.frame.size.width/2;
    activeButton.layer.masksToBounds = YES;
    [activeButton setBackgroundImage:_nonCropOriginalImage forState:UIControlStateNormal];
    [activeButton setBackgroundImage:_nonCropOriginalImage forState:UIControlStateHighlighted];
    for (UIButton *btn in self.view.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.hidden = NO;
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
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
@end
