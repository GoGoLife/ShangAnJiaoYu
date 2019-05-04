//
//  TemplateViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/26.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TemplateViewController.h"
#import "TemplateTableViewCell.h"

@interface TemplateViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *dataArray;
}

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"模板";
    [self setBack];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[TemplateTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    dataArray = @[@[
                      @{@"left":@"时间",@"right":@"待办任务"},
                      @{@"left":@"8:00-9:00",@"right":@"人民日报阅读摘记",@"row":@"16"},
                      @{@"left":@"9:00-9:30",@"right":@"行测真题训练",@"row":@"18"},
                      @{@"left":@"10:00-10:30",@"right":@"行测真题训练",@"row":@"20"},
                      @{@"left":@"11:00-11:30",@"right":@"训练精解校队",@"row":@"22"},
                      @{@"left":@"11:30-12:00",@"right":@"疑难题讨论",@"row":@"23"},
                      @{@"left":@"13:30-14:30",@"right":@"小申论听课",@"row":@"27"},
                      @{@"left":@"14:30-16:30",@"right":@"申论真题训练",@"row":@"28"},
                      @{@"left":@"16:30-17:00",@"right":@"申论精解校队",@"row":@"33"},
                      @{@"left":@"18:00-19:00",@"right":@"思维导图整理",@"row":@"36"},
                      @{@"left":@"19:00-20:00",@"right":@"训练",@"row":@"38"},
                      @{@"left":@"20:00-21:30",@"right":@"听课",@"row":@"40"},
                      @{@"left":@"21:30-22:00",@"right":@"今日学习总结",@"row":@"43"}
                      ],@[
                      @{@"left":@"时间",@"right":@"待办任务"},
                      @{@"left":@"8:00-9:00",@"right":@"人民日报阅读摘记",@"row":@"16"},
                      @{@"left":@"9:00-9:30",@"right":@"行测真题训练",@"row":@"18"},
                      @{@"left":@"11:00-11:30",@"right":@"申论精解校队",@"row":@"22"},
                      @{@"left":@"14:00-14:30",@"right":@"申论真题训练",@"row":@"28"},
                      @{@"left":@"14:30-15:00",@"right":@"申论真题训练",@"row":@"29"},
                      @{@"left":@"15:00-15:30",@"right":@"申论真题训练",@"row":@"30"},
                      @{@"left":@"15:30-16:00",@"right":@"申论真题训练",@"row":@"31"},
                      @{@"left":@"16:30-17:00",@"right":@"申论精解校队",@"row":@"33"},
                      @{@"left":@"18:00-18:30",@"right":@"运动",@"row":@"36"},
                      @{@"left":@"19:30-20:00",@"right":@"听课",@"row":@"39"},
                      @{@"left":@"21:00-21:30",@"right":@"今日学习总结",@"row":@"42"}
                      ]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = dataArray[indexPath.section][indexPath.row];
    TemplateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.left_label.text = dic[@"left"];
    cell.right_label.text = dic[@"right"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    
    for (UIView *vv in header_view.subviews) {
        [vv removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @[@"严格安排模式", @"中等强度模式"][section];
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(header_view.mas_bottom).offset(-20);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = section;
    button.titleLabel.font = SetFont(14);  // 95  153  203
    [button setTitleColor:SetColor(95, 153, 203, 1) forState:UIControlStateNormal];
    [button setTitle:@"套用" forState:UIControlStateNormal];
    [header_view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
    }];
    [button addTarget:self action:@selector(touchUseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)touchUseTemplate:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date_string = [formatter stringFromDate:[NSDate date]];
    NSArray *date_array = [date_string componentsSeparatedByString:@"-"];
    
    NSString *section = [NSString stringWithFormat:@"%ld", [self returnSectionWithCurrentDate]];
    
    NSArray *for_data = dataArray[sender.tag];
    
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    //拼接删除数据sql语句
    NSString *delete_sql_string = [NSString stringWithFormat:@"delete from t_scheduleitem where year = '%@' and month = '%@' and day = '%@'", date_array[0], date_array[1], date_array[2]];
    if ([dataBase open]) {
        BOOL success = [dataBase executeUpdate:delete_sql_string];
        if (success) {
            NSLog(@"未绑定事件数据删除成功");
            
            for (int index = 1; index < for_data.count; index++) {
                //时间
                NSArray *time_array = [for_data[index][@"left"] componentsSeparatedByString:@"-"];
                NSLog(@"times == %@", time_array[0]);
                NSLog(@"row == %@", for_data[index][@"row"]);
                NSString *indexPath = [NSString stringWithFormat:@"%@-%@", section, for_data[index][@"row"]];
                NSString *sql_string = @"INSERT INTO t_scheduleitem (year, month, day, time, indexpath, select_type, color_r, color_g, color_b, content, tag_index, course_ids) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);";
                BOOL success = [dataBase executeUpdate:sql_string, date_array[0], date_array[1], date_array[2], time_array[0], indexPath, @"1", @"70", @"156", @"247", for_data[index][@"right"], @"999", @""];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
