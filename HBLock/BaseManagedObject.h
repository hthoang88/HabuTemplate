//
//  BaseManagedObject.h
//  HBStory
//
//  Created by Hoang Ho on 8/6/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface BaseManagedObject : NSManagedObject

+ (NSArray*)getItemsWithPredicate:(NSPredicate*)pre
                          sort:(NSSortDescriptor*)sort;

+ (NSString*)entityName;
@end
