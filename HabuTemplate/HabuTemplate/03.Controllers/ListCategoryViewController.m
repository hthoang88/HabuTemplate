//
//  ListCategoryViewController.m
//  HabuTemplate
//
//  Created by Hoang Ho on 1/7/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "ListCategoryViewController.h"
#import "CategoryModel.h"
#import "WallPaperModel.h"
#import "SDWebImageManager.h"
#import "AFImageRequestOperation.h"

@interface ListCategoryViewController ()
{
    NSMutableArray *data;
}
@end

@implementation ListCategoryViewController

ListCategoryViewController *instance;
+ (UIView*)getInstancedView
{
    return instance.view;
}

- (instancetype)init
{
    self = [super init];
    instance = self;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SharedDownloader getCategoryCompletion:^(NSMutableArray *dt) {
        data = dt;
        [self.tbCategories reloadData];
        [self fetchDataForCategoryIndex:0 completion:^{
            [self downLoadAllImageForCategoryIndex:0 imageIndex:0 completion:^{
                
            }];
        }];
    }];
}

- (void)downLoadAllImageForCategoryIndex:(int)categoryIndex
                              imageIndex:(int)imageIndex
                              completion:(void(^)(void))completion
{
    if (categoryIndex >= data.count) {
        if (completion) {
            completion();
        }
        return;
    }else{
        CategoryModel *obj = data[categoryIndex];
        if (imageIndex >= obj.items.count) {
            int nextCategoryIndex = categoryIndex + 1;
            int  startImageIndex = 0;
            [self downLoadAllImageForCategoryIndex:nextCategoryIndex imageIndex:startImageIndex completion:completion];
            return;
        }
    }
    static int numberDownload = 5;
    CategoryModel *obj = data[categoryIndex];
    // get list image hasn't been downloaded yet
    NSMutableArray *listImageUrls = [NSMutableArray array];
    for (int i = imageIndex; i < obj.items.count && i < imageIndex + numberDownload; i++) {
        WallPaperModel *wallPaper = obj.items[i];
        [listImageUrls addObject:wallPaper.thumnailUrl];
        [listImageUrls addObject:wallPaper.originUrl];
    }
    __block NSInteger totalImage = [listImageUrls count];
    __block NSInteger finishedImageNum = 0;
    
    for (NSString *url in listImageUrls )
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        AFImageRequestOperation *operation =  [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            // Get dir
            NSString *documentsDirectory = nil;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDirectory = [paths objectAtIndex:0];
            NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",obj.name]];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                          withIntermediateDirectories:NO
                                                           attributes:nil
                                                                error:nil]; //Create folde
            
            WallPaperModel *wallPaper = nil;
            BOOL isThumnail = NO;
            for (WallPaperModel *item in obj.items) {
                if ([item.thumnailUrl rangeOfString:request.URL.absoluteString].location != NSNotFound) {
                    wallPaper = item;
                    isThumnail = YES;
                    break;
                }else if([item.originUrl rangeOfString:request.URL.absoluteString].location != NSNotFound){
                    wallPaper = item;
                    isThumnail = NO;
                    break;
                }
            }
            if (wallPaper) {
                NSString *filePath = nil;
                if (isThumnail) {
                    filePath = [NSString stringWithFormat:@"%@/%@_%@_thum.jpg",folderPath,obj.name, wallPaper.name];
                }else
                    filePath = [NSString stringWithFormat:@"%@/%@_%@.jpg",folderPath,obj.name, wallPaper.name];
                // Save Image
                NSLog(@"====>Write image to %@", filePath);
                NSData *imageData = UIImageJPEGRepresentation(image, 1);
                [imageData writeToFile:filePath atomically:YES];
            }
            finishedImageNum++;
            // check if downloading is finished
            if (finishedImageNum == totalImage) {
                int  startImageIndex = imageIndex + numberDownload;
                [self downLoadAllImageForCategoryIndex:categoryIndex imageIndex:startImageIndex completion:completion];
            }

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //skip error
            finishedImageNum++;
            // check if downloading is finished
            if (finishedImageNum == totalImage) {
                int  startImageIndex = imageIndex + numberDownload;
                [self downLoadAllImageForCategoryIndex:categoryIndex imageIndex:startImageIndex completion:completion];
            }
        }];

        [operation start];
    }
}

- (void)fetchDataForCategoryIndex:(int)categoryIndex completion:(void(^)(void))completion
{
    if (categoryIndex >= data.count) {
        if (completion) {
            completion();
        }
        return;
    }
    CategoryModel *obj = data[categoryIndex];
    [SharedDownloader getItemsForCategory:obj completion:^(NSMutableArray *items) {
        int nextIndex = categoryIndex + 1;
        [self fetchDataForCategoryIndex:nextIndex completion:completion];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    CategoryModel *obj = data[indexPath.row];
    cell.textLabel.text = obj.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *obj = data[indexPath.row];
    [SharedDownloader getItemsForCategory:obj completion:^(NSMutableArray *items) {
        
    }];
}

@end
