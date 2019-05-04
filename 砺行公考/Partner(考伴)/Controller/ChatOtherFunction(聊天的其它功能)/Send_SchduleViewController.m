//
//  Send_SchduleViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/5.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "Send_SchduleViewController.h"
#import "Send_SchduleTableViewCell.h"
#import "ChooseDateView.h"
#import "ChatViewController.h"

@interface Send_SchduleViewController ()<UITableViewDelegate, UITableViewDataSource, ChooseDateViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *date_init_array;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSArray *data_array;

@property (nonatomic, strong) ChatViewController *chatVC;

@end

@implementation Send_SchduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"日程表";
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"发送" target:self action:@selector(sendScheduleAction)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date_string = [formatter stringFromDate:[NSDate date]];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.button.backgroundColor = WhiteColor;
    [self.button setTitle:date_string forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    __weak typeof(self) weakSelf = self;
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(30.0);
    }];
    [self.button addTarget:self action:@selector(chooseDateAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[Send_SchduleTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    
    //获取数据
    [self returnDataWithDate:date_string];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.data_array[indexPath.row];
    Send_SchduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.left_label.text = [NSString stringWithFormat:@"%@ - %@", dic[@"time"], [self afterTimeWithCustomTIme:dic[@"time"]]];
    cell.right_label.text = dic[@"content"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    CGFloat width = (SCREENBOUNDS.width - 40) / 3;
    UILabel *left_label = [[UILabel alloc] init];
    left_label.font = SetFont(16);
    left_label.textAlignment = NSTextAlignmentCenter;
    ViewBorderRadius(left_label, 0.0, 1.0, SetColor(233, 233, 233, 1));
    [header_view addSubview:left_label];
    [left_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.bottom.equalTo(header_view.mas_bottom);
        make.width.mas_equalTo(width);
    }];
    left_label.text = @"时间";
    
    UILabel *right_label = [[UILabel alloc] init];
    right_label.font = SetFont(16);
    right_label.textAlignment = NSTextAlignmentCenter;
    ViewBorderRadius(right_label, 0.0, 1.0, SetColor(233, 233, 233, 1));
    [header_view addSubview:right_label];
    [right_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(left_label.mas_top);
        make.left.equalTo(left_label.mas_right);
        make.bottom.equalTo(left_label.mas_bottom);
        make.right.equalTo(header_view.mas_right).offset(-20);
    }];
    right_label.text = @"任务";
    
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)chooseDateAction {
    //年
    NSMutableArray *year_array = [NSMutableArray arrayWithCapacity:1];
    NSString *current_year = [KPDateTool currentDateStrWithFormatter:@"yyyy"];
    NSInteger year = [current_year integerValue];
    for (NSInteger index = year - 3; index <= year; index++) {
        [year_array addObject:[NSString stringWithFormat:@"%ld", index]];
    }
    
    //月
    NSMutableArray *month_array = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 1; index <= 12; index++) {
        [month_array addObject:[NSString stringWithFormat:@"%ld", index]];
    }
    
    //获取每月天数
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    NSMutableArray *day_array = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 1; index <= numberOfDaysInMonth; index++) {
        [day_array addObject:[NSString stringWithFormat:@"%ld", index]];
    }
    
    self.date_init_array = @[[year_array copy], [month_array copy], [day_array copy]];
    
    ChooseDateView *chooseDate = [[ChooseDateView alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 64 - 300, SCREENBOUNDS.width, 300.0)];
    chooseDate.delegate = self;
    chooseDate.dataArray = self.date_init_array;
    [self.view addSubview:chooseDate];
}

- (void)returnSelectFunctionStringAtIndex:(NSArray *)rowData {
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in rowData) {
        NSInteger component = [dic[@"component"] integerValue];
        NSInteger row = [dic[@"row"] integerValue];
        NSString *data_string = self.date_init_array[component][row];
        [data addObject:data_string];
    }
    [self.button setTitle:[data componentsJoinedByString:@"-"] forState:UIControlStateNormal];
    
    [self returnDataWithDate:[data componentsJoinedByString:@"-"]];
}

- (void)returnDataWithDate:(NSString *)date_string {
    //用来承载查询到的数据
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *date_array = [date_string componentsSeparatedByString:@"-"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    if ([dataBase open]) {
        //拼接查询字符串
        NSString *search_sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where year = '%@' and month = '%@' and day = '%@' order by time asc", date_array[0], date_array[1], date_array[2]];
        FMResultSet *result = [dataBase executeQuery:search_sql_string];
        while ([result next]) {
            NSString *time = [result stringForColumn:@"time"];
            NSString *content = [result stringForColumn:@"content"];
            NSString *color_r = [result stringForColumn:@"color_r"];
            NSString *color_g = [result stringForColumn:@"color_g"];
            NSString *color_b = [result stringForColumn:@"color_b"];
            NSString *indexpath = [result stringForColumn:@"indexpath"];
            NSString *tag_index = [result stringForColumn:@"tag_index"];
            NSString *course_ids = [result stringForColumn:@"course_ids"];
            
            NSDictionary *dic = @{@"time":time,@"content":content,@"color_r":color_r,@"color_g":color_g,@"color_b":color_b,@"indexpath":indexpath,@"tag_index":tag_index,@"course_ids":course_ids};
            [array addObject:dic];
        }
        
        self.data_array = [array copy];
    }
    [dataBase close];
    [self.tableview reloadData];
}

/**
 根据传入时间（HH:mm）往后延续半小时  并返回

 @param customTime 传入时间参数
 @return 返回半小时之后的时间
 */
- (NSString *)afterTimeWithCustomTIme:(NSString *)customTime {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"HH:mm"];
    NSDate *date = [formater dateFromString:customTime];
    NSTimeInterval interval = 30 * 60;
    NSDate *after_time = [NSDate dateWithTimeInterval:interval sinceDate:date];
    NSString *after_string = [formater stringFromDate:after_time];
    return after_string;
}

- (void)sendScheduleAction {
    NSString *finish_string = @"";
    NSMutableArray *android_array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in self.data_array) {
        NSString *after_time = [self afterTimeWithCustomTIme:dic[@"time"]];
        NSString *index_string = [NSString stringWithFormat:@"%@-%@    %@\n", dic[@"time"], after_time, dic[@"content"]];
        finish_string = [finish_string stringByAppendingString:index_string];
        
        //安卓字段
        NSDictionary *android_dic = @{@"blue":@"0",@"id":@"7",@"key":dic[@"time"],@"name":dic[@"content"],@"red":@"0",@"yellow":@"0",};
        [android_array addObject:android_dic];
    }
    
    NSLog(@"finish == %@", finish_string);
    
    if ([finish_string isEqualToString:@""]) {
        [self showHUDWithTitle:@"该日期下没有时间块"];
        return;
    }
    
    //转字符串
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:android_array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"type":@"日程",
                          @"id":@"",
                          @"message":finish_string,
                          @"dataDic":self.data_array,
                          @"message_attr_is_date_content":jsonString,
                          @"message_attr_is_date":@(1)
                          };
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChatViewController class]]) {
            self.chatVC =(ChatViewController *)controller;

            [self.chatVC sendRecommendFriend:dic];

            [self.navigationController popToViewController:self.chatVC animated:YES];
        }
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
