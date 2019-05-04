//
//  BasicsHomeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BasicsHomeViewController.h"
#import "View_Collectionview.h"
#import "BasicsHomeTableViewCell.h"
#import "StartViewController.h"
#import "LineTest_Category_Model.h"

@interface BasicsHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BasicsHomeViewController

- (void)getHttpDataFromCategoryID:(NSString *)category_id {
    NSDictionary *parma = @{@"exam_one_type_":@"00000000000000000001001600050000",
                            @"exam_two_type_":@"00000000000000000001001700010000",
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

    View_Collectionview *topView = [[View_Collectionview alloc] initWithFrame:CGRectZero];
    topView.dataArr = [category_array copy];

    //点击某个分类
    //执行的方法
    [self.view addSubview:topView];
    __weak typeof(self) weakSelf = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.mas_equalTo(65);
    }];
    topView.returnSelectedIndex = ^(NSIndexPath *indexPath) {
        LineTest_Category_Model *model = category_array[indexPath.row];
        NSString *catecory_id = model.lineTest_category_id;
        [weakSelf getHttpDataFromCategoryID:catecory_id];
    };

    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = SetColor(238, 238, 238, 1);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BasicsHomeTableViewCell class] forCellReuseIdentifier:@"homeCell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];

    [self setBack];
    
    [self getHttpDataFromCategoryID:@"00000000000000000001001800010000"];
    
}

#pragma mark -------  tableview   delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    BasicsHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    cell.titleLabel.text = dic[@"title_"];
    cell.contentLabel.text = dic[@"describe_"];
    cell.passLabel.hidden = YES;
    cell.dateLabel.text = @"需要转换";//dic[@"create_time_"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StartViewController *start = [[StartViewController alloc] init];
    start.type = QuestionType_Basics;
    start.information_id = self.dataArray[indexPath.row][@"id_"];
    [self.navigationController pushViewController:start animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
