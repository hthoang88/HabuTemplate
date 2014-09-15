//
//  PatternLibaryViewController.h
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@class GMGridView;

@interface PatternLibraryViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) NSMutableArray *desks;
// grid tags view
@property (strong, nonatomic) GMGridView *gridView;
@property (assign, nonatomic) BOOL readOnly;

- (void)loadInterface;
- (void)loadOfflineData;
@end
