//
//  DataCenter.h
//  HBStory
//
//  Created by Hoang Ho on 7/21/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseModel.h"

@interface DataCenter : BaseModel
@property (strong, nonatomic) UIImage *homeBackgroundImage;
@property (strong, nonatomic) UIImage *leftBackgroundImage;
@property (strong, nonatomic) UIImage *rightBackgroundImage;

+ (DataCenter*)shared;

//Core data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
@end
