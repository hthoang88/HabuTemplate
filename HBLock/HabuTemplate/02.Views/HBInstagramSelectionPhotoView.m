//
//  HBInstagramSelectionPhotoView.m
//  HBLock
//
//  Created by Hoang Ho on 9/14/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "HBInstagramSelectionPhotoView.h"
#import "HSInstagramUserMedia.h"
#import "HSInstagram.h"
#import "UIButton+WebCache.h"
#import "UIAlertView+CompletedBlock.h"

#define kthumbnailWidth                                                         80
#define kthumbnailHeight                                                        80
#define kImagesPerRow                                                           3
#define INT_RADIUS_SMALL_AVATAR                                                     6

@implementation HBInstagramSelectionPhotoView
@synthesize instagramWebView;

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HBInstagramSelectionPhotoView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = self.bounds;
        [self importMediaItems];
    }
    return self;
}

- (void)importMediaItems {
    CGRect screenRect = self.frame;
    
    if (!instagramScrollView) {
        instagramScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
        instagramScrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:instagramScrollView];
    }
    instagramScrollView.hidden = NO;
    
    if (instagramMmages == nil) {
        instagramMmages = [[NSArray alloc] init];
    }
    if (instagramThumbnails == nil) {
        instagramThumbnails = [[NSMutableArray alloc] init];
    }
    [instagramThumbnails removeAllObjects];
    
    if (!instagramWebView) {
        instagramWebView = [[UIWebView alloc] init];
        instagramWebView.backgroundColor = [UIColor redColor];
        [instagramWebView setFrame:CGRectMake(0, 0, WIDTH_SCREEN, screenRect.size.height)];
        instagramWebView.delegate = self;
        [self addSubview:instagramWebView];
        
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(0, -4, 50, 50);
        [btnBack setImage:[UIImage imageNamed:@"header-icon-back.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(btnInstagramBackAct) forControlEvents:UIControlEventTouchUpInside];
        [instagramWebView addSubview:btnBack];
    }
    instagramWebView.hidden = NO;
    
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenRect.size.width/2-20, screenRect.size.height/2-20, 40, 40)];
    }
    [self addSubview:spinner];
    spinner.hidden = NO;
    [spinner startAnimating];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kAuthenticationEndpoint, kClientId, kRedirectUrl]]];
    
    [instagramWebView loadRequest:request];
    //    isPickingPhotoFromInstagram = YES;
    
}

- (void)btnInstagramBackAct {
    [instagramScrollView removeFromSuperview];
    [instagramWebView removeFromSuperview];
    
    instagramScrollView = nil;
    instagramWebView = nil;
}


#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *urlString =request.URL.absoluteString;
    
    if([urlString rangeOfString:kRedirectUrl].location != NSNotFound && [urlString rangeOfString:@"https://instagram.com/oauth/authorize/"].location == NSNotFound){
        
        NSRange acToken = [urlString rangeOfString: @"#access_token="];
        if (acToken.location != NSNotFound) {
            accessToken = [urlString substringFromIndex: NSMaxRange(acToken)];
            if (accessToken.length > 0) {
                [spinner stopAnimating];
                instagramWebView.hidden = YES;
                [self requestInstagramImages];
            }
        }
        
        return NO;
    }
    return YES;
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"End webview");
    spinner.hidden = YES;
    [spinner stopAnimating];
}

- (void)requestInstagramImages
{
    [HSInstagramUserMedia getUserMediaWithId:@"self" withAccessToken:accessToken block:^(NSArray *records) {
        if (records.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Don't have any photo in your profile" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                [self removeFromSuperview];
            } cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        instagramMmages = records;
        int item = 0, col = 0;
        int x = 20, y = 15;
        for (int i = 0; i < records.count; i++) {
            
            CGRect frame = CGRectMake(x,y, kthumbnailWidth, kthumbnailHeight);
            //VKLog(@"x:%f y:%f",frame.origin.x, frame.origin.y);
            
            UIButton* button = [[UIButton alloc] initWithFrame:frame];
            button.tag = item;
            
            button.layer.cornerRadius = INT_RADIUS_SMALL_AVATAR;
            button.layer.masksToBounds = YES;
            
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            ++col;++item;
            x+= 100;
            if (col >= kImagesPerRow) {
                col = 0;
                y+= 105;
                x = 20;
            }
            [instagramScrollView addSubview:button];
            [instagramThumbnails addObject:button];
        }
        
        // TaiT 2012/10/22
        instagramScrollView.contentSize = CGSizeMake(instagramScrollView.frame.size.width, ((int)(records.count/3 + 1))*105);
        
        [self loadInstagramImages];
    }];
}

- (void)loadInstagramImages
{
    int item = 0;
    
    for (HSInstagramUserMedia* media in instagramMmages) {
        
        UIButton* button = [instagramThumbnails objectAtIndex:item];
        [button setImageWithURL:[NSURL URLWithString:media.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"Stars.jpg"]];
        
        item++;
    }
    
}

- (void)buttonAction:(id)sender
{
    UIButton* button = sender;
    HSInstagramUserMedia* media = [instagramMmages objectAtIndex:button.tag];
    NSString* standard_reso_url = media.standardUrl;//Qasim 28/11/12
    
    // Qasim 02/01/2013
    NSData *origionalImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:standard_reso_url]];
    UIImage *imageFromData = [UIImage imageWithData:origionalImgData];
    
    [instagramScrollView setHidden:YES];
    [instagramWebView removeFromSuperview];
    
    UIImage * ig= imageFromData;
    
//    // get crop image
//    self.originalImage = _nonCropOriginalImage;
//    if ([self.delegate respondsToSelector:@selector(effectCameraView:didSelectPhotoFromLibrary:)]) {
//        [self.delegate effectCameraView:self didSelectPhotoFromLibrary:self.originalImage];
//    }
}

@end
