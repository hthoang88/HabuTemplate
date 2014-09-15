//
//  BaseViewController.m
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL) automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
    return YES;
}

//For iO6

// iOS 6.x and later
- (BOOL)shouldAutorotate {
    return [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait;
}
//for ios 7
- (NSUInteger)supportedInterfaceOrientations {
    //for ipad
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return  YES;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return  YES;
}
@end
