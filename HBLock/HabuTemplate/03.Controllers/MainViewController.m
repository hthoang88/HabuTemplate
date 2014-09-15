//
//  MainViewController.m
//  HBLock
//
//  Created by Hoang Ho on 9/11/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "MainViewController.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+CompletedBlock.h"
#import "PhotoItem.h"
#import "PatternModel.h"
#import "PatternLibraryViewController.h"
#import "PreviewView.h"
#import "HBLockCameraView.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "UIImage+HBLock.h"
#import "HBInstagramSelectionPhotoView.h"
#import "FacebookHelper.h"

@interface MainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, HBLockCameraViewDelegate, UIPopoverControllerDelegate>{
    UIButton *activeButton;
    UIView *activeView;
    BOOL isShowingMenu;
    
    enumPhoneType phoneType;
    HBLockCameraView *cameraView;
    PreviewView *preview;
    HBInstagramSelectionPhotoView *instagramSelectionView;
    UIPopoverController *popOver;
}

@end

@implementation MainViewController

- (NSString*)getDesForButton:(UIButton*)btn
{
    return [NSString stringWithFormat:@"\"%.0f,%.0f,%.0f,%.0f\",",btn.frame.origin.x,btn.frame.origin.y,btn.frame.size.width,btn.frame.size.height];
}

- (void)testFrame
{
    NSMutableString *st = [NSMutableString string];
    [st appendFormat:@"\"button0\" : %@",[self getDesForButton:self.btn0]];
    [st appendFormat:@"\n\"button1\" : %@",[self getDesForButton:self.btn1]];
    [st appendFormat:@"\n\"button2\" : %@",[self getDesForButton:self.btn2]];
    [st appendFormat:@"\n\"button3\" : %@",[self getDesForButton:self.btn3]];
    [st appendFormat:@"\n\"button4\" : %@",[self getDesForButton:self.btn4]];
    [st appendFormat:@"\n\"button5\" : %@",[self getDesForButton:self.btn5]];
    [st appendFormat:@"\n\"button6\" : %@",[self getDesForButton:self.btn6]];
    [st appendFormat:@"\n\"button7\" : %@",[self getDesForButton:self.btn7]];
    [st appendFormat:@"\n\"button8\" : %@",[self getDesForButton:self.btn8]];
    [st appendFormat:@"\n\"button9\" : %@",[self getDesForButton:self.btn9]];
}

- (void)layoutPatternFromFile
{
    NSString* filePath = @"patterns";
    NSString* fileRoot = [[NSBundle mainBundle]
                          pathForResource:filePath ofType:@"txt"];
    NSString* fileContents =
    [NSString stringWithContentsOfFile:fileRoot
                              encoding:NSUTF8StringEncoding error:nil];
    NSData *webData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    
    NSArray *items = [jsonDict objectForKey:@"items"];
    
    phoneType =dataCenterInstanced.currentPhoneType;
    
    for (NSDictionary *dict in items) {
        if ([dict[@"type"] integerValue] == phoneType) {
            [self changeFrameForButton:self.btn0 withStr:dict[@"button0"]];
            [self changeFrameForButton:self.btn1 withStr:dict[@"button1"]];
            [self changeFrameForButton:self.btn2 withStr:dict[@"button2"]];
            [self changeFrameForButton:self.btn3 withStr:dict[@"button3"]];
            [self changeFrameForButton:self.btn4 withStr:dict[@"button4"]];
            [self changeFrameForButton:self.btn5 withStr:dict[@"button5"]];
            [self changeFrameForButton:self.btn6 withStr:dict[@"button6"]];
            [self changeFrameForButton:self.btn7 withStr:dict[@"button7"]];
            [self changeFrameForButton:self.btn8 withStr:dict[@"button8"]];
            [self changeFrameForButton:self.btn9 withStr:dict[@"button9"]];
        }
    }
}

- (void)changeFrameForButton:(UIButton*)btn withStr:(NSString*)str{
    NSArray *arr = [str componentsSeparatedByString:@","];
    btn.frame = CGRectMake([arr[0] integerValue], [arr[1] integerValue], [arr[2] integerValue], [arr[3] integerValue]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isShowingMenu = YES;
    [self showTopAndBottomView:YES];
    [self setBackgroundImage:[UIImage imageNamed:@"Stars.jpg"]];
    [[FacebookHelper shared] getListFriendsOnComplete:^(NSMutableArray *arrFriends) {
        
    } onError:^(NSError *error) {
        
    }];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutPatternFromFile];
//    [self testFrame];
}

