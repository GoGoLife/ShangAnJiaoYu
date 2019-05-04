//
//  LineChartsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/27.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "LineChartsViewController.h"
#import "PXLineChartView.h"
#import "PointItem.h"
#import "ChooseDateView.h"

@interface LineChartsViewController ()<PXLineChartViewDelegate, ChooseDateViewDelegate>
{
    NSArray *month_array;
}

@property (nonatomic, strong) PXLineChartView *lineChartsView;
@property (nonatomic, strong) NSArray *lines;//line count
@property (nonatomic, strong) NSArray *xElements;//x轴数据
@property (nonatomic, strong) NSArray *yElements;//y轴数据

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSMutableArray *choose_date_array;

@end

@implementation LineChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"总结";
    [self setBack];
    //存储的年份
    self.choose_date_array = [NSMutableArray arrayWithCapacity:1];
    //月份
    month_array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    //当前时间字符串
    NSString *current_date_string = [KPDateTool currentDateStrWithFormatter:@"yyyy-MM"];
    NSArray *date_array = [current_date_string componentsSeparatedByString:@"-"];
    NSString *button_title = [NSString stringWithFormat:@"%@年%@月", date_array[0], date_array[1]];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = FRAME(SCREENBOUNDS.width - 140, 10, 120, 30.0);
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button setTitle:button_title forState:UIControlStateNormal];
    ViewBorderRadius(self.button, 5.0, 1.0, DetailTextColor);
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.lineChartsView = [[PXLineChartView alloc] initWithFrame:FRAME(0, 50, SCREENBOUNDS.width, 360.0)];
    self.lineChartsView.delegate = self;
    
    NSMutableArray *x = [NSMutableArray arrayWithCapacity:1];
    NSInteger current_month = [[KPDateTool returnCurrentMonth] integerValue];
    //根据月份 获取某个月的天数
    NSInteger days = [[KPDateTool returnMonthInDays][current_month - 1] integerValue];
    for (NSInteger index = 1; index <= days; index++) {
        [x addObject:[NSString stringWithFormat:@"%ld", index]];
    }
    _xElements = [x copy];
    _yElements = @[@"0",@"3",@"6",@"9",@"12",@"15", @"18", @"21", @"24"];
    
    self.lines = [self lines:NO Year:date_array[0] Month:date_array[1]];
    
    [self.view addSubview:self.lineChartsView];
}

- (NSArray *)lines:(BOOL)fill Year:(NSString *)year Month:(NSString *)month {
    
    NSArray *pointsArr = [self formatterLinesDataWithYear:year Month:month];
    
    NSMutableArray *points = @[].mutableCopy;
    for (int i = 0; i < pointsArr.count; i++) {
        PointItem *item = [[PointItem alloc] init];
        NSDictionary *itemDic = pointsArr[i];
        item.price = itemDic[@"yValue"];
        item.time = itemDic[@"xValue"];
        item.chartLineColor = [UIColor redColor];
        item.chartPointColor = [UIColor redColor];
        item.pointValueColor = [UIColor redColor];
        if (fill) {
            item.chartFillColor = [UIColor colorWithRed:0 green:0.5 blue:0.2 alpha:0.5];
            item.chartFill = YES;
        }
        [points addObject:item];
    }
    //两条line
    return @[points];
}

