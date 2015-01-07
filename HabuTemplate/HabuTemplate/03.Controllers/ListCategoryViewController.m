//
//  ListCategoryViewController.m
//  HabuTemplate
//
//  Created by Hoang Ho on 1/7/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "ListCategoryViewController.h"
#import "CategoryModel.h"

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
