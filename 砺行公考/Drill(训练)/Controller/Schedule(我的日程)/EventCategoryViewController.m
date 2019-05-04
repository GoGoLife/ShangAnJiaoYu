//
//  EventCategoryViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/28.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "EventCategoryViewController.h"
#import "EventCategoryTableViewCell.h"
#import "ScheduleTagModel.h"
#import "AddTagViewController.h"

@interface EventCategoryViewController ()<UITableViewDelegate, UITableViewDataSource, AddTagDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

//是否编辑cell
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation EventCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.isEdit = NO;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"schedule_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonAction)];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"schedule_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editBarButtonAction)];
    self.navigationItem.rightBarButtonItems = @[right1, right];
    
    [self getDataFromDBDatabase];
    
    [self creatViewUI];
    
}

//- (void)formatData {
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
//    for (NSInteger index = 0; index < 4; index++) {
//        ScheduleTagModel *model = [[ScheduleTagModel alloc] init];
//        model.color = RandomColor;
//        model.content_string = @"睡眠";
//        [array addObject:model];
//    }
//    self.dataArray = [array copy];
//}

- (void)creatViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[EventCategoryTableViewCell class] forCellReuseIdentifier:@"eventCell"];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleTagModel *model = self.dataArray[indexPath.row];
    EventCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    cell.color_label.backgroundColor = SetColor([model.color_r integerValue], [model.color_g integerValue], [model.color_b integerValue], 1);
    cell.content_label.text = model.content_string;
    cell.isShowDeleteButton = self.isEdit;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return EventCategory_Cell_Height;
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

//添加新的标签
- (void)addBarButtonAction {
    AddTagViewController *add_tag = [[AddTagViewController alloc] init];
    add_tag.delegate = self;
    [self.navigationController pushViewController:add_tag animated:YES];
}

//编辑标签
- (void)editBarButtonAction {
    self.isEdit = !self.isEdit;
    [self.tableview reloadData];
}


#pragma mark ---- addtagview   delegate

/**
 新增标签的具体内容

 @param content 标签的内容
 @param color_r color_r
 @param color_g color_g
 @param color_b color_b
 */
- (void)returnTag_content:(NSString *)content Color_R:(NSString *)color_r Color_G:(NSString *)color_g Color_B:(NSString *)color_b {
    [[DBManager sharedInstance] setDataToTagDBColor_R:color_r Color_G:color_g Color_B:color_b isUsing:1 Content:content];
    //插入数据成功之后   查询并显示数据
    [self getDataFromDBDatabase];
}

- (void)getDataFromDBDatabase {
    NSString *sql_string = @"select * from t_scheduletag";
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:sql_string];
        NSMutableArray *data_array = [NSMutableArray arrayWithCapacity:1];
        while ([result next]) {
            NSString *color_r = [result stringForColumn:@"color_r"];
            NSString *color_g = [result stringForColumn:@"color_g"];
            NSString *color_b = [result stringForColumn:@"color_b"];
            NSString *tag_string = [result stringForColumn:@"content"];
            ScheduleTagModel *model = [[ScheduleTagModel alloc] init];
            model.color_r = color_r;
            model.color_g = color_g;
            model.color_b = color_b;
            model.content_string = tag_string;
            [data_array addObject:model];
        }
        self.dataArray = [data_array copy];
        [self.tableview reloadData];
    }
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
