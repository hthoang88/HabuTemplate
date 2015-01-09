//
//  HBWPCategoryModel.h
//  HBLock
//
//  Created by Hoang Ho on 1/8/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "BaseModel.h"

@interface HBWPCategoryModel : BaseModel
@property (strong, nonatomic) NSString *categoryID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *numberItems;
@property (strong, nonatomic) NSString *thumnailUrl;
@property (strong, nonatomic) NSMutableArray *items;
@end
