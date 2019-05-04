//
//  ErrorQuestionBookViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ErrorQuestionBookViewController.h"
#import "View_Collectionview.h"
#import "BookContentTableViewCell.h"
#import "ErrorTagCollectionViewCell.h"
#import "ErrorTagModel.h"
#import "LineTest_Category_Model.h"
#import "ErrorBook_Question_Model.h"
#import "QuestionAnalysisViewController.h"
#import "DoExerciseViewController.h"
#import "ErrorBookNaviViewController.h"

//UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
@interface ErrorQuestionBookViewController ()<UITableViewDelegate, UITableViewDataSource, ErrorBookNaviDelegate>
@property (nonatomic, strong) UITableView *tableview;

//大分类视图
@property (nonatomic, strong) View_Collectionview *topView;

//分类数据
@property (nonatomic, strong) NSMutableArray *category_array;

//承载错因标签
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSArray *error_tag_dataArray;

//错题数据
@property (nonatomic, strong) NSMutableArray *errorBook_data_array;

//当前的分类IndexPath
@property (nonatomic, strong) NSIndexPath *current_indexPath;

//保存选择的错因标签
@property (nonatomic, strong) NSMutableArray *selected_errorTag_array;

@property (nonatomic, assign) NSInteger index;

/** 是否可以选择   用于删除操作 */
@property (nonatomic, assign) BOOL isCanSelect;

/** 要删除的数据 */
@property (nonatomic, strong) NSMutableArray *delete_array;

@end

@implementation ErrorQuestionBookViewController

//获取全部错因标签
- (void)getErrorAllTag {
    NSDictionary *parma = @{};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_error_label" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"all error tag === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            //整理错因标签
            NSMutableArray *tag_mutable_array = [NSMutableArray arrayWithCapacity:1];
            for (NSString *error_string in responseObject[@"data"]) {
                ErrorTagModel *model = [[ErrorTagModel alloc] init];
                model.tagString = error_string;
                [tag_mutable_array addObject:model];
            }
            weakSelf.error_tag_dataArray = [tag_mutable_array copy];
            [weakSelf.collectionview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//加载错题
- (void)getErrorQuestionHttpData:(NSString *)category_id ErrorTag_ID:(NSArray *)errorTag_array Page:(NSInteger)index {
    NSDictionary *parma = @{
                            @"topic_serial_number":category_id,
                            @"error_label":errorTag_array,//errorTag_array.count == 0 ? @"" : jsonString,
                            @"page_number":[NSString stringWithFormat:@"%ld", index],
                            @"page_size":@"20"
                            };
    
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_assort_pitfalls_question" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"all error question === %@", responseObject);
//        NSMutableArray *question_array = [NSMutableArray arrayWithCapacity:1];
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"][@"rows"]) {
                ErrorBook_Question_Model *model = [[ErrorBook_Question_Model alloc] init];
                model.errorBook_question_id = questionDic[@"id_"];
                model.errorBook_question_content = questionDic[@"title_"];
                [weakSelf.errorBook_data_array addObject:model];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if (weakSelf.errorBook_data_array.count == [responseObject[@"data"][@"records"] integerValue]) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
            [weakSelf.selected_errorTag_array removeAllObjects];
        }
        
    } FailureBlock:^(id error) {
        
    }];
}

/**
 根据type  获取错题本数据
 @param type 类型
 @param page 页码
 */
