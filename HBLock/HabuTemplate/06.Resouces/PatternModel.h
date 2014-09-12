//
//  ParternModel.h
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManagedObject.h"

@class PhotoItem;

@interface PatternModel : BaseManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * patternId;
@property (nonatomic, retain) NSString * patternName;
@property (nonatomic, retain) NSNumber * phoneType;
@property (nonatomic, retain) NSData * background;
@property (nonatomic, retain) NSData * screenShot;
@property (nonatomic, retain) NSSet *items;

+ (void)insertParternWithPatternId:(NSString*)pId
                       patternName:(NSString*)pName
                         phoneType:(int)phoneType
                        background:(UIImage*)bgImage
                         screeShot:(UIImage*)pScreenShot
                        photoItems:(NSSet*)pItems;
+ (NSArray*)getAllParterns;
@end

@interface PatternModel (CoreDataGeneratedAccessors)

- (void)addItemsObject:(PhotoItem *)value;
- (void)removeItemsObject:(PhotoItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
