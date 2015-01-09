//
//  HBWPCategoryModel.m
//  HBLock
//
//  Created by Hoang Ho on 1/8/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "HBWPCategoryModel.h"

@implementation HBWPCategoryModel
- (instancetype)init
{
    if (self = [super init]) {
        self.items = [NSMutableArray array];
    }
    return self;
}

@end
