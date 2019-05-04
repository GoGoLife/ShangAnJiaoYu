//
//  SimulationTestViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/24.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SimulationTestViewController.h"
#import "TestTableViewCell.h"
#import "StartViewController.h"
#import "QuanZhenTestsViewController.h"

@interface SimulationTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *back_view;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) NSInteger type;

@end

@implementation SimulationTestViewController

/**
 获取模拟考试试卷
 */
- (void)getDataWithSimulationWithOneType:(NSString *)oneType TwoType:(NSString *)twoType {
    NSDictionary *prame = @{
                            @"exam_one_type_": oneType,
                            @"exam_two_type_":twoType,
                            @"page_number":@"1",
                            @"page_size":@"200"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_message" Dic:prame SuccessBlock:^(id responseObject) {
        NSLog(@"city === %@", responseObject);
        weakSelf.dataArr = responseObject[@"data"];
        [weakSelf.tableview reloadData];
    } FailureBlock:^(id error) {
        NSLog(@"error === %@", error);
    }];
}

- (void)creatTypeUI {
    __weak typeof(self) weakSelf = self;
    self.back_view = [[UIView alloc] init];
    [self.view addSubview:self.back_view];
    [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.mas_equalTo(60.0);
    }];
    
    CGFloat widht = (SCREENBOUNDS.width - 80) / 2;
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = SetColor(246, 246, 246, 1);
        [button setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
        [button setTitle:i == 0 ? @"行测" : @"申论" forState:UIControlStateNormal];
        button.tag = i;
        ViewRadius(button, 8.0);
        if (i == 0) {
            button.backgroundColor = SetColor(48, 132, 252, 1);
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
        [self.back_view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.back_view.mas_left).offset(20 * (i + 1) + widht * i);
            make.centerY.equalTo(weakSelf.back_view.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(widht, 40.0));
        }];
        [button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.type = 0;
    
    [self creatTypeUI];
    
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[TestTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
    
    [self getDataWithSimulationWithOneType:@"00000000000000000001001600050000" TwoType:@"00000000000000000001001700060000"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isShowLeftImage = YES;
    cell.isShowChoose = NO;
    cell.testNameLabel.text = self.dataArr[indexPath.row][@"title_"];
    cell.detailsLabel.text = [NSString stringWithFormat:@"考试时间:%@", self.dataArr[indexPath.row][@"year_"]];
    //    cell.tagLabel.text = @"新上线";
    //左侧image  添加点击事件   提供下载入口
    cell.leftImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchLeftImageAction)];
    [cell.leftImageV addGestureRecognizer:tap];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title_string = self.dataArr[indexPath.row][@"title_"];
    return [self calculateRowHeight:title_string fontSize:16 withWidth:SCREENBOUNDS.width - 110] + 50.0;
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
    if (self.type == 0) {
        //跳转做题  行测
        StartViewController *start = [[StartViewController alloc] init];
        start.type = QuestionType_Bank;
        start.information_id = self.dataArr[indexPath.row][@"id_"];
        [self.navigationController pushViewController:start animated:YES];
    }else {
        //申论
        QuanZhenTestsViewController *test = [[QuanZhenTestsViewController alloc] init];
        test.information_id = self.dataArr[indexPath.row][@"id_"];
        [self.navigationController pushViewController:test animated:YES];
    }
    
}

//下载操作
- (void)touchLeftImageAction {
    NSLog(@"down load");
}

- (void)touchButtonAction:(UIButton *)sender {
    for (UIButton *button in self.back_view.subviews) {
        if (button.tag == sender.tag) {
            self.type = sender.tag;
            button.backgroundColor = SetColor(48, 132, 252, 1);
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            if (sender.tag == 0) {
                [self getDataWithSimulationWithOneType:@"00000000000000000001001600050000" TwoType:@"00000000000000000001001700060000"];
            }else {
                [self getDataWithSimulationWithOneType:@"00000000000000000001001600060000" TwoType:@"00000000000000000001001700110000"];
            }
        }else {
            button.backgroundColor = SetColor(246, 246, 246, 1);
            [button setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
        }
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
