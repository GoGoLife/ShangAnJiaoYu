//
//  FiveRoundsThirdViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/19.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "FiveRoundsThirdViewController.h"
#import "View_Collectionview.h"
#import "FiveRoundsFirstTableViewCell.h"
#import "TraningDoQuestionViewController.h"
#import "EssayTests_HomeViewController.h"

@interface FiveRoundsThirdViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *categoryArray;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) View_Collectionview *topView;

@property (nonatomic, strong) NSString *oneType;

@end

@implementation FiveRoundsThirdViewController

- (void)getThirdData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"fiveTrainingId":self.fiveTrainingID};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_five_training_node_list" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *category_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"node_one_type"]) {
                weakSelf.oneType = dic[@"key"];
                for (NSDictionary *twoTypeDic in dic[@"node_two_type"]) {
                    LineTest_Category_Model *model = [[LineTest_Category_Model alloc] init];
                    model.lineTest_category_id = twoTypeDic[@"key"];
                    model.lineTest_category_content = twoTypeDic[@"value"];
                    [category_array addObject:model];
                }
            }
            weakSelf.categoryArray = [category_array copy];
            weakSelf.topView.dataArr = [category_array copy];
            weakSelf.dataArray = responseObject[@"data"][@"five_train_node_list"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)getExamDataWithOneType:(NSString *)oneType TwoType:(NSString *)twoType {
    NSDictionary *param = @{@"fiveTrainingId":self.fiveTrainingID,
                            @"one_type_":oneType,
                            @"two_type_":twoType};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_five_training_node_list_current" Dic:param SuccessBlock:^(id responseObject) {
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
    [self setBack];
    
    __weak typeof(self) weakSelf = self;
    self.topView = [[View_Collectionview alloc] initWithFrame:CGRectZero];
//    [self.topView setDataArray:dic[@"type_category"] withIndexPath:self.current_categoty_indexPath];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.mas_equalTo(65);
    }];
    //点击某个分类
    self.topView.returnSelectedIndex = ^(NSIndexPath *indexPath) {
        LineTest_Category_Model *model = weakSelf.categoryArray[indexPath.row];
        NSString *catecory_id = model.lineTest_category_id;
        //获取数据
        [weakSelf getExamDataWithOneType:weakSelf.oneType TwoType:catecory_id];
    };
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[FiveRoundsFirstTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(70, 0, 0, 0));
    }];
    
    [self getThirdData];
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
    NSInteger type_index = [self.dataArray[indexPath.row][@"exam_type_"] integerValue];
    if (type_index == 1) {
        TraningDoQuestionViewController *doQuestion = [[TraningDoQuestionViewController alloc] init];
        doQuestion.doType = DoQuestionType_Training_First;
        doQuestion.isShowPlayer = NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