- (void)getErrorDataWithType:(NSString *)type Page:(NSInteger)page {
    if (page == 1) {
        [self.errorBook_data_array removeAllObjects];
    }
    NSDictionary *param = @{@"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"type_":type};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_type_pitfalls_question" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"all error question === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"]) {
                ErrorBook_Question_Model *model = [[ErrorBook_Question_Model alloc] init];
                model.errorBook_question_id = questionDic[@"id_"];
                model.errorBook_question_content = questionDic[@"title_"];
                [weakSelf.errorBook_data_array addObject:model];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
            [weakSelf.selected_errorTag_array removeAllObjects];
        }
        
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.current_indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.selected_errorTag_array = [NSMutableArray arrayWithCapacity:1];
    self.category_array = [NSMutableArray arrayWithCapacity:1];
    self.errorBook_data_array = [NSMutableArray arrayWithCapacity:1];
    self.index = 1;
    self.delete_array = [NSMutableArray arrayWithCapacity:1];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStylePlain target:self action:@selector(delete_action)];
    
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi"] style:UIBarButtonItemStylePlain target:self action:@selector(right_action)];
    self.navigationItem.rightBarButtonItems = @[right1, right];
    
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BookContentTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSInteger index = weakSelf.type + 1;
        [weakSelf getErrorDataWithType:[NSString stringWithFormat:@"%ld", index] Page:1];
    }];
    [self.tableview.mj_header beginRefreshing];
    
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index++;
        NSInteger index = weakSelf.type + 1;
        [weakSelf getErrorDataWithType:[NSString stringWithFormat:@"%ld", index] Page:weakSelf.index];
    }];
    
    
    UIButton *training_button = [UIButton buttonWithType:UIButtonTypeCustom];
    training_button.backgroundColor = ButtonColor;
    training_button.titleLabel.font = SetFont(14);
    [training_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [training_button setTitle:@"错题训练" forState:UIControlStateNormal];
    ViewRadius(training_button, 25.0);
    [training_button addTarget:self action:@selector(training_action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:training_button];
    [training_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-150);
        make.size.mas_equalTo(CGSizeMake(120, 50));
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.errorBook_data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ErrorBook_Question_Model *model = self.errorBook_data_array[indexPath.row];
    BookContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isHiddenTitle = NO;
    cell.isHiddenStarlevel = YES;
    cell.isCanSelect = self.isCanSelect;
    cell.select_image.image = [UIImage imageNamed:@"select_no"];
    cell.content_lable.text = model.errorBook_question_content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

//点击错题  跳转到解析
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ErrorBook_Question_Model *model = self.errorBook_data_array[indexPath.row];
    if (self.isCanSelect) {
        //表示删除状态
        BookContentTableViewCell *cell = (BookContentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([self.delete_array containsObject:model.errorBook_question_id]) {
            [self.delete_array removeObject:model.errorBook_question_id];
            cell.select_image.image = [UIImage imageNamed:@"select_no"];
        }else {
            [self.delete_array addObject:model.errorBook_question_id];
            cell.select_image.image = [UIImage imageNamed:@"select_yes"];
        }
    }else {
        QuestionAnalysisViewController *analysis = [[QuestionAnalysisViewController alloc] init];
        analysis.isShowNextButton = NO;
        analysis.analysis_array = @[model.errorBook_question_id];
        [self.navigationController pushViewController:analysis animated:YES];
    }
}

//删除
- (void)delete_action {
    if (self.isCanSelect) {
        [self showHUD];
        __weak typeof(self) weakSelf = self;
        NSDictionary *param = @{@"id_":[self.delete_array copy]};
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_pitfalls_question" Dic:param SuccessBlock:^(id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1) {
                NSLog(@"删除成功！！！！");
                weakSelf.isCanSelect = !weakSelf.isCanSelect;
                [weakSelf.delete_array removeAllObjects];
                [weakSelf getErrorDataWithType:[NSString stringWithFormat:@"%ld", self.type + 1] Page:1];
                [weakSelf hidden];
            }else {
                NSLog(@"删除失败！！！！");
                [weakSelf hidden];
            }
            
        } FailureBlock:^(id error) {
            [weakSelf hidden];
        }];
    }else {
        self.isCanSelect = !self.isCanSelect;
        [self.tableview reloadData];
    }
}

//导航
- (void)right_action {
    ErrorBookNaviViewController *navi = [[ErrorBookNaviViewController alloc] init];
    navi.delegate = self;
    [self.navigationController pushViewController:navi animated:YES];
}

#pragma mark ---------- training action ------------
//错题训练
- (void)training_action {
    [self showHUD];
    
    NSInteger type = self.type + 1;
    NSDictionary *param = @{@"size_":@"50",@"type_":[NSString stringWithFormat:@"%ld", type]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_pitfalls_question" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"response == %@", responseObject);
            [weakSelf hidden];
            
            EXERCISE_TYPE type;
            if (weakSelf.type == ErrorBookType_ONE) {
                type = EXERCISE_TYPE_ERRORBOOK_ONE;
            }else if (weakSelf.type == ErrorBookType_TWO) {
                type = EXERCISE_TYPE_ERRORBOOK_TWO;
            }else if (weakSelf.type == ErrorBookType_MORE) {
                type = EXERCISE_TYPE_ERRORBOOK_MORE;
            }else {
                type = EXERCISE_TYPE_ERRORBOOK_UNKNOW;
            }
            
            DoExerciseViewController *doExercise = [[DoExerciseViewController alloc] init];
            doExercise.type = type;
            doExercise.question_data = responseObject;
            [self.navigationController pushViewController:doExercise animated:YES];
        }
    } FailureBlock:^(id error) {
        
    }];
}

