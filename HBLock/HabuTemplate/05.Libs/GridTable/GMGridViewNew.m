//
//  GMGridViewNew.m
//  GMGridViewExample
//
//  Created by Tai Truong on 5/2/13.
//  Copyright (c) 2013 GMoledina.ca. All rights reserved.
//

#import "GMGridViewNew.h"
#import "GMGridViewLayoutStrategies.h"
#import "GMGridViewCell+Extended.h"
#import "UIGestureRecognizer+GMGridViewAdditions.h"

@implementation GMGridViewNew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.enableEditOnLongPress = YES;
        self.disableEditOnEmptySpaceTap = YES;
    }
    return self;
}

//We override below methods

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL valid = [super gestureRecognizerShouldBegin:gestureRecognizer];
    BOOL isScrolling = self.isDragging || self.isDecelerating;
    
    if (gestureRecognizer == self.longPressGesture) {
        valid = (self.sortingDelegate || self.enableEditOnLongPress) && !isScrolling;
    }
    return valid;
}


- (void)tapGestureUpdated:(UITapGestureRecognizer *)tapGesture
{
    CGPoint locationTouch = [tapGesture locationInView:self];
    NSInteger position = [self.layoutStrategy itemPositionFromLocation:locationTouch];
    
    if (position != GMGV_INVALID_POSITION)
    {
        if (!self.editing) {
            [self cellForItemAtIndex:position].highlighted = NO;
            [self.actionDelegate GMGridView:self didTapOnItemAtIndex:position];
        }
    }
    else
    {
        if([self.actionDelegate respondsToSelector:@selector(GMGridViewDidTapOnEmptySpace:)])
        {
            [self.actionDelegate GMGridViewDidTapOnEmptySpace:self];
        }
        
        if (self.disableEditOnEmptySpaceTap) {
            //            self.editing = NO;
            //force
            for (UIView *cellView in self.subviews) {
                if ([cellView isKindOfClass:[GMGridViewCell class]]) {
                    GMGridViewCell *cell = (GMGridViewCell*)cellView;
                    if (cell.editing) {
                        cell.editing = NO;
                    }
                }
            }
            self.editing = NO;
        }
    }
}

- (void)sortingMoveDidContinueToPoint:(CGPoint)point
{
    int position = [self.layoutStrategy itemPositionFromLocation:point];
    int tag = position + kTagOffset;
    
    if (position != GMGV_INVALID_POSITION && position != _sortFuturePosition && position < _numberTotalItems)
    {
        BOOL shouldMove = YES;
        if ([self.sortingDelegate respondsToSelector:@selector(GMGridView:shouldAllowMovingCell:toIndex:)]) {
            GMGridViewCell *item = [self cellForItemAtIndex:position];
            shouldMove = [self.sortingDelegate GMGridView:self shouldAllowMovingCell:item toIndex:position];
        }
        if (!shouldMove) {
            return;
        }
        BOOL positionTaken = NO;
        
        for (UIView *v in [self itemSubviews])
        {
            if (v != _sortMovingItem && v.tag == tag)
            {
                positionTaken = YES;
                break;
            }
        }
        
        if (positionTaken)
        {
            switch (self.style)
            {
                case GMGridViewStylePush:
                {
                    if (position > _sortFuturePosition)
                    {
                        for (UIView *v in [self itemSubviews])
                        {
                            if ((v.tag == tag || (v.tag < tag && v.tag >= _sortFuturePosition + kTagOffset)) && v != _sortMovingItem )
                            {
                                v.tag = v.tag - 1;
                                [self sendSubviewToBack:v];
                            }
                        }
                    }
                    else
                    {
                        for (UIView *v in [self itemSubviews])
                        {
                            if ((v.tag == tag || (v.tag > tag && v.tag <= _sortFuturePosition + kTagOffset)) && v != _sortMovingItem)
                            {
                                v.tag = v.tag + 1;
                                [self sendSubviewToBack:v];
                            }
                        }
                    }
                    
                    [self.sortingDelegate GMGridView:self moveItemAtIndex:_sortFuturePosition toIndex:position];
                    [self relayoutItemsAnimated:YES];
                    
                    break;
                }
                case GMGridViewStyleSwap:
                default:
                {
                    if (_sortMovingItem)
                    {
                        UIView *v = [self cellForItemAtIndex:position];
                        
                        v.tag = _sortFuturePosition + kTagOffset;
                        CGPoint origin = [self.layoutStrategy originForItemAtPosition:_sortFuturePosition];
                        
                        [UIView animateWithDuration:kDefaultAnimationDuration
                                              delay:0
                                            options:kDefaultAnimationOptions
                                         animations:^{
                                             v.frame = CGRectMake(origin.x, origin.y, _itemSize.width, _itemSize.height);
                                         }
                                         completion:nil
                         ];
                    }
                    
                    [self.sortingDelegate GMGridView:self exchangeItemAtIndex:_sortFuturePosition withItemAtIndex:position];
                    
                    break;
                }
            }
        }
        
        _sortFuturePosition = position;
    }
}


