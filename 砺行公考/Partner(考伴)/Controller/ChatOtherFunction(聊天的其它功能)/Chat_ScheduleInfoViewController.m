//
//  Chat_ScheduleInfoViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "Chat_ScheduleInfoViewController.h"
#import "Send_SchduleTableViewCell.h"

@interface Chat_ScheduleInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation Chat_ScheduleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"日程表";
    [self setBack];
//    //整理数据
//    NSString *formatter_string = [self.schedule_string substringToIndex:[self.schedule_string length] - 1];
//    self.dataArray = [formatter_string componentsSeparatedByString:@"\n"];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"套用" target:self action:@selector(ScheduleAction)];
    
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[Send_SchduleTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schedule_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.schedule_array[indexPath.row];
    Send_SchduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.left_label.text = [NSString stringWithFormat:@"%@-%@", data[@"time"], [self afterTimeWithCustomTIme:data[@"time"]]];
    cell.right_label.text = data[@"content"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
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

/** 套用 */
- (void)ScheduleAction {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date_string = [formatter stringFromDate:[NSDate date]];
    NSArray *date_array = [date_string componentsSeparatedByString:@"-"];
    
    NSString *section = [NSString stringWithFormat:@"%ld", [self returnSectionWithCurrentDate]];
    
    NSArray *for_data = self.schedule_array;
    
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    //拼接删除数据sql语句
    NSString *delete_sql_string = [NSString stringWithFormat:@"delete from t_scheduleitem where year = '%@' and month = '%@' and day = '%@'", date_array[0], date_array[1], date_array[2]];
    if ([dataBase open]) {
        BOOL success = [dataBase executeUpdate:delete_sql_string];
        if (success) {
            NSLog(@"未绑定事件数据删除成功");
            
            for (int index = 0; index < for_data.count; index++) {
                //时间
                NSArray *sectionAndRow = [for_data[index][@"indexpath"] componentsSeparatedByString:@"-"];
                
                NSString *indexPath = [NSString stringWithFormat:@"%@-%@", section, sectionAndRow[1]];
                NSString *sql_string = @"INSERT INTO t_scheduleitem (year, month, day, time, indexpath, select_type, color_r, color_g, color_b, content, tag_index, course_ids) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);";
                BOOL success = [dataBase executeUpdate:sql_string, date_array[0], date_array[1], date_array[2], for_data[index][@"time"], indexPath, @"1", @"70", @"156", @"247", for_data[index][@"content"], @"999", @""];
                if (success) {
                    NSLog(@"添加数据到日程表成功");
                }else {
                    NSLog(@"添加数据到日程表失败");
                }
            }
            
            [self showHUDWithTitle:@"套用完成"];
            
        }else {
            NSLog(@"未绑定事件数据删除失败");
        }
    }
    [dataBase close];
}

//根据当前时间获取Section
- (NSInteger)returnSectionWithCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    //只有月份和日期
    NSString *date_string = [formatter stringFromDate:[NSDate date]];
    //字符串转数组
    NSArray *date_array = [date_string componentsSeparatedByString:@"-"];
    
    //根据当前月份 获取到section的位置
    NSInteger month = [date_array[0] integerValue];
    NSInteger sum = 0;
    for (NSInteger index = 0; index < month - 1; index++) {
        sum += [[KPDateTool returnMonthInDays][index] integerValue];
    }
    NSInteger day = [date_array[1] integerValue] - 1;
    return sum + day;
}

/**
 根据当前时间   确定在collectionview中的indexPath

 @param time 时间
 @return 返回  section-row  格式的字符串
 */
- (NSString *)getIndexPathWithDate:(NSString *)time {
    //当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    //只有月份和日期
    NSString *date_string = [formatter stringFromDate:[NSDate date]];
    //字符串转数组
    NSArray *date_array = [date_string componentsSeparatedByString:@"-"];
    
    //根据当前月份 获取到section的位置
    NSInteger month = [date_array[0] integerValue];
    NSInteger sum = 0;
    for (NSInteger index = 0; index < month - 1; index++) {
        sum += [[KPDateTool returnMonthInDays][index] integerValue];
    }
    NSInteger day = [date_array[1] integerValue] - 1;
    NSInteger section = sum + day;
    
    //将时间拆分
    NSArray *time_array = [time componentsSeparatedByString:@":"];
    NSInteger row = [time_array[0] integerValue] * 2;
    if ([time_array[1] isEqualToString:@"30"]) {
        row = row + 1;
    }
    
    return [NSString stringWithFormat:@"%ld-%ld", section, row];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
