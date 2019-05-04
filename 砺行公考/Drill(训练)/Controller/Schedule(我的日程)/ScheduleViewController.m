//
//  ScheduleViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ScheduleViewController.h"
#import <FSCalendar.h>
#import "LeftView.h"
#import "CenterView.h"
#import "RightView.h"
//听课  跳转页面
#import "My_CourseViewController.h"
//训练  跳转页面
#import "AfterClassWork_MoreViewController.h"
//编辑右侧标签页面
#import "EventCategoryViewController.h"
#import "DBManager.h"
#import "MYScheduleModel.h"
#import "ScheduleRemindViewController.h"
#import "ConclutionViewController.h"
#import "TemplateViewController.h"
#import "ChooseDateView.h"
#import "KPDateTool.h"

@interface ScheduleViewController ()<FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, CenterViewDelegate, RightViewDelegate, ChooseDateViewDelegate>

@property (nonatomic, strong) FSCalendar *fsCalendar;

@property (nonatomic, strong) LeftView *leftView;

@property (nonatomic, strong) CenterView *centerView;

@property (nonatomic, strong) RightView *rightView;

//分享页面
@property (nonatomic, strong) UIView *back_view;

//日历时间选择的数组
@property (nonatomic, strong) NSMutableArray *selected_array;

//Date 格式化样式
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

//中间视图选择的开始indexPath
@property (nonatomic, strong) NSIndexPath *startIndexPath;

//结束indexPath
@property (nonatomic, strong) NSIndexPath *endIndexPath;

//中间视图的model数组
@property (nonatomic, strong) NSArray *center_model_array;

//当前时间字符串
@property (nonatomic, strong) NSString *current_string;

/**
 当前日期数组
 包含年月日
 0 === 年
 1 === 月
 2 === 日
 */
@property (nonatomic, strong) NSArray *current_date_array;

/** 当前中间视图的时间数组 */
@property (nonatomic, strong) NSArray *center_current_date_array;


/** 是否选择了时间块   若选择了 才可以去绑定对应的标签事件 */
@property (nonatomic, assign) BOOL isSelectDate;

/** 最左边的日期显示 */
@property (nonatomic, strong) UILabel *showDateLabel;

/** 选择年份按钮 */
@property (nonatomic, strong) UIButton *year_button;

@property (nonatomic, strong) NSString *year_string;

@property (nonatomic, strong) NSMutableArray *choose_date_array;

/** 判断是不是第一次进入界面 */
@property (nonatomic, assign) BOOL isFirstEnter;

@end

@implementation ScheduleViewController

/**
 初始化日程表数据
 */
- (void)initScheduleData {
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
//    NSString *sql_string = @"select * from t_scheduleitem";
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:@"select * from t_scheduleitem"];
        while ([result next]) {
            NSString *year = [result stringForColumn:@"year"];
            NSString *month = [result stringForColumn:@"month"];
            NSString *day = [result stringForColumn:@"day"];
            NSString *date_string = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
            NSString *formatterString = [self.dateFormatter stringFromDate:[self.dateFormatter dateFromString:date_string]];
            if ([self.selected_array containsObject:formatterString]) {
                //若存在  则不操作
            }else {
                [self.selected_array addObject:formatterString];
            }
        }
        [dataBase close];
        [self.fsCalendar reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isFirstEnter = YES;
    
    //在进入日程界面的时候   调用rightView 获取数据方法    同步数据库中添加的新数据
    [self.rightView getDataFromDBDatabase];
    
    [self.centerView.collectionV reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    //删除数据库中未绑定事件的数据
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    //拼接删除数据sql语句
    NSString *delete_sql_string = [NSString stringWithFormat:@"delete from t_scheduleitem where select_type = '%@'", @"0"];
    if ([dataBase open]) {
        BOOL success = [dataBase executeUpdate:delete_sql_string];
        if (success) {
            NSLog(@"未绑定事件数据删除成功");
        }else {
            NSLog(@"未绑定事件数据删除失败");
        }
    }
    [dataBase close];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的日程";
    
    NSLog(@"总天数 === %ld", [KPDateTool returnDaysInYear]);
    
//    [self setleftOrRight:@"right" BarButtonItemWithImage:[UIImage imageNamed:@"schedule_add"] target:self action:@selector(pushRemindVC)];
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"考研考公倒计时" target:self action:@selector(pushRemindVC)];
    
    self.selected_array = [NSMutableArray arrayWithCapacity:1];
    self.choose_date_array = [NSMutableArray arrayWithCapacity:1];
    [self setBack];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    //判断当前日期下有没有绑定数据
    self.current_string = [self.dateFormatter stringFromDate:[NSDate date]];
    self.current_date_array = [self.current_string componentsSeparatedByString:@"-"];
    
    [self setUI];
    
    //初始化数据
    [self initScheduleData];
}

