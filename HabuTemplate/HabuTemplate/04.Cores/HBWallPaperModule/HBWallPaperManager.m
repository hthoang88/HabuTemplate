//
//  HBWallPaperManager.m
//  HBLock
//
//  Created by Hoang Ho on 1/8/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "HBWallPaperManager.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "HBWPCategoryModel.h"
#import "HBWPItem.h"

static sqlite3* database;

@implementation HBWallPaperManager

+ (HBWallPaperManager*)shared
{
    static HBWallPaperManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[HBWallPaperManager alloc] init];
    });
    
    return sharedClient;
}

- (instancetype)init
{
    if (self = [super init]) {
        //Using NSFileManager we can perform many file system operations.
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *dbPath = [self getDBPath];
        BOOL isExisted = [fileManager fileExistsAtPath:dbPath];
        if(!isExisted) {
#ifdef HBWP_READ_ONLY
            [self copyDBToDocument];
#else
            // if database is not exist - need to create new database file and create tables for save data of stock
            if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK){
                sqlite3_limit(database,SQLITE_LIMIT_COMPOUND_SELECT,1000);
                sqlite3_close(database);
            }
            FMDatabaseQueue *queue = [self createDatabaseQueue];
            [self createAllTable:queue];
#endif
        }
    }
    return self;
}

#pragma mark - Query

- (NSMutableArray*)getAllCategories
{
    NSMutableArray *customers = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDBPath]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM HBWP_CATEGORY"];
    
    while([results next])
    {
        HBWPCategoryModel *ct = [HBWPCategoryModel new];
        ct.name = [results stringForColumn:@"name"];
        ct.categoryID = [results stringForColumn:@"categoryID"];
        ct.numberItems = @([results stringForColumn:@"categoryID"].intValue);
        ct.thumnailUrl = [results stringForColumn:@"thumnailUrl"];
        
        [customers addObject:ct];   
    }
    
    [db close];
    
    return customers;
}

- (NSMutableArray*)getItemsOfCatgory:(HBWPCategoryModel*)ct fromOffset:(int)offset limit:(int)limit
{
    NSMutableArray *customers = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDBPath]];
    
    [db open];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM HBWP_ITEM WHERE categoryID = '%@' limit %d, %d",ct.categoryID, offset, limit];
    
    FMResultSet *results = [db executeQuery:query];
    
    while([results next])
    {
        HBWPItem *it = [HBWPItem new];
        it.name = [results stringForColumn:@"name"];
        it.thumnailUrl = [results stringForColumn:@"name"];
        it.originUrl = [results stringForColumn:@"name"];
        it.categoryID = ct.categoryID;
        it.position = @([results stringForColumn:@"position"].intValue);
        it.itemID = [results stringForColumn:@"itemID"];
        
        [customers addObject:it];
    }
    [ct.items addObjectsFromArray:customers];
    
    return customers;
}

#pragma mark - Access Data using async, queue and completed block technology

- (void)copyDBToDocument
{
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HBWallPaper.sqlite"];
    
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                            toPath:[self getDBPath]
                                             error:nil];
}
- (FMDatabaseQueue*)createDatabaseQueue
{
    return [FMDatabaseQueue databaseQueueWithPath:[self getDBPath]];
}


#pragma mark - Create tables for database

- (NSString *) getDBPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [[NSString alloc] initWithString: [documentsDir stringByAppendingPathComponent: @"HBWallPaper.sqlite"]];
}

- (void)createAllTable:(FMDatabaseQueue*)databaseQueue
{
    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
        //create stock transaction Table
        NSString *createTransaction = [NSString stringWithFormat:
                                       @"CREATE TABLE \
                                       \"HBWP_CATEGORY\" \
                                       (\"categoryID\" TEXT, \
                                       name TEXT, \
                                       thumnailUrl TEXT,\
                                       numberItems TEXT, \
                                       PRIMARY KEY (categoryID));"];
        const char *create_transaction = [createTransaction UTF8String];
        BOOL result = [db executeUpdate:[NSString stringWithUTF8String:create_transaction]];
        if (result){
            NSLog(@"Create HBWP_CATEGORY successfully");
        } else{
            NSLog(@"Create HBWP_CATEGORY fail");
        }
        //create Watchlist Table
        NSString *createWatchlist = [NSString stringWithFormat:
                                     @"CREATE TABLE \
                                     \"HBWP_ITEM\" \
                                     (name TEXT, \
                                     thumnailUrl TEXT, \
                                     originUrl TEXT, \
                                     categoryID TEXT, \
                                     itemID TEXT, \
                                     position TEXT, \
                                     PRIMARY KEY (itemID));"];
        
        const char *create_watchlist = [createWatchlist UTF8String];
        result = [db executeUpdate:[NSString stringWithUTF8String:create_watchlist]];
        if (result){
            NSLog(@"Create WATCHLIST successfully");
        } else{
            NSLog(@"Create WATCHLIST fail");
        }
    }];
    
}

@end

@implementation HBWallPaperManager (insert)
- (void)insertCategory:(HBWPCategoryModel*)ct
{
    // insert category into database
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDBPath]];
    
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO HBWP_CATEGORY (categoryID, name, numberItems, thumnailUrl) VALUES (?,?,?,?);",
                     ct.categoryID,ct.name, STRINGIFY_INT(ct.numberItems.intValue), ct.thumnailUrl, nil];
    if (!success) {
        
    }
    
    [db close];
}

- (void)insertItem:(HBWPItem*)it
{
    // insert category into database
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDBPath]];
    
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO HBWP_ITEM (name, thumnailUrl, originUrl, categoryID, position, itemID) VALUES (?,?,?,?,?,?);", it.name, it.thumnailUrl, it.originUrl, it.categoryID, STRINGIFY_INT(it.position.integerValue), it.itemID, nil];
    if (!success) {
        
    }
    
    [db close];
}
@end
