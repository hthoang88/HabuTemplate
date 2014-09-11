//
//  MainViewController.m
//  HBLock
//
//  Created by Hoang Ho on 9/11/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "MainViewController.h"

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnNumberTouchUpInside:(id)sender
{
    activeButton = sender;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerController animated:YES completion:nil];
}

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

@end