- (void)setUI {
    __weak typeof(self) weakSelf = self;
    CGFloat width = SCREENBOUNDS.width / 4 * 3 / 6;
    self.showDateLabel = [[UILabel alloc] init];
    self.showDateLabel.font = SetFont(16);
    self.showDateLabel.textAlignment = NSTextAlignmentCenter;
    self.showDateLabel.numberOfLines = 0;
    self.showDateLabel.text = @"1月\n 1";
    [self.view addSubview:self.showDateLabel];
    [self.showDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(5);
        make.left.equalTo(weakSelf.view.mas_left);
        make.width.mas_equalTo(width);
    }];
    
    self.leftView = [[LeftView alloc] init];
    self.leftView.setContentOffset = ^(CGPoint offset) {
        weakSelf.centerView.collectionV.contentOffset = offset;
    };
    [self.view addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(5);
        make.left.equalTo(weakSelf.showDateLabel.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(width);
    }];
    
    self.centerView = [[CenterView alloc] init];
    self.centerView.delegate = self;
    self.centerView.current_date_array = self.current_date_array;
    self.centerView.setContentOffset = ^(CGPoint offset, NSString *month) {
        weakSelf.leftView.collectionV.contentOffset = offset;
        weakSelf.showDateLabel.text = month;
        weakSelf.isFirstEnter = NO;
    };
    [self.view addSubview:self.centerView];
    CGFloat centerWith = SCREENBOUNDS.width / 4 * 3 / 6 * 4;
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftView.mas_top);
        make.left.equalTo(weakSelf.leftView.mas_right);
        make.bottom.equalTo(weakSelf.leftView.mas_bottom);
        make.width.mas_equalTo(centerWith);
    }];
    //整理所有数据
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *current_year = [formatter stringFromDate:[NSDate date]];
    [self.centerView formatterAllData:current_year];
    
    self.rightView = [[RightView alloc] init];
    self.rightView.delegate = self;
    [self.view addSubview:self.rightView];
    CGFloat rightWidth = SCREENBOUNDS.width / 4;
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftView.mas_top).offset(60.0);
        make.left.equalTo(weakSelf.centerView.mas_right);
        make.bottom.equalTo(weakSelf.leftView.mas_bottom);
        make.width.mas_equalTo(rightWidth);
    }];
    
    self.year_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.year_button.titleLabel.font = SetFont(14);
    [self.year_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.year_button setTitle:[current_year stringByAppendingString:@"年"] forState:UIControlStateNormal];
    ViewBorderRadius(self.year_button, 8.0, 1.0, SetColor(233, 233, 233, 1));
    [self.view addSubview:self.year_button];
    [self.year_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftView.mas_top).offset(10);
        make.left.equalTo(weakSelf.centerView.mas_right).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    //选择年份
    [self.year_button addTarget:self action:@selector(chooseYearAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)chooseYearAction {
    [self.choose_date_array removeAllObjects];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *current_year = [formatter stringFromDate:[NSDate date]];
    NSInteger year_index = [current_year integerValue];
    for (NSInteger index = year_index - 3; index <= year_index; index++) {
        [self.choose_date_array addObject:[NSString stringWithFormat:@"%ld", index]];
    }
    
    ChooseDateView *chooseDate = [[ChooseDateView alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 64 - 300, SCREENBOUNDS.width, 300.0)];
    chooseDate.delegate = self;
    chooseDate.dataArray = @[self.choose_date_array];
    [self.view addSubview:chooseDate];
}

/**
 选择年份

 @param rowData 返回的是一个字典  包含component   index  需要自己取数据
 */
- (void)returnSelectFunctionStringAtIndex:(NSArray *)rowData {
    NSLog(@"year === %@", rowData);
    NSInteger index = [rowData[0][@"row"] integerValue];
    NSString *year_string = [NSString stringWithFormat:@"%@年", self.choose_date_array[index]];
    [self.year_button setTitle:year_string forState:UIControlStateNormal];
    [self.centerView formatterAllData:self.choose_date_array[index]];
}

/** 刷新 */
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.isFirstEnter) {
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
        
        [self.centerView.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sum + day] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];

    }else {
        NSLog(@"自然滑动");
    }
    
}

