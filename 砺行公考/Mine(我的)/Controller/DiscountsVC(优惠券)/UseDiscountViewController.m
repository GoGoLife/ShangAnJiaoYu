//
//  UseDiscountViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/21.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "UseDiscountViewController.h"
#import "DiscountTableViewCell.h"

@interface UseDiscountViewController ()<UITableViewDelegate, UITableViewDataSource, LYSSlideMenuControllerDelegate>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation UseDiscountViewController

- (void)getUseDiscountList {
    
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController didViewDidLoad:(NSInteger)index {
    [self.view addSubview:self.tableview];
    self.tableview.backgroundColor = WhiteColor;
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"use"];
    cell.isUse = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

#pragma mark --- 懒加载
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[DiscountTableViewCell class] forCellReuseIdentifier:@"use"];
    }
    return _tableview;
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
