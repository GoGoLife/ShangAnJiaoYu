//
//  SolveFunctionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SolveFunctionViewController.h"
#import "SolveFunctionTableViewCell.h"
#import "UIImage+Image.h"
#import "View_Collectionview.h"
#import "StartViewController.h"
#import "LineTest_Category_Model.h"

@interface SolveFunctionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *sectionArr;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SolveFunctionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)getHttpDataFromCategoryID:(NSString *)category_id {
    NSDictionary *parma = @{@"exam_one_type_":@"00000000000000000001001600050000",
                            @"exam_two_type_":@"00000000000000000001001700020000",
                            @"exam_three_type_":category_id
                            };
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_problem_solving_list" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"list === %@", responseObject);
        __weak typeof(self) weakSelf = self;
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
    
    [self setViewUI];
    
    [self setBack];
    
    self.sectionArr = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N"];
}

- (void)setViewUI {
    UIImageView *topImageV = [[UIImageView alloc] init];
    topImageV.image = [UIImage imageNamed:@"drill_function"];
    [self.view addSubview:topImageV];
    __weak typeof(self) weakSelf = self;
    [topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(-64);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(200);
    }];
    
    NSArray *category_array_init = @[@{@"id":@"00000000000000000001001800010000",@"title":@"言语理解"},
                                     @{@"id":@"00000000000000000001001800020000",@"title":@"数量关系"},
                                     @{@"id":@"00000000000000000001001800030000",@"title":@"判断推理"},
                                     @{@"id":@"00000000000000000001001800040000",@"title":@"资料分析"},
                                     @{@"id":@"00000000000000000001001800050000",@"title":@"常识判断"},
                                     @{@"id":@"00000000000000000001001800060000",@"title":@"综合分析"}];
    
    NSMutableArray *category_array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in category_array_init) {
        LineTest_Category_Model *model = [[LineTest_Category_Model alloc] init];
        model.lineTest_category_id = dic[@"id"];
        model.lineTest_category_content = dic[@"title"];
        [category_array addObject:model];
    }
    
    View_Collectionview *top_view = [[View_Collectionview alloc] init];
    top_view.dataArr = [category_array copy];
    [self.view addSubview:top_view];
    [top_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageV.mas_bottom).offset(0);
        make.leading.trailing.equalTo(weakSelf.view);
        make.height.mas_equalTo(65);
    }];
    top_view.returnSelectedIndex = ^(NSIndexPath *indexPath) {
        LineTest_Category_Model *model = category_array[indexPath.row];
        NSString *catecory_id = model.lineTest_category_id;
        [weakSelf getHttpDataFromCategoryID:catecory_id];
    };
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = SetColor(238, 238, 238, 1);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //隐藏tableview的分割线
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[SolveFunctionTableViewCell class] forCellReuseIdentifier:@"solve"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top_view.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self getHttpDataFromCategoryID:@"00000000000000000001001800010000"];
}

#pragma mark ---- tableview   delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    SolveFunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"solve"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = dic[@"title_"];
    cell.degreeLabel.text = dic[@"describe_"];
    cell.slider.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 20.0;
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
////    header_view.backgroundColor = WhiteColor;
//    UILabel *label = [[UILabel alloc] init];
//    label.text = self.sectionArr[section];
//    [header_view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
//    }];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = [UIColor clearColor];
    return footer_view;
}

////右侧索引
//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.sectionArr;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.sectionArr[section];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return index;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StartViewController *start = [[StartViewController alloc] init];
    start.type = QuestionType_Function;
    start.information_id = self.dataArray[indexPath.row][@"id_"];
    [self.navigationController pushViewController:start animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