- (void)sortingMoveDidStopAtPoint:(CGPoint)point
{
    [_sortMovingItem shake:NO];
    
    _sortMovingItem.tag = _sortFuturePosition + kTagOffset;
    
    CGRect frameInScroll = [self.mainSuperView convertRect:_sortMovingItem.frame toView:self];
    
    [_sortMovingItem removeFromSuperview];
    _sortMovingItem.frame = frameInScroll;
    [self addSubview:_sortMovingItem];
    
    CGPoint newOrigin = [self.layoutStrategy originForItemAtPosition:_sortFuturePosition];
    CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, _itemSize.width, _itemSize.height);
    
    [UIView animateWithDuration:kDefaultAnimationDuration
                          delay:0
                        options:0
                     animations:^{
                         _sortMovingItem.transform = CGAffineTransformIdentity;
                         _sortMovingItem.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         if ([self.sortingDelegate respondsToSelector:@selector(GMGridView:didEndMovingCell:)])
                         {
                             [self.sortingDelegate GMGridView:self didEndMovingCell:_sortMovingItem];
                         }
                         
                         _sortMovingItem = nil;
                         
                         [self setSubviewsCacheAsInvalid];
                         
                         //Again
                         for (UIView *subView in self.subviews) {
                             if ([subView isKindOfClass:[GMGridViewCell class]]) {
                                 if (subView.frame.origin.x == newOrigin.x &&
                                     subView.frame.origin.y == newOrigin.y) {
                                     ((GMGridViewCell*)subView).editing = YES;
                                 }
                             }
                         }
                         self.editing = YES;
                         
                     }
     ];
}

- (void)longPressGestureUpdated:(UILongPressGestureRecognizer *)longPressGesture
{
    if (self.enableEditOnLongPress && !self.editing) {
        CGPoint locationTouch = [longPressGesture locationInView:self];
        NSInteger position = [self.layoutStrategy itemPositionFromLocation:locationTouch];
        
        if (position != GMGV_INVALID_POSITION)
        {
            if (!self.editing) {
                self.editing = YES;
            }
            BOOL shouldReceiveGesture = NO;
            if ([self.sortingDelegate respondsToSelector:@selector(GMGridView:shouldAllowShakingBehaviorWhenMovingCell:atIndex:)])
            {
                GMGridViewCell *item = [self cellForItemAtIndex:position];
                shouldReceiveGesture = [self.sortingDelegate GMGridView:self shouldAllowShakingBehaviorWhenMovingCell:item atIndex:position];
            }
            if (shouldReceiveGesture) {
                _sortFuturePosition = GMGV_INVALID_POSITION;
                [self sortingMoveDidStartAtPoint:locationTouch];
                _sortMovingItem.editing = NO;
            }
        }
        return;
    }
    
    switch (longPressGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if (!_sortMovingItem)
            {
                CGPoint location = [longPressGesture locationInView:self];
                
                NSInteger position = [self.layoutStrategy itemPositionFromLocation:location];
                
                if (position != GMGV_INVALID_POSITION)
                {
                    [self sortingMoveDidStartAtPoint:location];
                }
                if (self.disableEditOnEmptySpaceTap) {
                    UIView *v = [self cellForItemAtIndex:0];//Item can not be edit
                    for (UIView *cellView in self.subviews) {
                        if ([cellView isKindOfClass:[GMGridViewCell class]] &&
                            cellView != v) {
                            GMGridViewCell *cell = (GMGridViewCell*)cellView;
                            if (!cell.editing ) {
                                cell.editing = YES;
                            }
                        }
                    }
                    _sortMovingItem.editing = NO;
                }
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [_sortingPanGesture end];
            
            if (_sortMovingItem)
            {
                CGPoint location = [longPressGesture locationInView:self];
                [self sortingMoveDidStopAtPoint:location];
            }
            
            break;
        }
        default:
            break;
    }
}

@end