//点击按钮展开日程
- (void)unflodSchedule:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.fsCalendar setScope:FSCalendarScopeMonth animated:YES];
    }else {
        [self.fsCalendar setScope:FSCalendarScopeWeek animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- search data from dataDB

/**
 查询数据库中当前日期下是否包含的有数据

 @param year 年
 @param month 月
 @param day 日
 @return yes === 有  no === 没有
 */
- (BOOL)currentDateContrainDataWithYear:(NSString *)year Month:(NSString *)month Day:(NSString *)day {
    BOOL isHave = NO;
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    NSString *sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where year = '%@' and month = '%@' and day = '%@'", year, month, day];
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:sql_string];
        if ([result next]) {
            isHave = YES;
        }else {
            isHave = NO;
        }
    }else {
        NSLog(@"打开数据库失败");
        isHave = NO;
    }
    [dataBase close];
    return isHave;
}

#pragma mark ----- CenterView delegate
- (void)returnStratIndexPath:(NSIndexPath *)startIndexPath EndIndexPath:(NSIndexPath *)endIndexPath WithIndexAtModelArray:(NSArray *)modelArray current_date_array:(NSArray *)array {
    self.startIndexPath = startIndexPath;
    self.endIndexPath = endIndexPath;
    self.center_model_array = modelArray;
    self.center_current_date_array = array;
    self.isSelectDate = YES;
}

