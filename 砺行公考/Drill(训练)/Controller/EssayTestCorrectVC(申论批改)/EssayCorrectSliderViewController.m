//
//  EssayCorrectSliderViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "EssayCorrectSliderViewController.h"
#import "EssayTestCorrectViewController.h"
#import "CorrectHistoryViewController.h"
#import "MyCorrectHistoryController.h"

@interface EssayCorrectSliderViewController ()

@end

@implementation EssayCorrectSliderViewController

- (void)initAction {
    //申论批改
    EssayTestCorrectViewController *correrct = [[EssayTestCorrectViewController alloc] init];
    //佳作批改
    CorrectHistoryViewController *history = [[CorrectHistoryViewController alloc] init];
    //我的批改
    MyCorrectHistoryController *myCorrect = [[MyCorrectHistoryController alloc] init];
    
    self.controllers = @[correrct, history, myCorrect];
    self.titles = @[@"新申论批改", @"佳作批改录", @"我的批改记录"];
    
    self.titleColor = [UIColor blackColor];
    self.titleSelectColor = ButtonColor;
    self.bottomLineColor = ButtonColor;
    self.pageNumberOfItem = 3;
    self.currentItem = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
