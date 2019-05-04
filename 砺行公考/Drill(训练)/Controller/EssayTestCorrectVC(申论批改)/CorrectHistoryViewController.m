//
//  CorrectHistoryViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/21.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CorrectHistoryViewController.h"
#import "CorrectHistoryTableViewCell.h"
#import "CorrectDetailsViewController.h"

@interface CorrectHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CorrectHistoryViewController

- (void)getGoodCorrectHistoryData {
    NSDictionary *parma = @{@"status_":@"3",
                            @"page_number":@"1",
                            @"page_size":@"50"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_app_correcting_list" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"correct history == %@", responseObject);
            weakSelf.dataArray = responseObject[@"data"][@"rows"];
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_header endRefreshing];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[CorrectHistoryTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 64, 0));
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getGoodCorrectHistoryData];
    }];
    [self.tableview.mj_header beginRefreshing];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    CorrectHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.typeLabel.text = dic[@"type"];
    cell.test_title.text = dic[@"exam_title_"];
    cell.title_label.text = dic[@"correcting_title_"];
    cell.user_name.text = [dic[@"name_"] isEqualToString:@""] ? dic[@"login_name_"] : dic[@"name_"];
    cell.date_label.text = [KPDateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%ld", [dic[@"update_time_"] integerValue]] withFormatStr:@"yyyy-MM-dd"];
    NSString *level = [NSString stringWithFormat:@"%@", dic[@"level_"]];
    cell.score.text = [NSString stringWithFormat:@"等级%@", level];
    if ([dic[@"update_time_"] integerValue] > 0) {
        if ([level isEqualToString:@"A"]) {
            cell.image_view.image = [UIImage imageNamed:@"level_1"];
        }else if ([level isEqualToString:@"B"]) {
            cell.image_view.image = [UIImage imageNamed:@"level_2"];
        }else if ([level isEqualToString:@"C"]) {
            cell.image_view.image = [UIImage imageNamed:@"level_3"];
        }else if ([level isEqualToString:@"D"]) {
            cell.image_view.image = [UIImage imageNamed:@"level_4"];
        }
    }else {
        cell.image_view.image = [UIImage imageNamed:@"level_4"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0;
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
    CorrectDetailsViewController *details = [[CorrectDetailsViewController alloc] init];
    details.correct_id = dic[@"id_"];
    [self.navigationController pushViewController:details animated:YES];
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
