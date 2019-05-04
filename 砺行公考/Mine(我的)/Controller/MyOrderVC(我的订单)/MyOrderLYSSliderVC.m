//
//  MyOrderLYSSliderVC.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "MyOrderLYSSliderVC.h"
#import "AllOrderViewController.h"
#import "WaitPayOrderViewController.h"
#import "WaitPushOrderViewController.h"
#import "WaitPullOrderViewController.h"
#import "WaitEvaluateViewController.h"

@interface MyOrderLYSSliderVC ()

@end

@implementation MyOrderLYSSliderVC

- (void)initAction {
    AllOrderViewController *all = [[AllOrderViewController alloc] init];
    WaitPayOrderViewController *pay = [[WaitPayOrderViewController alloc] init];
    WaitPushOrderViewController *push = [[WaitPushOrderViewController alloc] init];
    WaitPullOrderViewController *pull = [[WaitPullOrderViewController alloc] init];
    WaitEvaluateViewController *evaluate = [[WaitEvaluateViewController alloc] init];
    
    self.controllers = @[all, pay, push, pull, evaluate];
    self.titles = @[@"全部", @"待付款", @"待发货", @"待收货", @"待评价"];
    self.pageNumberOfItem = 5;
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
