//
//  CategoryModel.h
//  HabuTemplate
//
//  Created by Hoang Ho on 1/7/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "BaseMode.h"

@interface CategoryModel : BaseMode
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSMutableArray *items;
@end