- (void)setBackgroundImage:(UIImage*)image
{
    CGSize size = CGSizeMake(WIDTH_SCREEN/4, HEIGH_SCREEN/4);
    size = [self calculateSizeToCrop:image size:size];
    double x = (image.size.width - size.width) / 2.0;
    double y = (image.size.height - size.height) / 2.0;
    UIImage *scaleImage = [image imageByCropWithNewSize:size point:CGPointMake(x, y)];
    
    self.imgBackground.image = scaleImage;
}

- (void)setPattern:(PatternModel *)pattern
{
    _pattern = pattern;
    UIImage *image = [UIImage imageWithData:pattern.screenShot];
    [self setBackgroundImage:image];
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
    button.layer.cornerRadius = button.frame.size.width/2;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setBackgroundImage:img forState:UIControlStateHighlighted];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setTitle:@"" forState:UIControlStateHighlighted];
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
            UIImage *img = [self toImage];
            
            [Utils showHUDForView:self.view];
            
            [PatternModel insertParternWithPatternId:patternId
                                         patternName:patternName
                                           phoneType:phoneType
                                          background:self.imgBackground.image
                                           screeShot:img
                                          photoItems:[self getPhotoItemOfCurrentPattern]];
            self.topView.hidden = self.bottomView.hidden = NO;
            
            ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
            [library saveImage:img toAlbum:@"HBLock" withCompletionBlock:^(NSError *error) {
                [Utils hideHUDForView:self.view];
            }];
        }
    } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [alert show];
}

- (IBAction)btnYourLibraryTouchUpInside:(id)sender {
    PatternLibraryViewController *library = [[PatternLibraryViewController alloc] init];
    [self presentViewController:library animated:YES completion:nil];
}

- (IBAction)btnSelectBackgroundTouchUpInside:(id)sender {
    activeView = sender;
    [self showSelectPhotoView];
}

- (IBAction)btnAboutTouchUpInside:(id)sender {
    activeView = sender;
}

- (void)changeToPhotoPriviewViewWithImage:(UIImage*)image onCompletion:(void(^)(UIImage *image, BOOL isCancel))completion
{
    preview = [[PreviewView alloc] initWithFrame:self.view.bounds];
    preview.imgBackground.image =image;
    preview.completeBlock = completion;
    preview.targetView = activeButton;
    [self.view addSubview:preview];
    [self.view bringSubviewToFront:preview];
}

- (IBAction)btnTakePhotoTouchUpInside:(id)sender {
    [self hideSelectPhotoView:NO];
    cameraView  = [[HBLockCameraView alloc] initWithFrame:self.view.bounds];
    cameraView.frame = RECT_WITH_Y(cameraView.frame, HEIGH_SCREEN);
    cameraView.delegate = self;
    [self.view addSubview:cameraView];
    [self.view bringSubviewToFront:cameraView];
    [UIView animateWithDuration:0.5f animations:^{
        cameraView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        [cameraView starCemera];
    }];
}

- (IBAction)btnLibraryTouchUpInside:(id)sender {
    [self hideSelectPhotoView:NO];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)btnFacebookTouchUpInside:(id)sender {
}

- (IBAction)btnInstagramTouchUpInside:(id)sender {
    [self hideSelectPhotoView:NO];
    instagramSelectionView = [[HBInstagramSelectionPhotoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:instagramSelectionView];
    [self.view bringSubviewToFront:instagramSelectionView];
    instagramSelectionView.frame = RECT_WITH_Y(instagramSelectionView.frame, -instagramSelectionView.frame.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        instagramSelectionView.frame = RECT_WITH_Y(instagramSelectionView.frame, 0);
    }];
}

- (IBAction)btnMoreTouchUpInside:(id)sender {
}

- (IBAction)btnCloseSelectPhotoViewTouchUpInside:(id)sender {
    [self hideSelectPhotoView:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.selectPhotoView.superview) {
        [self hideSelectPhotoView:YES];
    }else{
        isShowingMenu = !isShowingMenu;
        [self showTopAndBottomView:isShowingMenu];
    }
}

#pragma mark - HBLockCameraDelegate
- (void)HBLockDidCancel
{
    [UIView animateWithDuration:0.5f animations:^{
        cameraView.frame = RECT_WITH_Y(cameraView.frame, HEIGH_SCREEN);
    } completion:^(BOOL finished) {
        [cameraView removeFromSuperview];
        cameraView = nil;
    }];
}

