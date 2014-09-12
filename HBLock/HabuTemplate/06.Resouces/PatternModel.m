//
//  ParternModel.m
//  HBLock
//
//  Created by Hoang Ho on 9/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "PatternModel.h"
#import "PhotoItem.h"


@implementation PatternModel

@dynamic createdDate;
@dynamic patternId;
@dynamic patternName;
@dynamic phoneType;
@dynamic background;
@dynamic items;
@dynamic screenShot;

+ (NSString *)entityName
{
    return @"PatternModel";
}

+ (void)insertParternWithPatternId:(NSString*)pId
                       patternName:(NSString*)pName
                         phoneType:(int)phoneType
                        background:(UIImage*)bgImage
                         screeShot:(UIImage*)pScreenShot
                        photoItems:(NSSet*)pItems
{
    NSManagedObjectContext *_managedObjectContext = sharedManageObjectContent;
    
    //    VKLog(@"insertKardDataFromServer. count = %@", dataList);
    PatternModel *category = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:_managedObjectContext];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    category.patternId = pId;
    category.patternName = pName;
    category.phoneType = [NSNumber numberWithInt:phoneType];
    category.background = [NSData dataWithData:UIImagePNGRepresentation(bgImage)];
    category.screenShot = [NSData dataWithData:UIImagePNGRepresentation(pScreenShot)];
    [category addItems:pItems];
    [dataCenterInstanced saveContext];
}

+ (NSArray*)getAllParterns
{
    return [self getItemsWithPredicate:nil sort:nil];
}
@end
