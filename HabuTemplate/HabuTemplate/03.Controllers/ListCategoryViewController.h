//
//  ListCategoryViewController.h
//  HabuTemplate
//
//  Created by Hoang Ho on 1/7/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface ListCategoryViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
+ (UIView*)getInstancedView;
@property (weak, nonatomic) IBOutlet UITableView *tbCategories;

@end
