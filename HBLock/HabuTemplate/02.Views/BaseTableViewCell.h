//
//  BaseTableViewCell.h
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewCellDelegate <NSObject>
@optional
- (void)baseCellLongGestureTask:(id)sender;
@end

@interface BaseTableViewCell : UITableViewCell
@property (weak, nonatomic) id<BaseTableViewCellDelegate> baseCellDelegate;
- (void)enableLongGestureTask:(BOOL)enable;

- (void)applyStyleIfNeed;
- (void)setObject:(id)obj;
@end