#pragma mark ---- RightView delegate
- (void)touchRightViewCellAction:(NSIndexPath *)indexPath
                       DataCount:(NSInteger)count
                      TagContent:(NSString *)tag_string
                         Color_R:(NSString *)color_r
                         Color_G:(NSString *)color_g
                         Color_B:(NSString *)color_b {
    
    NSLog(@"选择的times === %@", self.centerView.select_times_array);
    
    if (indexPath.row == count - 5) {
        //编辑标签
        EventCategoryViewController *event = [[EventCategoryViewController alloc] init];
        [self.navigationController pushViewController:event animated:YES];
        
    }else if (indexPath.row == count - 4) {
        //总结
        ConclutionViewController *conclution = [[ConclutionViewController alloc] init];
        [self.navigationController pushViewController:conclution animated:YES];
        
    }else if (indexPath.row == count - 3) {
        //模板
        TemplateViewController *template = [[TemplateViewController alloc] init];
        [self.navigationController pushViewController:template animated:YES];
        
    }else if (indexPath.row == count - 2) {
        //分享
        [self moreAction];
        
    }else if (indexPath.row == count - 1) {
        //删除
        
        [self deleteDataInDBWithArray:self.centerView.select_times_array];
        
    }else {
        
        if (indexPath.row == 0) {
            My_CourseViewController *my_course = [[My_CourseViewController alloc] init];
            my_course.isSelectCourse = YES;
            [self.navigationController pushViewController:my_course animated:YES];
        }else if (indexPath.row == 1) {
            AfterClassWork_MoreViewController *afterClass = [[AfterClassWork_MoreViewController alloc] init];
            afterClass.isSelectCourse = YES;
            [self.navigationController pushViewController:afterClass animated:YES];
        }
        //自定义其它标签
        //查询选择的数据   数据库中是否存在
        BOOL isHave = [self searchDataInDB:self.centerView.select_times_array];
        NSLog(@"isHave === %d", isHave);
        __weak typeof(self) weakSelf = self;
        if (isHave) {
            //表示存在
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否覆盖事件" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"覆盖" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //确认覆盖
                [weakSelf AddToDBWithRepetitionData:self.centerView.select_times_array TagIndex:[NSString stringWithFormat:@"%ld", indexPath.row] TagString:tag_string Color_R:color_r Color_G:color_g Color_B:color_b];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else {
            //表示不存在重复数据   直接添加
            [self AddDataToDB:self.centerView.select_times_array TagIndex:[NSString stringWithFormat:@"%ld", indexPath.row] TagString:tag_string Color_R:color_r Color_G:color_g Color_B:color_b];
        }
    }
}

/**
 添加选择的时间块到数据库

 @param array 选择的时间块
 */
- (void)AddDataToDB:(NSArray *)array TagIndex:(NSString *)row TagString:(NSString *)content Color_R:(NSString *)color_r Color_G:(NSString *)color_g Color_B:(NSString *)color_b {
    //将选择的时间块数据  循环添加到数据库中
    NSInteger index = 0;
    for (NSDictionary *dic in array) {
        [[DBManager sharedInstance] setDataToDBData_Year:dic[@"year"] Data_Month:dic[@"month"] Data_Day:dic[@"day"] Data_time:dic[@"date"] Data_indexPath:dic[@"indexpath"] Data_isSelect:@"1" Data_Color_R:color_r Data_Color_G:color_g Data_Color_B:color_b Data_Content:content Data_Tag_Index:row Data_Course_ids:@"1-2-3"];
        if (index == self.centerView.select_times_array.count - 1) {
            [self.centerView.select_times_array removeAllObjects];
            [self.centerView.collectionV reloadData];
        }
        index++;
    }
}

/**
 处理存在重复数据的逻辑

 @param array 选择的时间块
 */
- (void)AddToDBWithRepetitionData:(NSArray *)array TagIndex:(NSString *)row TagString:(NSString *)content Color_R:(NSString *)color_r Color_G:(NSString *)color_g Color_B:(NSString *)color_b {
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    if ([dataBase open]) {
        for (NSDictionary *dic in array) {
            //查询
            NSString *search_sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where year = '%@' and month = '%@' and day = '%@' and time = '%@'", dic[@"year"], dic[@"month"], dic[@"day"], dic[@"date"]];
            FMResultSet *result = [dataBase executeQuery:search_sql_string];
            if ([result next]) {
                //数据库中存在
                NSString *update_sql_string = [NSString stringWithFormat:@"update t_scheduleitem set content = '%@', color_r = '%@', color_g = '%@', color_b = '%@', tag_index = '%@' where year = '%@' and month = '%@' and day = '%@' and time = '%@';", content, color_r, color_g, color_b, row, dic[@"year"], dic[@"month"], dic[@"day"], dic[@"date"]];
                BOOL success = [dataBase executeUpdate:update_sql_string];
                if (success) {
                    NSLog(@"更新成功！！！");
                }else {
                    NSLog(@"更新失败！！！");
                }
                
            }else {
                //数据库中不存在  直接添加
                NSString *sql_string = @"INSERT INTO t_scheduleitem (year, month, day, time, indexpath, select_type, color_r, color_g, color_b, content, tag_index, course_ids) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);";
                BOOL success = [dataBase executeUpdate:sql_string,  dic[@"year"], dic[@"month"], dic[@"day"], dic[@"date"], dic[@"indexpath"], @"1", color_r, color_g, color_b, content, row, @"1-2-3"];
                if (success) {
                    NSLog(@"添加数据到日程表成功");
                }else {
                    NSLog(@"添加数据到日程表失败");
                }
            }
        }
    }
    [dataBase close];
    
    [self.centerView.collectionV reloadData];
}

/**
 查询选择的时间块   是否已经绑定的有事件

 @param dicArray 选择的时间块
 @return 返回是否存在
 */
- (BOOL)searchDataInDB:(NSArray *)dicArray {
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    if ([dataBase open]) {
        for (NSDictionary *dic in dicArray) {
            NSString *search_sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where year = '%@' and month = '%@' and day = '%@' and time = '%@'", dic[@"year"], dic[@"month"], dic[@"day"], dic[@"date"]];
            FMResultSet *result = [dataBase executeQuery:search_sql_string];
            while ([result next]) {
                return YES;
            }
        }
    }
    [dataBase close];
    
    return NO;
}

//更新数据库数据   并绑定响应的事件
- (void)updateDBDatabaseStratIndex:(NSIndexPath *)startIndexPath
                      EndIndexPath:(NSIndexPath *)endIndexPath
                         TagString:(NSString *)tag_string
                           Color_R:(NSString *)color_r
                           Color_G:(NSString *)color_g
                           Color_B:(NSString *)color_b
                        ModelArray:(NSArray *)modelArray
                          tagIndex:(NSString *)index
                         courseIDs:(NSString *)course_ids {
    //根据开始和结束的indexPath   确定在model_array中的位置   并  取到具体代表时间的值
    NSInteger start_index = startIndexPath.row + startIndexPath.section * 6;
    NSInteger end_index = endIndexPath.row + endIndexPath.section * 6;
    NSString *start_time_string = ((MYScheduleModel *)modelArray[start_index]).item_tag_float;
    NSString *end_time_string = ((MYScheduleModel *)modelArray[end_index]).item_tag_float;
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    NSString *sql_string = [NSString stringWithFormat:@"update t_scheduleitem set year='%@', month='%@', day='%@', select_type='%@', color_r='%@', color_g='%@', color_b='%@', content='%@', tag_index='%@', course_ids='%@' where start_time='%@' and end_time='%@';", self.center_current_date_array[0], self.center_current_date_array[1], self.center_current_date_array[2], @"1", color_r, color_g, color_b, tag_string, index, course_ids, start_time_string, end_time_string];
    if ([dataBase open]) {
        BOOL success = [dataBase executeUpdate:sql_string];
        if (success) {
            NSLog(@"更新数据成功");
        }else {
            NSLog(@"更新数据失败");
        }
    }
    //关闭数据库
    [dataBase close];
    [self.centerView.collectionV reloadData];
}

/**
 执行了删除某个日期下的绑定的数据块操作
 @param current_date_array 某个日期
 */
- (void)executeDeleteOperation:(NSArray *)current_date_array {
    //查询当前日期下是否还有绑定了数据的时间块
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    NSString *sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where year = '%@' and month = '%@' and day = '%@'", current_date_array[0], current_date_array[1], current_date_array[2]];
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:sql_string];
        if ([result next]) {
            //表明当前日期下还存在数据
        }else {
            //表明当前提起下不存在数据了
            NSString *current = [current_date_array componentsJoinedByString:@"-"];
            [self.selected_array removeObject:current];
            [self.fsCalendar reloadData];
        }
    }
}