#pragma mark ------------ navi delegate -----------
- (void)returnSearchData:(NSDictionary *)data {
    NSLog(@"navi return data === %@", data);
    NSInteger navi_type = [data[@"big_type"] integerValue];
    __weak typeof(self) weakSelf = self;
    if (navi_type == 5) {
        //模块
        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.index = 1;
            [self getDataInModule:data[@"small_type"] Page:weakSelf.index];
        }];
        [self.tableview.mj_header beginRefreshing];
        
        self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.index++;
            [self getDataInModule:data[@"small_type"] Page:weakSelf.index];
        }];
    }else if (navi_type == 6) {
        //时间
        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.index = 1;
            [self getDataInTime:data[@"small_type"] Page:weakSelf.index];
        }];
        [self.tableview.mj_header beginRefreshing];
        
        self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.index++;
            [self getDataInTime:data[@"small_type"] Page:weakSelf.index];
        }];
    }else if (navi_type == 7) {
        //难度系数
        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.index = 1;
            [self getDataInDegree:data[@"small_type"] Page:weakSelf.index];
        }];
        [self.tableview.mj_header beginRefreshing];
        
        self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.index++;
            [self getDataInDegree:data[@"small_type"] Page:weakSelf.index];
        }];
    }else {
        //方法
        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.index = 1;
            [self getDataInFunc:data[@"small_type"] withPage:weakSelf.index];
        }];
        [self.tableview.mj_header beginRefreshing];
        
        self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.index++;
            [self getDataInFunc:data[@"small_type"] withPage:weakSelf.index];
        }];
    }
}

//根据模块获取数据
- (void)getDataInModule:(NSString *)choise_type Page:(NSInteger)page {
    if (page == 1) {
        [self.errorBook_data_array removeAllObjects];
    }
    NSDictionary *param = @{@"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"choice_type_":choise_type,
                            @"type_":[NSString stringWithFormat:@"%ld", self.type + 1]
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_model_pitfalls_question" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"]) {
                ErrorBook_Question_Model *model = [[ErrorBook_Question_Model alloc] init];
                model.errorBook_question_id = questionDic[@"id_"];
                model.errorBook_question_content = questionDic[@"title_"];
                [weakSelf.errorBook_data_array addObject:model];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
            [weakSelf.selected_errorTag_array removeAllObjects];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//根据时间获取数据
- (void)getDataInTime:(NSString *)time Page:(NSInteger)page {
    if (page == 1) {
        [self.errorBook_data_array removeAllObjects];
    }
    NSDictionary *param = @{@"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"times_":time,
                            @"type_":[NSString stringWithFormat:@"%ld", self.type + 1]
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_times_pitfalls_question" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"]) {
                ErrorBook_Question_Model *model = [[ErrorBook_Question_Model alloc] init];
                model.errorBook_question_id = questionDic[@"id_"];
                model.errorBook_question_content = questionDic[@"title_"];
                [weakSelf.errorBook_data_array addObject:model];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
            [weakSelf.selected_errorTag_array removeAllObjects];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//根据难度系数获取数据
- (void)getDataInDegree:(NSString *)degree Page:(NSInteger)page {
    if (page == 1) {
        [self.errorBook_data_array removeAllObjects];
    }
    NSDictionary *param = @{@"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"degree_":degree,
                            @"type_":[NSString stringWithFormat:@"%ld", self.type + 1]
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_degree_pitfalls_question" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"]) {
                ErrorBook_Question_Model *model = [[ErrorBook_Question_Model alloc] init];
                model.errorBook_question_id = questionDic[@"id_"];
                model.errorBook_question_content = questionDic[@"title_"];
                [weakSelf.errorBook_data_array addObject:model];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
            [weakSelf.selected_errorTag_array removeAllObjects];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)getDataInFunc:(NSString *)func_id withPage:(NSInteger)page {
    if (page == 1) {
        [self.errorBook_data_array removeAllObjects];
    }
    NSDictionary *param = @{@"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"id_":func_id,
                            @"type_":[NSString stringWithFormat:@"%ld", self.type + 1]
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_method_pitfalls_question" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"]) {
                ErrorBook_Question_Model *model = [[ErrorBook_Question_Model alloc] init];
                model.errorBook_question_id = questionDic[@"id_"];
                model.errorBook_question_content = questionDic[@"title_"];
                [weakSelf.errorBook_data_array addObject:model];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
            [weakSelf.selected_errorTag_array removeAllObjects];
        }
    } FailureBlock:^(id error) {
        
    }];
}

@end