#pragma mark PXLineChartViewDelegate
//通用设置
- (NSDictionary<NSString*, id> *)lineChartViewAxisAttributes {
    return @{yElementInterval : @"40",
             xElementInterval : @"40",
             yMargin : @"50",
             xMargin : @"25",
             yAxisColor : [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1],
             xAxisColor : [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1],
             gridColor : [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1],
             gridHide : @0,
             pointHide : @0,
             pointFont : [UIFont systemFontOfSize:10],
             firstYAsOrigin : @1,
             scrollAnimation : @1,
             scrollAnimationDuration : @"2"};
}
//line count
- (NSUInteger)numberOfChartlines {
    return self.lines.count;
}
//x轴y轴对应的元素count
- (NSUInteger)numberOfElementsCountWithAxisType:(AxisType)axisType {
    return (axisType == AxisTypeY)? _yElements.count : _xElements.count;
}
//x轴y轴对应的元素view
- (UILabel *)elementWithAxisType:(AxisType)axisType index:(NSUInteger)index {
    UILabel *label = [[UILabel alloc] init];
    NSString *axisValue = @"";
    if (axisType == AxisTypeX) {
        axisValue = _xElements[index];
        label.textAlignment = NSTextAlignmentCenter;//;
    }else if(axisType == AxisTypeY){
        axisValue = _yElements[index];
        label.textAlignment = NSTextAlignmentRight;//;
    }
    label.text = axisValue;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    return label;
}
//每条line对应的point数组
- (NSArray<id<PointItemProtocol>> *)plotsOflineIndex:(NSUInteger)lineIndex {
    return self.lines[lineIndex];
}
//点击point回调响应
- (void)elementDidClickedWithPointSuperIndex:(NSUInteger)superidnex pointSubIndex:(NSUInteger)subindex {
    PointItem *item = self.lines[superidnex][subindex];
    NSString *xTitle = item.time;
    NSString *yTitle = item.price;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:yTitle
                                                                       message:[NSString stringWithFormat:@"x：%@ \ny：%@",xTitle,yTitle] preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

/** 从数据库中整理数据 */
- (NSArray *)formatterLinesDataWithYear:(NSString *)year Month:(NSString *)month {
//    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    NSMutableArray *data_array = [NSMutableArray arrayWithCapacity:1];
    NSInteger month_index = [month integerValue];
    //获取选择月份的天数
    NSString *daysInMonth = [KPDateTool returnMonthInDays][month_index - 1];
    for (NSInteger index = 1; index <= [daysInMonth integerValue]; index++) {
        //循环一次就是一天
        //听课的时间
        NSInteger course_times = [self searchDataCountWithYear:year Month:month Day:[NSString stringWithFormat:@"%ld", index] Content:@"听课"];
        //训练的时间
        NSInteger train_times = [self searchDataCountWithYear:year Month:month Day:[NSString stringWithFormat:@"%ld", index] Content:@"训练"];
        CGFloat hours = (course_times + train_times) / 2.0;
        NSDictionary *dic = @{@"xValue":[NSString stringWithFormat:@"%ld", index],@"yValue":[NSString stringWithFormat:@"%.1f", hours]};
        [data_array addObject:dic];
    }
    return [data_array copy];
}


/**
 根据年月日查询某类事件的数据条数

 @param year 年
 @param month 月
 @param day 日
 @param content 事件名称
 */
- (int)searchDataCountWithYear:(NSString *)year Month:(NSString *)month Day:(NSString *)day Content:(NSString *)content {
    int count = 0;
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    if ([dataBase open]) {
        NSString *sql_string = [NSString stringWithFormat:@"select count(*) from t_scheduleitem where year = '%@' and month = '%@' and day = '%@' and content = '%@'", year, month, day, content];
        FMResultSet *result = [dataBase executeQuery:sql_string];
        if ([result next]) {
            count += [result intForColumnIndex:0];
        }
    }
    [dataBase close];
    return count;
}

/**
 改变日期   并刷新数据
 */
- (void)changeDate {
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
    chooseDate.dataArray = @[self.choose_date_array, month_array];
    [self.view addSubview:chooseDate];
}

- (void)returnSelectFunctionStringAtIndex:(NSArray *)rowData {
    NSString *year = self.choose_date_array[[rowData[0][@"row"] integerValue]];
    NSString *month = month_array[[rowData[1][@"row"] integerValue]];
    NSString *button_title = [NSString stringWithFormat:@"%@年%@月", year, month];
    [self.button setTitle:button_title forState:UIControlStateNormal];
    self.lines = [self lines:NO Year:year Month:month];
    [self.lineChartsView reloadData];
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
