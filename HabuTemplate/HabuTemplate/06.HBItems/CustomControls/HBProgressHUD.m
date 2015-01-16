//
//  CustomMBProgressHUD.m
//  Giga
//
//  Created by CX MAC on 12/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "HBProgressHUD.h"

@implementation HBProgressHUD

+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    HBProgressHUD *instance = (HBProgressHUD*)[view viewWithTag:12345];
    if (instance && [instance isKindOfClass:[MBProgressHUD class]]) {
        return instance;
    }
	HBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.tag = 12345;
	[view addSubview:hud];
	[hud show:animated];
	return hud;
}

@end
