//
//  HBInstagramSelectionPhotoView.h
//  HBLock
//
//  Created by Hoang Ho on 9/14/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBInstagramSelectionPhotoView : UIView<UIWebViewDelegate>
{
    NSString                            *accessToken;
    NSArray                                         *instagramMmages;
    NSMutableArray                                  *instagramThumbnails;
    UIScrollView                           *instagramScrollView;
    UIActivityIndicatorView                         *spinner;
}
@property (strong, nonatomic) IBOutlet UIWebView *instagramWebView;

@end