- (void)HBLockCameraDidSelectLibrary
{
    [UIView animateWithDuration:0.5f animations:^{
        cameraView.frame = RECT_WITH_Y(cameraView.frame, HEIGH_SCREEN);
    } completion:^(BOOL finished) {
        [cameraView removeFromSuperview];
        cameraView = nil;
        [self btnLibraryTouchUpInside:self.btnLibrary];
    }];
}

- (void)HBLockDidTakeImage:(UIImage *)img
{
    [UIView animateWithDuration:0.5f animations:^{
        cameraView.frame = RECT_WITH_Y(cameraView.frame, HEIGH_SCREEN);
    } completion:^(BOOL finished) {
        [cameraView removeFromSuperview];
        cameraView = nil;
        if (activeButton) {
            [self changeToPhotoPriviewViewWithImage:img onCompletion:^(UIImage *image, BOOL isCancel) {
                if (!isCancel) {
                    [self changeImage:image forNumpadButton:activeButton];
                    activeButton = nil;
                }
            }];
        }else{
            UIImage *image = img;
            [self setBackgroundImage:image];
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* _nonCropOriginalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (activeButton) {
        [self changeToPhotoPriviewViewWithImage:_nonCropOriginalImage onCompletion:^(UIImage *image, BOOL isCancel) {
            if (!isCancel) {
                [self changeImage:image forNumpadButton:activeButton];
            }
            activeButton = nil;
        }];
    }else{
        self.imgBackground.image = _nonCropOriginalImage;
        activeView = nil;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    activeView = nil;
    activeButton = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.selectPhotoView removeFromSuperview];
    activeView = nil;
    activeButton = nil;
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
    if (IS_IPHONE) {
        [self.view addSubview:self.selectPhotoView];
        [self.view bringSubviewToFront:self.selectPhotoView];
        self.selectPhotoView.frame = RECT_WITH_Y(self.selectPhotoView.frame, -self.selectPhotoView.frame.size.height);
        [UIView animateWithDuration:0.5f animations:^{
            self.selectPhotoView.frame = RECT_WITH_Y(self.selectPhotoView.frame, (self.view.frame.size.height - self.selectPhotoView.frame.size.height) / 2);
        }];
    }else{
        [self showSelectionPopupFromView:activeButton ? activeButton : activeView];
    }
}

- (void)showSelectionPopupFromView:(UIView*)aView
{
    UIViewController *tempVC = [[UIViewController alloc] init];
    tempVC.preferredContentSize = CGSizeMake(self.selectPhotoView.frame.size.width + 30, self.selectPhotoView.frame.size.height + 30);
    [tempVC.view addSubview:self.selectPhotoView];
    self.selectPhotoView.frame = RECT_WITH_X_Y(self.selectPhotoView.frame, 15, 15);
    tempVC.view.backgroundColor =[UIColor clearColor];
    
    popOver = [[UIPopoverController alloc] initWithContentViewController:tempVC];
    popOver.popoverContentSize = tempVC.preferredContentSize;
    popOver.backgroundColor = [UIColor clearColor];
    popOver.delegate =self;
    [popOver presentPopoverFromRect:aView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)hideSelectPhotoView:(BOOL)resetSelection
{
    if (IS_IPHONE) {
        [UIView animateWithDuration:0.5f animations:^{
            self.selectPhotoView.frame = RECT_WITH_Y(self.selectPhotoView.frame, -self.selectPhotoView.frame.size.height);
        } completion:^(BOOL finished) {
            [self.selectPhotoView removeFromSuperview];
            if (resetSelection)
                activeView = activeButton = nil;
        }];
    }else{
        [popOver dismissPopoverAnimated:YES];
        [self.selectPhotoView removeFromSuperview];
        if (resetSelection)
            activeView = activeButton = nil;
    }
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
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (CGSize)calculateSizeToCrop:(UIImage*)image size:(CGSize)size
{
    CGSize tempSize = CGSizeMake(size.width, size.height);
    int widthDelta =size.width;
    int heightDelta = size.height;
    
    while (tempSize.width < image.size.width && tempSize.height < image.size.height) {
        if (tempSize.width + widthDelta < image.size.width &&
            tempSize.height + heightDelta < image.size.height) {
            tempSize.width += widthDelta;
            tempSize.height += heightDelta;
        }else
            break;
    }
    return tempSize;
}

@end
