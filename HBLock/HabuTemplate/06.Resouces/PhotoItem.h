//
//  PhotoItem.h
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ParternModel;

@interface PhotoItem : NSManagedObject

@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSNumber * itemIndex;
@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) ParternModel *pattern;

@end
