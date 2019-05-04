//
//  SendQuestionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/28.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SendQuestionViewController.h"
#import "View_Collectionview.h"
#import "BookContentTableViewCell.h"
#import "ChatViewController.h"
#import "LookQuestionDetailsViewController.h"

@interface SendQuestionViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    //选择的题目数组
    NSMutableArray *select_array;
    //是否出于选择状态
    BOOL isCanSelectType;
}

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) ChatViewController *chatVC;

@property (nonatomic, strong) NSMutableArray *dataArray;

//当前分类的ID
@property (nonatomic, strong) NSString *current_category_id;
//数据页数
@property (nonatomic, assign) NSInteger page;

@end

@implementation SendQuestionViewController

- (void)getQuestionDataWithModule:(NSString *)module_id page:(NSInteger)page {
    if (page == 1) {
        isCanSelectType = NO;
        [select_array removeAllObjects];
        [self.dataArray removeAllObjects];
        UIBarButtonItem *right = self.navigationItem.rightBarButtonItems[0];
        right.title = @"编辑";
    }
    NSDictionary *parma = @{
                            @"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"topic_serial_number":module_id
                            };
    NSLog(@"parma == %@", parma);
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_assort_choice_question" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"response === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"data"][@"rows"]];
        }
        
        [weakSelf.tableview reloadData];
        
        [weakSelf.tableview.mj_header endRefreshing];
        
        if (self.dataArray.count <= [responseObject[@"data"][@"records"] integerValue]) {
            [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
        }else {
            [weakSelf.tableview.mj_footer endRefreshing];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择题目";
    [self setBack];
    
    select_array = [NSMutableArray arrayWithCapacity:1];
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.page = 1;
    self.current_category_id = @"";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeCellTyep)];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendQuestionsAction)];
    self.navigationItem.rightBarButtonItems = @[right, right1];
    
    
    //整理分类数据
    NSArray *category_array_init = @[@{@"id":@"",@"title":@"全部"},
                                     @{@"id":@"00000000000000000001000100010000",@"title":@"言语理解"},
                                     @{@"id":@"00000000000000000001000100020000",@"title":@"数量关系"},
                                     @{@"id":@"00000000000000000001000100030000",@"title":@"判断推理"},
                                     @{@"id":@"00000000000000000001000100040000",@"title":@"资料分析"},
                                     @{@"id":@"00000000000000000001000100050000",@"title":@"常识判断"},
                                     @{@"id":@"00000000000000000001000100060000",@"title":@"综合分析"}];
    
    NSMutableArray *category_array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in category_array_init) {
        LineTest_Category_Model *model = [[LineTest_Category_Model alloc] init];
        model.lineTest_category_id = dic[@"id"];
        model.lineTest_category_content = dic[@"title"];
        [category_array addObject:model];
    }
    
    View_Collectionview *topView = [[View_Collectionview alloc] initWithFrame:CGRectZero];
    topView.dataArr = [category_array copy];
    [self.view addSubview:topView];
    __weak typeof(self) weakSelf = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.mas_equalTo(65);
    }];
    //点击某个分类
    //执行的方法
    topView.returnSelectedIndex = ^(NSIndexPath *indexPath) {
        LineTest_Category_Model *model = category_array[indexPath.row];
        weakSelf.current_category_id = model.lineTest_category_id;
//        [weakSelf getQuestionDataWithModule:weakSelf.current_category_id page:1];
        [weakSelf.tableview.mj_header beginRefreshing];
    };
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.estimatedRowHeight = 0;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BookContentTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(65, 0, 0, 0));
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getQuestionDataWithModule:weakSelf.current_category_id page:1];
    }];
    [self.tableview.mj_header beginRefreshing];
    
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getQuestionDataWithModule:weakSelf.current_category_id page:weakSelf.page];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    BookContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isCanSelect = isCanSelectType;
    cell.isHiddenStarlevel = YES;
    if ([select_array containsObject:indexPath]) {
        cell.select_image.image = [UIImage imageNamed:@"select_yes"];
    }else {
        cell.select_image.image = [UIImage imageNamed:@"select_no"];
    }
    cell.content_lable.text = dic[@"title_"];
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
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    if (!isCanSelectType) {
        LookQuestionDetailsViewController *look = [[LookQuestionDetailsViewController alloc] init];
        look.question_id = dic[@"id_"];
        [self.navigationController pushViewController:look animated:YES];
        return;
    }
    
    BookContentTableViewCell *cell = (BookContentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([select_array containsObject:dic]) {
        [select_array removeObject:dic];
        cell.select_image.image = [UIImage imageNamed:@"select_no"];
    }else {
        [select_array addObject:dic];
        cell.select_image.image = [UIImage imageNamed:@"select_yes"];
    }
}

- (void)changeCellTyep {
    UIBarButtonItem *right = self.navigationItem.rightBarButtonItems[0];
    isCanSelectType = !isCanSelectType;
    if (isCanSelectType) {
        right.title = @"取消";
        [select_array removeAllObjects];
    }else {
        right.title = @"编辑";
    }
    [self.tableview reloadData];
}

/**
 发送题目
 */
- (void)sendQuestionsAction {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChatViewController class]]) {
            self.chatVC =(ChatViewController *)controller;

            for (NSDictionary *dic in select_array) {
                NSDictionary *json_dic = @{@"id_":dic[@"id_"],
                                           @"title_":dic[@"title_"],
                                           @"topic_tag":@"行测"};
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                NSDictionary *data = @{@"type":@"行测",
                                       @"id":dic[@"id_"],
                                       @"message":dic[@"title_"],
                                       @"message_attr_is_topic":@(1),
                                       @"message_attr_is_topic_content":jsonString
                                       };
                [self.chatVC sendRecommendFriend:data];
            }

            [self.navigationController popToViewController:self.chatVC animated:YES];
        }
    }
    
    
    
    
    
//    self.returnSelectQuestionBlock([select_array copy]);
//    [self.navigationController popViewControllerAnimated:YES];
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
