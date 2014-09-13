//
//  DownloadsViewController.m
//  HBStory
//
//  Created by Hoang Ho on 7/22/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "PatternLibaryViewController.h"
#import "GMGridViewNew.h"
#import "UIImageView+AFNetworking.h"
#import "PatternModel.h"
#import "UIAlertView+CompletedBlock.h"
#import "MainViewController.h"

@interface PatternLibaryViewController ()<GMGridViewActionDelegate, GMGridViewDataSource, GMGridViewSortingDelegate>
{
    
}
@end

#define KOLLECTION_MARGIN_KARDS_CELL                     30
#define KOLLECTION_MARGIN_KARDS_CELL_LEFT                20
#define KOLLECTION_MARGIN_KARDS_CELL_TOP                 15
#define KOLLECTION_MARGIN_KARDS_CELL_RIGHT               15
#define KOLLECTION_MARGIN_KARDS_CELL_BOTTOM              30


@implementation PatternLibaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.readOnly = NO;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.readOnly = NO;
    [self loadInterface];
    
    [self loadOfflineData];
}
- (IBAction)btnCloseTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadInterface
{
//    [self loadNavigationBarHasLeftMenu:YES rightMenu:nil];
    // tag grid view
    self.gridView = [[GMGridViewNew alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40)];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.gridView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.gridView];
    
    self.gridView.style = GMGridViewStyleSwap;
    self.gridView.itemSpacing = KOLLECTION_MARGIN_KARDS_CELL;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(KOLLECTION_MARGIN_KARDS_CELL_TOP, KOLLECTION_MARGIN_KARDS_CELL_LEFT, KOLLECTION_MARGIN_KARDS_CELL_BOTTOM, KOLLECTION_MARGIN_KARDS_CELL_RIGHT);
    self.gridView.centerGrid = NO;
    self.gridView.minimumPressDuration = 0.6;
    self.gridView.actionDelegate = self;
    self.gridView.sortingDelegate = self;
    self.gridView.dataSource = self;
    self.gridView.itemSpacing = 60;
    
}
- (void)loadOfflineData
{
    //Load offline data
    self.desks =  [NSMutableArray arrayWithArray:[PatternModel getAllParterns]];
    [self.gridView reloadData];
}

#pragma mark - GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self.desks count];
}

#define KOLLECTION_WIDTH_KARDS_CELL_AVATAR  125
#define KOLLECTION_HEIGHT_KARDS_CELL_AVATAR 140

- (CGSize)gridViewSize
{
    return [self GMGridView:self.gridView sizeForItemsInInterfaceOrientation:0];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (self.desks.count > 0) {
        PatternModel *temp = self.desks[0];
        UIImage *image = [UIImage imageWithData:temp.screenShot];
        return CGSizeMake(image.size.width / 3, image.size.height/3);
    }
    return CGSizeMake(KOLLECTION_WIDTH_KARDS_CELL_AVATAR, KOLLECTION_HEIGHT_KARDS_CELL_AVATAR);
}

#define HEIGHT_KARDS_CELL_NAME      20
- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonOffset = CGPointMake(-5, -5);
        cell.deleteButtonTouchSize = CGSizeMake(20 ,20);
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
        
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.desks == nil || index >= self.desks.count || index < 0) {
        return nil;
    }
    
    PatternModel *category = self.desks[index];
    
    
    
    
    if (category.screenShot) {
        UIImageView *categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self gridViewSize].width, [self gridViewSize].height)];
        categoryImageView.layer.masksToBounds = YES;
        //        categoryImageView.layer.cornerRadius = 7.5;
        categoryImageView.contentMode = UIViewContentModeScaleToFill;
        
        [cell.contentView addSubview:categoryImageView];
        
        
        [categoryImageView setImage:[UIImage imageWithData:category.screenShot]];
    }
    
    UIView  *aView = [[UIView alloc] initWithFrame:CGRectMake(0, [self gridViewSize].height - 40, [self gridViewSize].width, 40)];
    aView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:aView];
    [cell.contentView bringSubviewToFront:aView];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:aView.bounds];
    [bgView setImage:[UIImage imageNamed:@"bg_VKSocial"]];
    [aView addSubview:bgView];
    
    UILabel *_lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self gridViewSize].width, HEIGHT_KARDS_CELL_NAME)];
    _lblName.backgroundColor = [UIColor clearColor];
    [_lblName setTextColor:[UIColor whiteColor]];
    [_lblName setTextAlignment:NSTextAlignmentCenter];
    [_lblName setFont:[UIFont boldSystemFontOfSize:14]];
    [_lblName setMinimumScaleFactor:0.2f];
    _lblName.adjustsFontSizeToFitWidth = YES;
    _lblName.text = category.patternName;
    [aView addSubview:_lblName];

    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return !self.readOnly;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    PatternModel *pattern = self.desks[position];
    UINavigationController *nav = (UINavigationController*)self.presentingViewController;
    if ([nav isMemberOfClass:[UINavigationController class]]) {
        MainViewController *mainVC = [nav.viewControllers lastObject];
        mainVC.pattern = pattern;
    }
    [self btnCloseTouchUpInside:nil];
    //    CategoryModel *item = self.desks[position];
    //    CategoryDetailViewController *detailVC = [[CategoryDetailViewController alloc] init];
    //    detailVC.category = item;
    //    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this tag ?" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        PatternModel *pattern = self.desks[index];
        [sharedManageObjectContent deleteObject:pattern];
        self.desks = [NSMutableArray arrayWithArray:[PatternModel getAllParterns]];
        [gridView reloadData];
    } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.shadowOpacity = 0.7;
                         UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.contentView.bounds cornerRadius:cell.contentView.layer.cornerRadius];
                         cell.contentView.layer.shadowPath = path.CGPath;
                         cell.contentView.layer.backgroundColor = [UIColor blueColor].CGColor;
                         cell.contentView.layer.shouldRasterize = YES;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.shadowOpacity = 0;
                         UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.contentView.bounds cornerRadius:cell.contentView.layer.cornerRadius];
                         cell.contentView.layer.shadowPath = path.CGPath;
                         cell.contentView.layer.backgroundColor = [UIColor orangeColor].CGColor;
                         cell.contentView.layer.shouldRasterize = YES;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return !self.readOnly;
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowMovingCell:(GMGridViewCell *)view toIndex:(NSInteger)index
{
    return !self.readOnly;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    if (oldIndex == 0 || newIndex == 0) {
        return;
    }
    
    //    NSObject *object = [_tagList objectAtIndex:oldIndex];
    //    [_tagList removeObject:object];
    //    [_tagList insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    //    if (index1 == 0 || index2 == 0) {
    //        return;
    //    }
    //
    //    [_tagList exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}
@end