/**
 删除绑定事件的时间块

 @param array 选择的数组
 */
- (void)deleteDataInDBWithArray:(NSArray *)array {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.centerView.select_times_array removeAllObjects];
        [weakSelf.centerView.collectionV reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
        if ([dataBase open]) {
            for (NSDictionary *dic in array) {
                NSString *delete_sql_string = [NSString stringWithFormat:@"delete from t_scheduleitem where indexpath = '%@'", dic[@"indexpath"]];
                BOOL success = [dataBase executeUpdate:delete_sql_string];
                if (success) {
                    NSLog(@"删除成功!!!!");
                }else {
                    NSLog(@"删除失败!!!!");
                }
            }
        }
        [dataBase close];
        [weakSelf.centerView.select_times_array removeAllObjects];
        [weakSelf.centerView.collectionV reloadData];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ---- custom action
//分享
- (void)moreAction {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.back_view = [[UIView alloc] initWithFrame:app.window.bounds];
    self.back_view.backgroundColor = WhiteColor;
    [app.window addSubview:self.back_view];
    [self setBack_view_content:self.back_view];
}

- (void)setBack_view_content:(UIView *)back_view {
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(removeViewAction) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-30);
        make.top.equalTo(back_view.mas_top).offset(130);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIButton *push_group_chat = [UIButton buttonWithType:UIButtonTypeCustom];
    push_group_chat.titleLabel.font = SetFont(12);
    [push_group_chat setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
    [push_group_chat setImage:[UIImage imageNamed:@"KQ"] forState:UIControlStateNormal];
    [push_group_chat setTitle:@"" forState:UIControlStateNormal];
    [self initButton:push_group_chat];
    [push_group_chat addTarget:self action:@selector(shareToKQ) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:push_group_chat];
    CGFloat width = SCREENBOUNDS.width / 2;
    [push_group_chat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cancel.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(width, 90));
    }];
    
    UIButton *add_friend = [UIButton buttonWithType:UIButtonTypeCustom];
    add_friend.titleLabel.font = SetFont(12);
    [add_friend setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
    [add_friend setImage:[UIImage imageNamed:@"KB"] forState:UIControlStateNormal];
    [add_friend setTitle:@"" forState:UIControlStateNormal];
    [self initButton:add_friend];
    [add_friend addTarget:self action:@selector(shareToKB) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:add_friend];
    [add_friend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cancel.mas_bottom).offset(20);
        make.left.equalTo(push_group_chat.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(width, 90));
    }];
    add_friend.hidden = YES;
}

