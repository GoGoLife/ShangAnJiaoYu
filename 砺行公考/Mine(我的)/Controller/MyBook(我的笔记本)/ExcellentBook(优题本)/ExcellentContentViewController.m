//
//  ExcellentContentViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ExcellentContentViewController.h"
#import "BookContentTableViewCell.h"
#import "QuestionAnalysisViewController.h"
#import "ErrorBookNaviViewController.h"

@interface ExcellentContentViewController ()<UITableViewDelegate, UITableViewDataSource, ErrorBookNaviDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger index;

@end

@implementation ExcellentContentViewController

//获取笔记本下的数据
- (void)getHttpData {
//    NSLog(@"youtiben   book_id === %@", self.book_id);
    NSDictionary *parma = @{
                            @"note_id_":self.book_id,
                            @"is_sorting_":@"1"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_good_question" Dic:parma SuccessBlock:^(id responseObject) {
//        NSLog(@"responseobject === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_header endRefreshing];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(right_edit_action)];
    
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi"] style:UIBarButtonItemStylePlain target:self action:@selector(right_action)];
    
    self.navigationItem.rightBarButtonItems = @[right1, right];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BookContentTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getHttpData];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    BookContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isHiddenTitle = NO;
    cell.isHiddenStarlevel = YES;
    cell.isCanSelect = self.isEdit;
    cell.content_lable.text = dic[@"title_"];
    cell.date_label.text = dic[@"create_time_"];
    cell.starLevel_view.score = [dic[@"star_"] floatValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString *string = [NSString stringWithFormat:@"简介：%@", self.book_details];//@"简介：里面都是一些我觉得特别有感觉的.......句子，相当的感觉的.......句子，相当的感觉的.......句子，相当的感觉的.......句子，相当的棒...";
        CGFloat height = [self calculateRowHeight:string fontSize:16 withWidth:SCREENBOUNDS.width - 40];
        return height + 210;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    if (section == 0) {
        header_view.backgroundColor = WhiteColor;
        [self setHeaderView:header_view];
    }
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    QuestionAnalysisViewController *analysis = [[QuestionAnalysisViewController alloc] init];
    analysis.nextButton.hidden = YES;
    analysis.analysis_array = @[dic[@"id_"]];
    [self.navigationController pushViewController:analysis animated:YES];
}

//开始编辑
- (void)right_edit_action {
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItems[1];
    item.title = @"取消";
    item.action = @selector(cancel_edit_action);
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel_edit_action)];
//    self.navigationItem.rightBarButtonItem = right;
    self.isEdit = YES;
    [self.tableview reloadData];
}

//取消编辑
- (void)cancel_edit_action {
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItems[1];
    item.title = @"编辑";
    item.action = @selector(right_edit_action);
//    self.navigationItem.rightBarButtonItem = nil;
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(right_action)];
//    self.navigationItem.rightBarButtonItem = right;
    self.isEdit = NO;
    [self.tableview reloadData];
}

- (void)setHeaderView:(UIView *)header_view {
    UIImageView *header_image = [[UIImageView alloc] init];
    [header_image sd_setImageWithURL:[NSURL URLWithString:self.book_image_url] placeholderImage:[UIImage imageNamed:@"no_image"]];
    ViewRadius(header_image, 8.0);
    [header_view addSubview:header_image];
    [header_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(20);
        make.centerX.equalTo(header_view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    label.text = self.book_name;//@"特别有感觉的句子";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header_view.mas_centerX);
        make.top.equalTo(header_image.mas_bottom).offset(10);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(12);
    label1.textColor = DetailTextColor;
    label1.text = [NSString stringWithFormat:@"已收录%@条", self.book_numbers];//@"已收录213条";
    [header_view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header_view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(10);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = SetFont(16);
    label2.textColor = DetailTextColor;
    label2.numberOfLines = 0;
    label2.text = [NSString stringWithFormat:@"简介：%@", self.book_details];//@"简介：里面都是一些我觉得特别有感觉的.......句子，相当的感觉的.......句子，相当的感觉的.......句子，相当的感觉的.......句子，相当的棒...";
    [header_view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
    }];
}

//导航
- (void)right_action {
    ErrorBookNaviViewController *navi = [[ErrorBookNaviViewController alloc] init];
    navi.delegate = self;
    [self.navigationController pushViewController:navi animated:YES];
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
        [self.dataArray removeAllObjects];
    }
    NSDictionary *param = @{@"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"choice_type_":choise_type,
                            @"note_id_":self.book_id
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_model_good_question" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"]) {
                [weakSelf.dataArray addObject:questionDic];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//根据时间获取数据
- (void)getDataInTime:(NSString *)time Page:(NSInteger)page {
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *param = @{@"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"times_":time,
                            @"note_id_":self.book_id
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_times_good_question" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"]) {
                [weakSelf.dataArray addObject:questionDic];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
//            [weakSelf.selected_errorTag_array removeAllObjects];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//根据难度系数获取数据
- (void)getDataInDegree:(NSString *)degree Page:(NSInteger)page {
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *param = @{@"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"note_id_":self.book_id,
                            @"degree_":degree
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_degree_good_question" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"]) {
                [weakSelf.dataArray addObject:questionDic];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
//            [weakSelf.selected_errorTag_array removeAllObjects];
        }
    } FailureBlock:^(id error) {
        
    }];
}

/**
 按方法查看优题

 @param func_id func_id
 @param page page
 */
- (void)getDataInFunc:(NSString *)func_id withPage:(NSInteger)page {
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *param = @{@"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"id_":func_id,
                            @"note_id_":self.book_id
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_method_good_question" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *questionDic in responseObject[@"data"]) {
                [weakSelf.dataArray addObject:questionDic];
            }
            
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
//            [weakSelf.selected_errorTag_array removeAllObjects];
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
