//
//  ProvinceTestViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ProvinceTestViewController.h"
#import "TestTableViewCell.h"
#import "MOLoadHTTPManager.h"
#import "testModel.h"
#import "CityViewController.h"

@interface ProvinceTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArr;

//保存已经选择的试卷
@property (nonatomic, strong) NSMutableArray *selectedArr;

//判断是否点击了全选
@property (nonatomic, assign) BOOL isAllChoose;

@end

@implementation ProvinceTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化 selectedArr
    self.selectedArr = [NSMutableArray arrayWithCapacity:1];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(downLoadAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self setViewUI];
    [self setBack];
}

//获取真题试卷数据
- (void)getData {
    NSDictionary *parma = @{};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_province" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"province === %@", responseObject);
        if ([responseObject[@"state"] integerValue] ==1) {
            NSMutableArray *dataMutableArr = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *data in responseObject[@"data"]) {
                testModel *model = [[testModel alloc] init];
                model.test_id = data[@"id_"];
                model.testNameString = data[@"name_"];
                model.testDetailString = [NSString stringWithFormat:@"线上试卷：%@", @"2018-1-7"];//@"线上试卷:2001-2017";
                model.tagString = @"";//@"目标省份,不建议训练使用";
                model.isShowChoose = NO;
                model.isSelected = NO;
                [dataMutableArr addObject:model];
            }
            weakSelf.dataArr = [dataMutableArr copy];
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_header endRefreshing];
        }else {
            [weakSelf showHUDWithTitle:responseObject[@"msg"]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)setViewUI {
    __weak typeof(self) weakSelf = self;
    UISearchBar *search = [[UISearchBar alloc] init];
    search.tintColor = [UIColor whiteColor];
    search.barTintColor = [UIColor whiteColor];
    UIImage *backImage = [self GetImageWithColor:[UIColor whiteColor] andHeight:32.0];
    search.backgroundImage = backImage;
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    searchTextField = [[[search.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = SetColor(246, 246, 246, 1);
    search.placeholder = @"输入关键词...";
    [self.view addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.mas_equalTo(52);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = TEST_CELL_HEIGHT;
    [self.tableview registerClass:[TestTableViewCell class] forCellReuseIdentifier:@"test"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(search.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    testModel *model = self.dataArr[indexPath.row];
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    cell.testNameLabel.text = model.testNameString;
    cell.detailsLabel.text = model.testDetailString;
    cell.tagLabel.text = model.tagString;
    cell.isShowChoose = model.isShowChoose;
    cell.isSelected = model.isSelected;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    testModel *model = self.dataArr[indexPath.row];
    //判断是否出于选择状态
    if (model.isShowChoose) {
        //若处于选择状态   判断是否已经选择
        if ([self.selectedArr containsObject:indexPath]) {
            model.isSelected = NO;
            [self.selectedArr removeObject:indexPath];
        }else {
            model.isSelected = YES;
            [self.selectedArr addObject:indexPath];
        }
        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else {
        //若不是出于选择状态   则进行页面跳转
//        NSLog(@"push push push push push push");
        CityViewController *city = [[CityViewController alloc] init];
        city.type = self.type;
        city.province_id = model.test_id;
        [self.navigationController pushViewController:city animated:YES];
    }
}

//下载按钮   方法
- (void)downLoadAction {
    self.navigationItem.rightBarButtonItems = nil;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAllAction)];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItems = @[save, right];
    for (testModel *model in self.dataArr) {
        model.isShowChoose = YES;
    }
    [self.tableview reloadData];
}

//全选
- (void)chooseAllAction {
    NSLog(@"isAllChoose == %d", self.isAllChoose);
    if (self.isAllChoose) {
        for (testModel *model in self.dataArr) {
            model.isSelected = NO;
        }
        self.isAllChoose = NO;
    }else {
        for (testModel *model in self.dataArr) {
            model.isSelected = YES;
        }
        self.isAllChoose = YES;
    }
    [self.tableview reloadData];
}

//保存
- (void)saveAction {
    self.navigationItem.rightBarButtonItems = nil;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(downLoadAction)];
    self.navigationItem.rightBarButtonItem = right;
    for (testModel *model in self.dataArr) {
        model.isShowChoose = NO;
        model.isSelected = NO;
    }
    [self.tableview reloadData];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"链接复制成功，请在电脑端打开下载" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
