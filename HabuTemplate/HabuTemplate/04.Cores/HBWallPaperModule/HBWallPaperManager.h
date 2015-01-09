//
//  HBWallPaperManager.h
//  HBLock
//
//  Created by Hoang Ho on 1/8/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HBWPCategoryModel;
@class HBWPItem;

//#define HBWP_READ_ONLY       0

#define SharedHBWPManager               [HBWallPaperManager shared]

@interface HBWallPaperManager : NSObject
+ (HBWallPaperManager*)shared;

- (NSMutableArray*)getAllCategories;

- (NSMutableArray*)getItemsOfCatgory:(HBWPCategoryModel*)ct fromOffset:(int)offset limit:(int)limit;
@end

@interface HBWallPaperManager (insert)
- (void)insertCategory:(HBWPCategoryModel*)ct;
- (void)insertItem:(HBWPItem*)it;
@end