//
//  MainViewController.h
//  HBLock
//
//  Created by Hoang Ho on 9/11/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@class PatternModel;
@interface MainViewController : BaseViewController

@property (strong, nonatomic) PatternModel *pattern;

@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
@property (weak, nonatomic) IBOutlet UIButton *btn0;

- (IBAction)btnNumberTouchUpInside:(id)sender;

//Top
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnYourLibrary;
@property (weak, nonatomic) IBOutlet UIButton *btnMoreIcon;

- (IBAction)btnSaveTouchUpInside:(id)sender;
- (IBAction)btnShareTouchUpInside:(id)sender;
- (IBAction)btnYourLibraryTouchUpInside:(id)sender;
- (IBAction)btnMoreIconTouchUpInside:(id)sender;

//Bottom
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnAbout;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectBackground;
- (IBAction)btnSelectBackgroundTouchUpInside:(id)sender;

- (IBAction)btnAboutTouchUpInside:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *selectPhotoView;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnLibrary;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnInstagram;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

- (IBAction)btnTakePhotoTouchUpInside:(id)sender;
- (IBAction)btnLibraryTouchUpInside:(id)sender;
- (IBAction)btnFacebookTouchUpInside:(id)sender;
- (IBAction)btnInstagramTouchUpInside:(id)sender;
- (IBAction)btnMoreTouchUpInside:(id)sender;
@end
