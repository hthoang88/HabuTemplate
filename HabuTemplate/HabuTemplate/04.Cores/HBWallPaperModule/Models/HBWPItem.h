//
//  HBWPItem.h
//  HBLock
//
//  Created by Hoang Ho on 1/8/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "BaseModel.h"

@interface HBWPItem : BaseModel
@property (strong, nonatomic) NSString *itemID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *thumnailUrl;
@property (strong, nonatomic) NSString *originUrl;
@property (strong, nonatomic) NSString *categoryID;
@property (strong, nonatomic) NSNumber *position;//for sorting

- (void)downloadOriginImageCompletion:(void(^)(UIImage *downloadedImage, NSError* err))completion;
@end
