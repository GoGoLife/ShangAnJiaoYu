//
//  FiveRoundsFirstViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "FiveRoundsFirstViewController.h"
#import "FiveRoundsFirstTableViewCell.h"
#import "View_Collectionview.h"
#import "TraningDoQuestionViewController.h"
#import "EssayTests_HomeViewController.h"

@interface FiveRoundsFirstViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, assign) NSInteger type_index;

/**
 分类 + 类别
 */
@property (nonatomic, strong) NSArray *type_data_array;

@property (nonatomic, strong) NSArray *exam_array;

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) View_Collectionview *topView;

@property (nonatomic, strong) NSIndexPath *current_categoty_indexPath;

@property (nonatomic, strong) UIView *header_view;

@end

@implementation FiveRoundsFirstViewController

- (void)getFirstRoundsData:(NSString *)rounds_id {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"fiveTrainingId":self.fiveTrainingId};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_five_training_node_list" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *type_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *typeDic in responseObject[@"data"][@"node_one_type"]) {
                //整理分类信息
                NSMutableArray *category_array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *categoryDic in typeDic[@"node_two_type"]) {
                    LineTest_Category_Model *model = [[LineTest_Category_Model alloc] init];
                    model.lineTest_category_id = categoryDic[@"key"];
                    model.lineTest_category_content = categoryDic[@"value"];
                    [category_array addObject:model];
                }
                
                [type_array addObject:@{@"type_name":typeDic[@"value"],
                                        @"type_id":typeDic[@"key"],
                                        @"type_category":[category_array copy],
                                        @"isHaveCategory":category_array.count == 0 ? @"0" : @"1"}];
            }
            weakSelf.type_data_array = [type_array copy];
            //整理试卷数据
            weakSelf.exam_array = responseObject[@"data"][@"five_train_node_list"];
            [weakSelf setViewUI];
            
            
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.type_index = 0;
    self.current_categoty_indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self getFirstRoundsData:@""];
}

- (void)setViewUI {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *type = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in self.type_data_array) {
        [type addObject:dic[@"type_name"]];
    }
    
    self.segment = [[UISegmentedControl alloc] initWithItems:[type copy]];
    self.segment.selectedSegmentIndex = 0;
    [self.view addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(40.0);
    }];
    [self.segment addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[FiveRoundsFirstTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.exam_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.exam_array[indexPath.row];
    FiveRoundsFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.title_label.text = dic[@"title_"];
    cell.details_label.text = dic[@"desc_"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.type_data_array[self.type_index];
    if ([dic[@"isHaveCategory"] integerValue]) {
        return 65.0;
    }else {
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)header_view {
    if (!_header_view) {
        _header_view = [[UIView alloc] init];
        _header_view.backgroundColor = WhiteColor;
    }
    return _header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.type_data_array[self.type_index];
//    UIView *header_view = [[UIView alloc] init];
    if ([dic[@"isHaveCategory"] integerValue]) {
        [self setHeaderView:self.header_view];
    }
    return self.header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)setHeaderView:(UIView *)header_view {
    header_view.backgroundColor = WhiteColor;
    //分类
    NSDictionary *dic = self.type_data_array[self.type_index];
    self.topView = [[View_Collectionview alloc] initWithFrame:CGRectZero];
    [self.topView setDataArray:dic[@"type_category"] withIndexPath:self.current_categoty_indexPath];
    [header_view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(0);
        make.left.equalTo(header_view.mas_left).offset(0);
        make.right.equalTo(header_view.mas_right).offset(0);
        make.height.mas_equalTo(65);
    }];
    //点击某个分类
    __weak typeof(self) weakSelf = self;
    self.topView.returnSelectedIndex = ^(NSIndexPath *indexPath) {
        weakSelf.current_categoty_indexPath = indexPath;
        LineTest_Category_Model *model = dic[@"type_category"][indexPath.row];
        NSString *catecory_id = model.lineTest_category_id;
        //获取数据
        [weakSelf getExamDataWithOneType:dic[@"type_id"] TwoType:catecory_id];
    };
}

- (void)changeType:(UISegmentedControl *)segment {
    self.type_index = segment.selectedSegmentIndex;
    [self.tableview reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.exam_array[indexPath.row];
    NSInteger type_index = [self.exam_array[indexPath.row][@"exam_type_"] integerValue];
    if (type_index == 1) {
        TraningDoQuestionViewController *doQuestion = [[TraningDoQuestionViewController alloc] init];
        doQuestion.doType = DoQuestionType_Training_First;
        doQuestion.isShowPlayer = YES;
        doQuestion.training_id = dic[@"id_"];
        //记录行测通关训练的试卷总数量
        [[NSUserDefaults standardUserDefaults] setObject:@([dic[@"topic_count_"] integerValue]) forKey:@"lineTestExamCount"];
        [self.navigationController pushViewController:doQuestion animated:YES];
    }else if (type_index == 2) {
        //大申论
        EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
        home.type = ESSAY_TESTS_TYPE_BigTestTraining;
        home.TestTraining_id = dic[@"id_"];
        [self.navigationController pushViewController:home animated:YES];
    }else if (type_index == 3) {
        //小申论
        EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
        home.type = ESSAY_TESTS_TYPE_SmallTestTraining;
        home.TestTraining_id = dic[@"id_"];
        [self.navigationController pushViewController:home animated:YES];
    }
}

- (void)getExamDataWithOneType:(NSString *)oneType TwoType:(NSString *)twoType {
    NSDictionary *param = @{@"fiveTrainingId":self.fiveTrainingId,
                            @"one_type_":oneType,
                            @"two_type_":twoType};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_five_training_node_list_current" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.exam_array = responseObject[@"data"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
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
