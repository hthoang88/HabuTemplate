//
//  MainViewController.h
//  HBLock
//
//  Created by Hoang Ho on 9/11/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface MainViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
@property (weak, nonatomic) IBOutlet UIButton *btn0;

- (IBAction)btnNumberTouchUpInside:(id)sender;
@end
