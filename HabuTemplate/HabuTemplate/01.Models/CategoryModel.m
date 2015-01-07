//
//  CategoryModel.m
//  HabuTemplate
//
//  Created by Hoang Ho on 1/7/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel
- (instancetype)init
{
    if (self = [super init]) {
        self.items = [NSMutableArray array];
    }
    return self;
}
@end