//删除视图
- (void)removeViewAction {
    [self.back_view removeFromSuperview];
}

//分享到考圈
- (void)shareToKQ {
    NSMutableArray *share_array = [NSMutableArray arrayWithCapacity:1];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    if ([dataBase open]) {
        NSString *search_sql = [NSString stringWithFormat:@"select * from t_scheduleitem where year = '%@' and month = '%@' and day = '%@'", [KPDateTool returnCurrentYear], [KPDateTool returnCurrentMonth], [KPDateTool returnCurrentDay]];
        FMResultSet *result = [dataBase executeQuery:search_sql];
        while ([result next]) {
            NSString *time = [result stringForColumn:@"time"];
            NSString *indexpath = [result stringForColumn:@"indexpath"];
            NSString *content = [result stringForColumn:@"content"];
            NSDictionary *dic = @{@"time":time,@"indexpath":indexpath,@"content":content};
            [share_array addObject:dic];
        }
        
        if (share_array.count > 0) {
            //表示有数据 可以分享
            NSString *finish = @"";
            for (NSDictionary *dic in share_array) {
                finish = [finish stringByAppendingString:[NSString stringWithFormat:@"%@    %@\n", dic[@"time"], dic[@"content"]]];
            }
            [self shareSchduleDataToService:finish];
        }else {
            //没有数据  不分享
            [self.back_view removeFromSuperview];
            [self showHUDWithTitle:@"无日程数据"];
        }
    }
}

//分享到考伴
- (void)shareToKB {
    [self showHUDWithTitle:@"敬请期待"];
}

- (void)shareSchduleDataToService:(NSString *)content {
    NSDictionary *param = @{@"content_":content};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_moment" Dic:param imageArray:@[] SuccessBlock:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf.back_view removeFromSuperview];
        }
    } FailureBlock:^(id error) {
        NSLog(@"error === %@", error);
    }];
}

//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    float  spacing = 15;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height) - 5, 0.0, 0.0 - 5, - titleSize.width - 5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(50, - 20 * 5 + 8, - (totalHeight - titleSize.height), 0);
}

/** 跳转到提醒列表 */
- (void)pushRemindVC {
    ScheduleRemindViewController *remind = [[ScheduleRemindViewController alloc] init];
    [self.navigationController pushViewController:remind animated:YES];
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
