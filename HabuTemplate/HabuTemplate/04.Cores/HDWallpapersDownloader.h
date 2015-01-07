//
//  HDWallpapersDownloader.h
//  HabuTemplate
//
//  Created by Hoang Ho on 1/7/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CategoryModel;

#define SharedDownloader                [HDWallpapersDownloader sharedManager]
@interface HDWallpapersDownloader : NSObject
{
    NSMutableArray *listCategory;
}
+ (HDWallpapersDownloader*)sharedManager;
- (void)getCategoryCompletion:(void(^)(NSMutableArray *data))completion;
- (void)getItemsForCategory:(CategoryModel*)ct completion:(void(^)(NSMutableArray *items))completion;
@end
