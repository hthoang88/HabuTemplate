//
//  UIScrollViewTouchBegan.h
//  VISIKARD
//
//  Created by Hoang Ho on 6/23/14.
//
//
#import <UIKit/UIKit.h>

@protocol UIScrollViewTouchBeganDelegate <NSObject>

@optional
-(void)scrollView:(UIScrollView*)scrollView touchBegan:(NSSet*) touches withEvent:(UIEvent*)event;

@end

@interface UIScrollViewTouchBegan : UIScrollView

@property (nonatomic, assign) id <UIScrollViewTouchBeganDelegate> touchDelegate;
@end