//
//  PreviewViewController.m
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "PreviewViewController.h"
#import "SPUserResizableView.h"

@interface PreviewViewController (){
    UIView* dropTarget;
    UIView* dragObject;
CGPoint touchOffset;
CGPoint homePosition;
}

@end

@implementation PreviewViewController

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
    dropTarget = self.view;
    dragObject = self.imgNumberPad;
    self.imgBackground.image = self.currentImage;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect frame = self.imgNumberPad.frame;
    SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:frame];
//    UIView *contentView = [[UIView alloc] initWithFrame:frame];
//    [contentView setBackgroundColor:[UIColor redColor]];
    userResizableView.contentView = self.imgNumberPad;
    [self.view addSubview:userResizableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([touches count] == 1) {
//        // one finger
//        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
//        for (UIImageView *iView in self.view.subviews) {
//            if ([iView isMemberOfClass:[UIImageView class]]) {
//                if (touchPoint.x > iView.frame.origin.x &&
//                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
//                    touchPoint.y > iView.frame.origin.y &&
//                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
//                {
//                    dragObject = iView;
//                    touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
//                                                   touchPoint.y - iView.frame.origin.y);
//                    homePosition = CGPointMake(iView.frame.origin.x,
//                                                    iView.frame.origin.y);
//                    [self.view bringSubviewToFront:dragObject];
//                }
//            }
//        }
//    }
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
//    CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x,
//                                           touchPoint.y - touchOffset.y,
//                                           dragObject.frame.size.width,
//                                           dragObject.frame.size.height);
//    dragObject.frame = newDragObjectFrame;
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
////    if (touchPoint.x > dropTarget.frame.origin.x &&
////        touchPoint.x < dropTarget.frame.origin.x + dropTarget.frame.size.width &&
////        touchPoint.y > dropTarget.frame.origin.y &&
////        touchPoint.y < dropTarget.frame.origin.y + dropTarget.frame.size.height )
////    {
////        dropTarget.backgroundColor = dragObject.backgroundColor;
////        
////    }
////    dragObject.frame = CGRectMake(homePosition.x, homePosition.y,
////                                       dragObject.frame.size.width,
////                                       dragObject.frame.size.height);
//}

@end
