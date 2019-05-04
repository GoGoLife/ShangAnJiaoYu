//
//  FiveRoundsSecondViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/19.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "FiveRoundsSecondViewController.h"
#import "FiveRoundsFirstTableViewCell.h"
#import "TrainingHomeViewController.h"
#import "EssayTests_HomeViewController.h"

@interface FiveRoundsSecondViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FiveRoundsSecondViewController

- (void)getDataWithSecond {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"fiveTrainingId":self.fiveTrainingId};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_five_training_node_list" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"][@"five_train_node_list"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBack];
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[FiveRoundsFirstTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getDataWithSecond];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    FiveRoundsFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.title_label.text = dic[@"title_"];
    cell.details_label.text = dic[@"desc_"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
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
    NSInteger index = [dic[@"id_"] integerValue];
    if (index == 1) {
        TrainingHomeViewController *home = [[TrainingHomeViewController alloc] init];
        home.training_id = self.fiveTrainingId;
        [self.navigationController pushViewController:home animated:YES];
    }else if (index == 2) {
        EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
        home.type = ESSAY_TESTS_TYPE_BigTestTraining;
        home.TestTraining_id = self.fiveTrainingId;
        [self.navigationController pushViewController:home animated:YES];
    }else if (index == 3) {
        EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
        home.type = ESSAY_TESTS_TYPE_SmallTestTraining;
        home.TestTraining_id = self.fiveTrainingId;
        [self.navigationController pushViewController:home animated:YES];
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
