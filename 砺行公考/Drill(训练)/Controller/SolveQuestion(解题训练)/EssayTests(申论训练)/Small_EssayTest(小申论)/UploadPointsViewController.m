//
//  UploadPointsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/8.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "UploadPointsViewController.h"
#import "ChooseMaterialsTableViewCell.h"
#import "ImageIdentifyManager.h"
#import "CustomMaterialsModel.h"
#import "ClassifyViewController.h"
#import "Big_ThreeViewController.h"

@interface UploadPointsViewController ()<UITableViewDelegate, UITableViewDataSource, ImageIdentifyManagerDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation UploadPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加采点";
    [self setBack];
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ChooseMaterialsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getHttpData];
    }];
    [self.tableview.mj_header beginRefreshing];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextVC)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomMaterialsModel *model = self.dataArr[indexPath.row];
    ChooseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isHiddenRightImage = YES;
    cell.content_label.text = [NSString stringWithFormat:@"%@：%@", model.tag_type_string, model.content_string];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomMaterialsModel *model = self.dataArr[indexPath.row];
    return model.content_string_height + 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    
    UIButton *add_materials = [UIButton buttonWithType:UIButtonTypeCustom];
    add_materials.backgroundColor = ButtonColor;
    ViewRadius(add_materials, 8.0);
    [add_materials setTitleColor:WhiteColor forState:UIControlStateNormal];
    [add_materials setTitle:@"添加采点" forState:UIControlStateNormal];
    [footer_view addSubview:add_materials];
    [add_materials mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    [add_materials addTarget:self action:@selector(touchAddMaterialsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return footer_view;
}

- (void)touchAddMaterialsAction {
    ImageIdentifyManager *manager = [ImageIdentifyManager sharedManager];
    manager.delegate = self;
    [manager createInstanceCurrentVC:self];
}

- (void)returnIdentifyString:(NSString *)text {
    NSLog(@"文字识别结果 text === %@", text);
    __block NSString *tag_id = @"";
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择标签" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"表现" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        tag_id = @"00000000000000000001001400010000";
        [weakSelf uploadCollectPointsToService:tag_id content:text];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"效果" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        tag_id = @"00000000000000000001001400020000";
        [weakSelf uploadCollectPointsToService:tag_id content:text];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"原因" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        tag_id = @"00000000000000000001001400030000";
        [weakSelf uploadCollectPointsToService:tag_id content:text];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"对策" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        tag_id = @"00000000000000000001001400040000";
        [weakSelf uploadCollectPointsToService:tag_id content:text];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"背景" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        tag_id = @"00000000000000000001001400050000";
        [weakSelf uploadCollectPointsToService:tag_id content:text];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)uploadCollectPointsToService:(NSString *)tag_id content:(NSString *)text {
    NSDictionary *param = @{
                            @"id_":tag_id,
                            @"content_":text,
                            @"note_":@""
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_question_catch" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"采点信息上传成功!!!");
            [weakSelf.tableview.mj_header beginRefreshing];
        }else {
            NSLog(@"采点信息上传失败!!!");
        }
    } FailureBlock:^(id error) {
        NSLog(@"采点信息上传失败!!!");
    }];
}

- (void)getHttpData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_question_catch" Dic:@{} SuccessBlock:^(id responseObject) {
        //        NSLog(@"data === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf formatHttpData:responseObject[@"data"]];
            [weakSelf.tableview.mj_header endRefreshing];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)formatHttpData:(NSArray *)dataArr {
    //整理数据
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in dataArr) {
        CustomMaterialsModel *model = [[CustomMaterialsModel alloc] init];
        model.materials_id = dic[@"id_"];
        model.tag_string_id = dic[@"tips_id_"];
        model.content_string = [dic[@"content_"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];;//@"如果你无法简随便看了封建时代雷锋精神理念就是厉害；六块腹肌克莱斯勒福克斯老骥伏枥开始康复科了时间洁的表达，你的想法如果你无法简太好气哦外婆家鹅礼物哦我洁。";
        model.tag_string = dic[@"note_"];//@"注解词";
        model.tag_type_string = dic[@"tips_content_"];
        model.isSelected = NO;
        [mutableArr addObject:model];
    }
    self.dataArr = [mutableArr copy];
    [self.tableview reloadData];
}

/**
 下一步
 */
- (void)pushNextVC {
    if (self.isBigTest) {
        Big_ThreeViewController *big_three = [[Big_ThreeViewController alloc] init];
        [self.navigationController pushViewController:big_three animated:YES];
    }else {
        ClassifyViewController *classify = [[ClassifyViewController alloc] init];
        [self.navigationController pushViewController:classify animated:YES];
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
