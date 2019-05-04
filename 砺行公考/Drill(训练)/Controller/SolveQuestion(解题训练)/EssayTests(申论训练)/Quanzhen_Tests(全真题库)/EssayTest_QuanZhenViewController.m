//
//  EssayTest_QuanZhenViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/2.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "EssayTest_QuanZhenViewController.h"
#import "TestTableViewCell.h"
#import "StartViewController.h"
#import "QuanZhenTestsViewController.h"

@interface EssayTest_QuanZhenViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation EssayTest_QuanZhenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    [self setViewUI];
    
    //获取市级试卷
    [self getData_city];
}

//省级下面的全部市级试卷
- (void)getData_city {
    NSDictionary *prame = @{
                            @"area_id_":@"330000",
                            @"exam_one_type_":@"00000000000000000001001600060000",
                            @"exam_two_type_":@"00000000000000000001001700090000",
                            @"page_number":@"1",
                            @"page_size":@"20"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_message" Dic:prame SuccessBlock:^(id responseObject) {
        NSLog(@"city === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArr = responseObject[@"data"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        NSLog(@"error === %@", error);
    }];
}

- (void)setViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = TEST_CELL_HEIGHT;
    [self.tableview registerClass:[TestTableViewCell class] forCellReuseIdentifier:@"cityCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
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
    cell.testNameLabel.text = self.dataArr[indexPath.row][@"title_"];
    cell.detailsLabel.text = [NSString stringWithFormat:@"考试时间:%@", self.dataArr[indexPath.row][@"year_"]];
    cell.tagLabel.text = @"新上线";
    cell.rightImageV.image = [UIImage imageNamed:@"right"];
    //左侧image  添加点击事件   提供下载入口
    cell.leftImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchLeftImageAction)];
    [cell.leftImageV addGestureRecognizer:tap];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //跳转做题
//    StartViewController *start = [[StartViewController alloc] init];
//    start.type = QuestionType_Bank;
//    start.information_id = self.dataArr[indexPath.row][@"id_"];
//    [self.navigationController pushViewController:start animated:YES];
    QuanZhenTestsViewController *test = [[QuanZhenTestsViewController alloc] init];
    test.information_id = self.dataArr[indexPath.row][@"id_"];
    [self.navigationController pushViewController:test animated:YES];
    
}

//下载操作
- (void)touchLeftImageAction {
    NSLog(@"down load");
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
