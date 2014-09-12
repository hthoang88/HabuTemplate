//
//  PhotoItem.h
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManagedObject.h"

@class PatternModel;

@interface PhotoItem : BaseManagedObject

@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSNumber * itemIndex;
@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) PatternModel *pattern;

+ (PhotoItem*)insertPhotoItemWithId:(NSString*)iId
                          itemIndex:(int)iIndex
                            content:(UIImage*)iContent
                            pattern:(PatternModel*)pattern autoSave:(BOOL)autoSave;


+ (PhotoItem*)insertPhotoItemWithId:(NSString*)iId
                          itemIndex:(int)iIndex
                            content:(UIImage*)iContent
                            pattern:(PatternModel*)pattern;
@end
