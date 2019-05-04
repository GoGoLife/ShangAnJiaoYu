//
//  AddRemindViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/26.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "AddRemindViewController.h"
#import "ChooseDateView.h"

@interface AddRemindViewController ()<ChooseDateViewDelegate>

@property (nonatomic, strong) UITextField *field;

@property (nonatomic, strong) UILabel *date_label;

/**
 原始的时间数据
 */
@property (nonatomic, strong) NSArray *date_init_array;

@end

@implementation AddRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加提醒事件";
    [self setBack];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = SetFont(14);
    title.text = @"提醒事件名称";
    [self.view addSubview:title];
    __weak typeof(self) weakSelf = self;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    self.field = [[UITextField alloc] init];
    self.field.font = SetFont(14);
    self.field.textColor = DetailTextColor;
    self.field.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(self.field, 8.0);
    
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 20, 0)];
    self.field.leftViewMode = UITextFieldViewModeAlways;
    self.field.leftView = left_label;
    
    [self.view addSubview:self.field];
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.left.equalTo(title.mas_left);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(40.0);
    }];
    
    self.date_label = [[UILabel alloc] init];
    self.date_label.font = SetFont(16);
    self.date_label.textAlignment = NSTextAlignmentCenter;
    ViewBorderRadius(self.date_label, 8.0, 1.0, DetailTextColor);
    [self.view addSubview:self.date_label];
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.field.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.field.mas_left);
        make.right.equalTo(weakSelf.field.mas_right);
        make.height.mas_equalTo(40.0);
    }];
    
    UIButton *choose_date_button = [UIButton buttonWithType:UIButtonTypeCustom];
    choose_date_button.backgroundColor = ButtonColor;
    [choose_date_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [choose_date_button setTitle:@"选择时间" forState:UIControlStateNormal];
    ViewRadius(choose_date_button, 20.0);
    [choose_date_button addTarget:self action:@selector(chooseDateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:choose_date_button];
    [choose_date_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.date_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.date_label.mas_left).offset(20);
        make.right.equalTo(weakSelf.date_label.mas_right).offset(-20);
        make.height.mas_equalTo(40.0);
    }];
}

- (void)chooseDateAction {
    //年
    NSMutableArray *year_array = [NSMutableArray arrayWithCapacity:1];
    NSString *current_year = [KPDateTool currentDateStrWithFormatter:@"yyyy"];
    NSInteger year = [current_year integerValue];
    for (NSInteger index = year - 10; index < year + 10; index++) {
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

#pragma mark ---- chooseDate delegate
- (void)returnSelectFunctionStringAtIndex:(NSArray *)rowData {
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in rowData) {
        NSInteger component = [dic[@"component"] integerValue];
        NSInteger row = [dic[@"row"] integerValue];
        NSString *data_string = self.date_init_array[component][row];
        [data addObject:data_string];
    }
    self.date_label.text = [data componentsJoinedByString:@"-"];
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
