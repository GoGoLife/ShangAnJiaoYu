//
//  CityViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CityViewController.h"
#import "TestTableViewCell.h"
#import "StartViewController.h"
#import "DoExerciseViewController.h"
#import "QuanZhenTestsViewController.h"

@interface CityViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    [self setViewUI];
}

//省级下面的全部市级试卷
- (void)getData_city {
    NSDictionary *prame = @{
                            @"area_id_":self.province_id,
                            @"exam_one_type_": self.type == 1 ? @"00000000000000000001001600050000" : @"00000000000000000001001600060000",
                            @"exam_two_type_": self.type == 1 ? @"00000000000000000001001700030000" : @"00000000000000000001001700090000",
                            @"page_number":@"1",
                            @"page_size":@"200"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_message" Dic:prame SuccessBlock:^(id responseObject) {
        NSLog(@"city === %@", responseObject);
        weakSelf.dataArr = responseObject[@"data"];
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
    } FailureBlock:^(id error) {
        NSLog(@"error === %@", error);
    }];
}

- (void)setViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
//    self.tableview.rowHeight = TEST_CELL_HEIGHT;
    [self.tableview registerClass:[TestTableViewCell class] forCellReuseIdentifier:@"cityCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData_city];
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
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
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
