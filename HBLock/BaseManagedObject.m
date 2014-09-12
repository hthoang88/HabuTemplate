//
//  BaseManagedObject.m
//  HBStory
//
//  Created by Hoang Ho on 8/6/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseManagedObject.h"

@implementation BaseManagedObject

- (NSString *)description
{
    return [Utils autoDescribe:self];
}

+ (NSArray*)getItemsWithPredicate:(NSPredicate*)pre
                          sort:(NSSortDescriptor*)sort
{
    NSManagedObjectContext *_managedObjectContext =  sharedManageObjectContent;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:pre];
    if (sort) {
        fetchRequest.sortDescriptors = @[sort];
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return items;
}

+ (NSString *)entityName
{
    return nil;
}

@end
