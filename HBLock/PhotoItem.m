//
//  PhotoItem.m
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "PhotoItem.h"
#import "PatternModel.h"


@implementation PhotoItem

@dynamic itemId;
@dynamic itemIndex;
@dynamic content;
@dynamic pattern;

+ (PhotoItem*)insertPhotoItemWithId:(NSString*)iId
                          itemIndex:(int)iIndex
                            content:(UIImage*)iContent
                            pattern:(PatternModel*)pattern autoSave:(BOOL)autoSave
{
    NSManagedObjectContext *_managedObjectContext = sharedManageObjectContent;
    
    PhotoItem *category = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:_managedObjectContext];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    category.itemId = iId;
    category.itemIndex = [NSNumber numberWithInt:iIndex];
    category.content = [NSData dataWithData:UIImagePNGRepresentation(iContent)];
    category.pattern = pattern;
    if (autoSave) {
        [dataCenterInstanced saveContext];
    }
    return category;
}

+ (PhotoItem*)insertPhotoItemWithId:(NSString*)iId
                          itemIndex:(int)iIndex
                            content:(UIImage*)iContent
                            pattern:(PatternModel*)pattern
{
    return [self insertPhotoItemWithId:iId
                             itemIndex:iIndex
                               content:iContent
                               pattern:pattern
                              autoSave:NO];
}

+ (NSString*)entityName
{
    return @"PhotoItem";
}

@end
