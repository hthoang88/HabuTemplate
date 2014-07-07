//
//  BaseTableViewCell.m
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell()
{
    BOOL appliedStyle;
    BOOL enableLongGesture;
    id senderObj;
}
@end

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)applyStyleIfNeed
{
    if (appliedStyle) {
        return;
    }
    appliedStyle = YES;
}

- (void)setObject:(id)obj
{
    senderObj = obj;
}

- (void)enableLongGestureTask:(BOOL)enable
{
    if (!enableLongGesture) {
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapOnCell:)];
        [self addGestureRecognizer:longGesture];
        enableLongGesture = YES;
    }
}

- (void)longTapOnCell:(id)sender
{
    if ([self.baseCellDelegate respondsToSelector:@selector(baseCellLongGestureTask:)] && senderObj) {
        [self.baseCellDelegate performSelector:@selector(baseCellLongGestureTask:) withObject:senderObj];
    }
}
@end
