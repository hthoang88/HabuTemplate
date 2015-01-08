//
//  HDWallpapersDownloader.m
//  HabuTemplate
//
//  Created by Hoang Ho on 1/7/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "HDWallpapersDownloader.h"
#import "CategoryModel.h"
#import "WallPaperModel.h"
#import "TFHpple.h"
#import "ListCategoryViewController.h"

@implementation HDWallpapersDownloader

+ (HDWallpapersDownloader*)sharedManager
{
    static HDWallpapersDownloader *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[HDWallpapersDownloader alloc] init];
    });
    
    return sharedClient;
}

- (void)getCategoryCompletion:(void(^)(NSMutableArray *data))completion
{
    listCategory = [NSMutableArray array];
    [self getHtmlStringFromPath:@"http://www.hdwallpapers.in/" completion:^(id responseObject) {
        NSString *tutorialsXpathQueryString = @"//div[@class='right-panel']/div[@class='left_panel_top']/div[@class='spacer']/ul[@class='side-panel categories']";
        TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:responseObject];
        NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        if (tutorialsNodes.count > 0) {
            TFHppleElement *ulTag  = tutorialsNodes[0];
            for (TFHppleElement *liTag in [ulTag children]) {
                for (TFHppleElement *aTag in [liTag children]) {
                    NSString *content = [aTag content];
                    NSString *ref = [aTag objectForKey:@"href"];
                    CategoryModel *category = [CategoryModel new];
                    category.name = content;
                    category.url = [NSString stringWithFormat:@"http://www.hdwallpapers.in/%@",ref];
                    [listCategory addObject:category];
                }// 5
            }
            if (completion) {
                completion(listCategory);
            }
        }
    }];
}

- (void)getHtmlStringFromPath:(NSString*)path completion:(void(^)(id responseObject))completion
{
    [[APIManager sharedManager] operationWithTypePath:path inView:nil completeBlock:^(id responseObject) {
        if (completion) {
            completion(responseObject);
        }
    } failureBlock:nil];
}

- (void)getItemsForCategory:(CategoryModel*)ct
                 completion:(void(^)(NSMutableArray *items))completion
{
    [Utils showHUDForView:[ListCategoryViewController getInstancedView]];
    [self getHtmlStringFromPath:ct.url completion:^(id responseObject) {
        [Utils hideHUDForView:[ListCategoryViewController getInstancedView]];
        NSString *tutorialsXpathQueryString = @"//div[@class='pagination']/a";
        //        NSString *tutorialsXpathQueryString = @"//div[@class='right-panel']/div[@class='left_panel_top']/div[@class='spacer']/ul[@class='side-panel categories']";
        TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:responseObject];
        NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        if (tutorialsNodes.count > 1) {
            TFHppleElement *ulTag = tutorialsNodes[tutorialsNodes.count - 2];//get number page
            int numberPage = [ulTag content].intValue;
            NSLog(@"FOUND %d pages for %@", numberPage, ct.name);
            if (numberPage == 92) {
                
            }
            [self getItemsForCategory:ct pageIndex:1 totalPage:numberPage completion:^{
                if (completion) {
                    completion(ct.items);
                }
            }];
        }else{//only one page
            tutorialsXpathQueryString = @"//div[@class='pagination']/span[@class='selected']";
            tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
            if (tutorialsNodes.count > 0) {
                TFHppleElement *ulTag = tutorialsNodes[tutorialsNodes.count - 1];//get number page
                int numberPage = [ulTag content].intValue;
                NSLog(@"FOUND %d pages for %@", numberPage, ct.name);
                [self getItemsForCategory:ct pageIndex:1 totalPage:numberPage completion:^{
                    if (completion) {
                        completion(ct.items);
                    }
                }];
            }else{//skip category
                if (completion) {
                    completion(ct.items);
                }
            }
        }
    }];
}

- (void)getItemsForCategory:(CategoryModel*)ct
                  pageIndex:(int)index
                  totalPage:(int)totalPage
                 completion:(void(^)(void))completion
{
    if (index > totalPage) {
        if (completion) {
            completion();
        }
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/page/%d",ct.url, index];
    [Utils showHUDForView:[ListCategoryViewController getInstancedView] message:[NSString stringWithFormat:@"page %d-%@",index,ct.name]];
    [self getHtmlStringFromPath:url completion:^(id responseObject) {
        NSString *tutorialsXpathQueryString = @"//ul[@class='wallpapers']/li[@class='wall']";
        //        NSString *tutorialsXpathQueryString = @"//div[@class='right-panel']/div[@class='left_panel_top']/div[@class='spacer']/ul[@class='side-panel categories']";
        TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:responseObject];
        NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        if (tutorialsNodes.count > 1) {
            for (TFHppleElement *liTag in tutorialsNodes) {
                NSString *xPath = @"//div[@class='thumbbg']/div[@class='thumb']/a";
                NSArray *aTags = [liTag searchWithXPathQuery:xPath];
                if (aTags.count > 0) {
                    //get name + url + thumnailUrl
                    TFHppleElement *aTag = aTags[0];
                    NSString *name = [aTag content];
                    NSString *ref = [aTag objectForKey:@"href"];
                    NSString *thum =  [[[aTag childrenWithTagName:@"img"] firstObject] objectForKey:@"src"];
                    
                    WallPaperModel *obj = [WallPaperModel new];
                    obj.name = name;
                    obj.url = [NSString stringWithFormat:@"http://www.hdwallpapers.in/%@",ref];
                    obj.thumnailUrl = [NSString stringWithFormat:@"http://www.hdwallpapers.in/%@",thum];
                    [ct.items addObject:obj];
                    [self getOriginImageUrlForItem:obj completion:^{
                        BOOL isFinish = YES;
                        for (WallPaperModel *item in ct.items) {
                            if (!item.originUrl) {
                                isFinish = NO;
                                break;
                            }
                        }
                        if (isFinish) {
                            [Utils hideHUDForView:[ListCategoryViewController getInstancedView]];
                            int nextIndex = index + 1;
                            [self getItemsForCategory:ct pageIndex:nextIndex totalPage:totalPage completion:completion];
                        }
                    }];
                }else{
                    NSLog(@"NULL TAG");
                }
            }
        }else{
            [Utils hideHUDForView:[ListCategoryViewController getInstancedView]];
            int nextIndex = index + 1;
            [self getItemsForCategory:ct pageIndex:nextIndex totalPage:totalPage completion:completion];
        }
    }];
}

- (void)getOriginImageUrlForItem:(WallPaperModel*)obj
                      completion:(void(^)(void))completion
{
    [self getHtmlStringFromPath:obj.url completion:^(id responseObject) {
         NSString *tutorialsXpathQueryString = @"//div[@class='thumbbg1']/a";
        TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:responseObject];
        NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        if (tutorialsNodes.count > 0) {
            TFHppleElement *aTag = [tutorialsNodes firstObject];
            NSString *ref = [aTag objectForKey:@"href"];
            obj.originUrl = [NSString stringWithFormat:@"http://www.hdwallpapers.in/%@",ref];
            if (completion) {
                completion();
            }
        }
    }];
}

@end
