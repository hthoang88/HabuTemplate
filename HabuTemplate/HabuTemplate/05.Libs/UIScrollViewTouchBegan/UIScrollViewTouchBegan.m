//
//  UIScrollViewTouchBegan.m
//  VISIKARD
//
//  Created by Hoang Ho on 6/23/14.
//
//

#import "UIScrollViewTouchBegan.h"

@implementation UIScrollViewTouchBegan
@synthesize touchDelegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.touchDelegate respondsToSelector:@selector(scrollView:touchBegan:withEvent:)]) {
        [self.touchDelegate scrollView:self touchBegan:touches withEvent:event];
    }
}

@end
