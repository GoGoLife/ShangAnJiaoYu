//
//  FiveRoundsTrainingViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "FiveRoundsTrainingViewController.h"
#import "LabelTableViewCell.h"
#import "FiveRoundsFirstViewController.h"
#import "FiveRoundsSecondViewController.h"
#import "FiveRoundsThirdViewController.h"
#import "FiveRoundsFourthViewController.h"
#import "FiveRoundsFifthViewController.h"

@interface FiveRoundsTrainingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FiveRoundsTrainingViewController

/**
 获取五轮数据
 */
- (void)getData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_five_training_list" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"五轮训练";
    [self setBack];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[LabelTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(5, 20, 5, 20));
    }];
    ViewRadius(cell.label, 8.0);
    cell.label.textAlignment = NSTextAlignmentCenter;
    cell.label.backgroundColor = SetColor(246, 246, 246, 1);
    cell.label.text = dic[@"title_"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = (SCREENBOUNDS.height - 64) / 5;
    return height;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSInteger order = [dic[@"order_"] integerValue];
    switch (order) {
        case 1:
        {
            FiveRoundsFirstViewController *fiveRounds_first = [[FiveRoundsFirstViewController alloc] init];
            fiveRounds_first.fiveTrainingId = dic[@"id_"];
            [self.navigationController pushViewController:fiveRounds_first animated:YES];
        }
            break;
        case 2:
        {
            FiveRoundsSecondViewController *fiveRounds_second = [[FiveRoundsSecondViewController alloc] init];
            fiveRounds_second.fiveTrainingId = dic[@"id_"];
            [self.navigationController pushViewController:fiveRounds_second animated:YES];
        }
            break;
        case 3:
        {
            FiveRoundsThirdViewController *fiveRounds_third = [[FiveRoundsThirdViewController alloc] init];
            fiveRounds_third.fiveTrainingID = dic[@"id_"];
            [self.navigationController pushViewController:fiveRounds_third animated:YES];
        }
            break;
        case 4:
        {
            FiveRoundsFourthViewController *fiveRounds_fourth = [[FiveRoundsFourthViewController alloc] init];
            fiveRounds_fourth.fiveTrainingID = dic[@"id_"];
            [self.navigationController pushViewController:fiveRounds_fourth animated:YES];
        }
            break;
        case 5:
        {
            FiveRoundsFifthViewController *fiveRounds_fifth = [[FiveRoundsFifthViewController alloc] init];
            fiveRounds_fifth.fiveTrainingID = dic[@"id_"];
            [self.navigationController pushViewController:fiveRounds_fifth animated:YES];
        }
            break;
        default:
            NSLog(@"不是任何一轮");
            break;
    }
    
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
