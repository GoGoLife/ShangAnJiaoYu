
//
//  CenterView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CenterView.h"
#import "ScheduleCollectionViewCell.h"
#import <Masonry.h>
#import "GlobarFile.h"
#import "DBManager.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "KPDateTool.h"
//我的日程Model
#import "MYScheduleModel.h"
#import "DayModel.h"
#import "DateInDayModel.h"

@interface CenterView()<UICollectionViewDelegate, UICollectionViewDataSource, ScheduleCollectionViewCellDelegate>

@property (nonatomic, strong) NSIndexPath *last_indexPath;

@property (nonatomic, strong) NSArray *selected_array;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray *model_array;


/**
 数据库中存储的开始时间的string值   用于修改绑定事件的时间块数据
 */
@property (nonatomic, strong) NSString *start_time;

/**
 当前年份
 */
@property (nonatomic, strong) NSString *current_year_string;

@end

@implementation CenterView

//整理Model数据   将indexPath  和   item_tag 绑定
- (void)indexPathTargetItemTag:(NSIndexPath *)indexPath {
    MYScheduleModel *model = [[MYScheduleModel alloc] init];
    model.isSelect = NO;
    model.indexPath = indexPath;
    model.item_tag_float = [NSString stringWithFormat:@"%.1f", indexPath.row / 2.0 + indexPath.section * 3];
    model.item_content_string = @"";
    model.item_color = WhiteColor;
    [self.model_array addObject:model];
}

/**
 整理所有数据
 */
- (void)formatterAllData:(NSString *)year_string {
    
    NSLog(@"year  string == %@", year_string);
    self.current_year_string = year_string;
    
    //全部数据
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < [KPDateTool returnMonthInDays].count; index++) {
        //获取当前年的每月天数
        NSInteger days = [[KPDateTool returnMonthInDays][index] integerValue];
        for (NSInteger j = 1; j <= days ; j++) {
            //一天
            DayModel *dayModel = [[DayModel alloc] init];
            //年份
            dayModel.year_string = year_string;
            //月份
            dayModel.month_string = [NSString stringWithFormat:@"%ld", index + 1];
            //日
            dayModel.day_string = [NSString stringWithFormat:@"%ld", j];
            
            NSMutableArray *dateInDayArray = [NSMutableArray arrayWithCapacity:1];
            for (NSInteger hour = 0; hour < 48; hour++) {
                //代表的时间
                DateInDayModel *dateModel = [[DateInDayModel alloc] init];
                dateModel.hour_string = [NSString stringWithFormat:@"%ld", hour / 2];
                dateModel.minutes_string = hour % 2 > 0 ? @"30" : @"00";
                dateModel.color_r = @"255";
                dateModel.color_g = @"255";
                dateModel.color_b = @"255";
                dateModel.isSelect = NO;
                [dateInDayArray addObject:dateModel];
            }
            dayModel.dateIndayData = [dateInDayArray copy];
            //保存每一天的数据
            [dataArr addObject:dayModel];
        }
    }
    self.dataArray = [dataArr copy];
    [self.collectionV reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.model_array = [NSMutableArray arrayWithCapacity:1];
        self.select_times_array = [NSMutableArray arrayWithCapacity:1];
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    CGFloat width = SCREENBOUNDS.width / 4 * 3 / 6 * 4 / 2;
    layout.itemSize = CGSizeMake(width, 30);
    layout.headerReferenceSize = CGSizeMake(SCREENBOUNDS.width, 10);
    
    self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.backgroundColor = [UIColor whiteColor];
    [self.collectionV registerClass:[ScheduleCollectionViewCell class] forCellWithReuseIdentifier:@"center"];
    [self.collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self addSubview:self.collectionV];
    __weak typeof(self) weakSelf = self;
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;//[KPDateTool returnDaysInYear];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24 * 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"center" forIndexPath:indexPath];
    ViewBorderRadius(cell.label, 0, 0.5, LineColor);
    cell.label.font = SetFont(12);
    cell.indexPath = indexPath;
    cell.textAlignment = VerticalAlignmentMiddle;
    cell.label.textAlignment = NSTextAlignmentCenter;
    cell.delegate = self;
    [cell removeBackView];
    
//    DayModel *dayModel = self.dataArray[indexPath.section];
//
//    DateInDayModel *model = dayModel.dateIndayData[indexPath.row];

    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];

    //打开数据库
    if ([dataBase open]) {
        //拼接查询语句
//        NSString *search_sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where year = '%@' and month = '%@' and day = '%@' and time = '%@'", self.current_year_string, dayModel.month_string, dayModel.day_string, model.date_string];
        
        NSString *search_sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where indexpath = '%@'", [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row]];
        
        FMResultSet *result = [dataBase executeQuery:search_sql_string];
        if ([result next]) {
            NSString *content = [result stringForColumn:@"content"];
            NSString *color_r = [result stringForColumn:@"color_r"];
            NSString *color_g = [result stringForColumn:@"color_g"];
            NSString *color_b = [result stringForColumn:@"color_b"];
            cell.label.text = content;
            cell.backgroundColor = SetColor([color_r integerValue], [color_g integerValue], [color_b integerValue], 1);
        }else {
            cell.label.text = @"";
            cell.backgroundColor = WhiteColor;
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    header.backgroundColor = [UIColor grayColor];
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleCollectionViewCell *cell = (ScheduleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    //将选择的indexPath所代表的时间存储起来
    DayModel *dayModel = self.dataArray[indexPath.section];
    DateInDayModel *model = dayModel.dateIndayData[indexPath.row];
    //重新整理数据格式
    NSDictionary *formatterDic = @{
                                   @"year":dayModel.year_string,
                                   @"month":dayModel.month_string,
                                   @"day":dayModel.day_string,
                                   @"date":model.date_string,
                                   @"indexpath":[NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row]
                                   };
    
    if ([self.select_times_array containsObject:formatterDic]) {
        //若包含则删除
        [self.select_times_array removeObject:formatterDic];
        [cell removeBackView];
    }else {
        //若不包含则添加
        [self.select_times_array addObject:formatterDic];
        [cell addBackViewToSelf];
    }
    
//    //首先判断数据库中是否有未绑定事件的数据
//    if ([self searchDBNoTargetAction]) {
//        __weak typeof(self) weakSelf = self;
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除未设置提醒事件的时间块" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //删除数据库中未绑定事件的数据
//            //获取数据库文件
//            FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
//            //拼接删除数据sql语句
//            NSString *delete_sql_string = [NSString stringWithFormat:@"delete from t_scheduleitem where select_type = '%@'", @"0"];
//            if ([dataBase open]) {
//                BOOL success = [dataBase executeUpdate:delete_sql_string];
//                if (success) {
//                    NSLog(@"未绑定事件数据删除成功");
//                    [weakSelf.collectionV reloadData];
//                }else {
//                    NSLog(@"未绑定事件数据删除失败");
//                }
//            }
//            [dataBase close];
//        }];
//        [alert addAction:action];
//        [alert addAction:action1];
//        [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
//        return;
//    }
//
//    if ([self touchIndexDataInDataBase:indexPath]) {
//        __weak typeof(self) weakSelf = self;
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除重新设置" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [weakSelf deleteDateAndBeginSelect:self.start_time];
//        }];
//        [alert addAction:action];
//        [alert addAction:action1];
//        [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
//        return;
//    }
//
//    if (self.last_indexPath) {
//        [self returnSelectedCell:self.last_indexPath AndEndIndexPath:indexPath];
//        self.last_indexPath = nil;
//        return;
//    }else {
//        ScheduleCollectionViewCell *cell = (ScheduleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.backgroundColor = SetColor(230, 230, 230, 1);
//    }
//    self.last_indexPath = indexPath;
}


/**
 判断选择的时间块   是否已经包含在数据库中

 @return yes === 包含   no === 不包含
 */
- (BOOL)touchIndexDataInDataBase:(NSIndexPath *)indexPath {
    BOOL isContainsObject = NO;
    //找到item所在modelArray中的位置
    NSInteger itemIndex = indexPath.row + indexPath.section * 6;
    //通过位置  确定model
    MYScheduleModel *model = self.model_array[itemIndex];
    //根据model  取得item所代表的时间小数
    NSString *item_date_float = model.item_tag_float;
    //根据item代表的时间小数去数据库里查询颜色
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    //拼接SQL语句
    NSString *sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where year = '%@' and month = '%@' and day = '%@' and start_time <= %.2f and end_time >= %.2f", self.current_date_array[0], self.current_date_array[1], self.current_date_array[2], item_date_float.floatValue, item_date_float.floatValue];
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:sql_string];
        if ([result next]) {
            isContainsObject = YES;
            self.start_time = [result stringForColumn:@"start_time"];
        }else {
            isContainsObject = NO;
        }
    }
    [dataBase close];
    return isContainsObject;
}

/**
 清楚之前已经绑定事件但是未完成的时间块   重新选择

 @param start_time 开始时间  用于确定数据
 */
- (void)deleteDateAndBeginSelect:(NSString *)start_time {
    //删除数据库中未绑定事件的数据
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    //拼接删除数据sql语句
    NSString *delete_sql_string = [NSString stringWithFormat:@"delete from t_scheduleitem where year = '%@' and month = '%@' and day = '%@' and start_time = '%@'", self.current_date_array[0], self.current_date_array[1], self.current_date_array[2], start_time];
    if ([dataBase open]) {
        BOOL success = [dataBase executeUpdate:delete_sql_string];
        if (success) {
            NSLog(@"清除成功");
            [self.collectionV reloadData];
            if ([_delegate respondsToSelector:@selector(executeDeleteOperation:)]) {
                [_delegate executeDeleteOperation:self.current_date_array];
            }
        }else {
            NSLog(@"清除失败");
        }
    }
    [dataBase close];
}

/**
 查找数据库中  没有绑定事件的数据
 */
- (BOOL)searchDBNoTargetAction {
    BOOL isHaveNoTargetActionData = NO;
    NSString *path = [[DBManager sharedInstance] creatSqlite];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
    NSString *search_sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where select_type = '%@'", @"0"];
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:search_sql_string];
        if ([result next]) {
            isHaveNoTargetActionData = YES;
        }else {
            isHaveNoTargetActionData = NO;
        }
    }
    [dataBase close];
    return isHaveNoTargetActionData;
}

- (void)returnSelectedCell:(NSIndexPath *)startIndexPath AndEndIndexPath:(NSIndexPath *)endIndexPath {
    //将开始和结束选择的indexPath  传递出去
    if ([_delegate respondsToSelector:@selector(returnStratIndexPath:EndIndexPath:WithIndexAtModelArray:current_date_array:)]) {
        [_delegate returnStratIndexPath:startIndexPath EndIndexPath:endIndexPath WithIndexAtModelArray:self.model_array current_date_array:self.current_date_array];
    }
    
    [self formatDataAndSaveToDB:startIndexPath EndIndexPath:endIndexPath TagString:@"" Color_R:@"230" Color_G:@"230" Color_B:@"230" ModelArray:self.model_array tagIndex:@"" courseIDs:@""];
}

//整理数据并保存到数据库
- (void)formatDataAndSaveToDB:(NSIndexPath *)startIndexPath
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
    
    //将选择的item  整理数据添加到数据库
//    [[DBManager sharedInstance] setDataToDBData_Year:self.current_date_array[0] Data_Month:self.current_date_array[1] Data_Day:self.current_date_array[2] Data_Start_Time:start_time_string Data_End_Time:end_time_string Data_isSelect:@"0" Data_Color_R:color_r Data_Color_G:color_g Data_Color_B:color_b Data_Content:tag_string Data_Tag_Index:index Data_Course_ids:course_ids];
    
    [self.collectionV reloadData];
}

//传值collectionview的偏移量    方便实现同步滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.y / (24 * 30);
    DayModel *model = self.dataArray[index - 1];
    
    NSString *content = [NSString stringWithFormat:@"%@月\n  %@", model.month_string, model.day_string];
    
    self.setContentOffset(scrollView.contentOffset, content);
}

#pragma mark --- scheduleCell delegate
- (void)doubleGestureWithAction:(NSIndexPath *)indexPath {
    //移除选择响应   只响应双击手势
    [self.select_times_array removeAllObjects];
    ScheduleCollectionViewCell *cell = (ScheduleCollectionViewCell *)[self.collectionV cellForItemAtIndexPath:indexPath];
    [cell removeBackView];
    
    //根据indexPath获取数据  并查询数据库
    DayModel *dayModel = self.dataArray[indexPath.section];
    DateInDayModel *model = dayModel.dateIndayData[indexPath.row];
    NSLog(@"year == %@", dayModel.year_string);
    NSLog(@"month == %@", dayModel.month_string);
    NSLog(@"day == %@", dayModel.day_string);
    NSLog(@"time == %@", model.date_string);
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    if ([dataBase open]) {
        NSString *sql_string = [NSString stringWithFormat:@"select * from t_scheduleitem where year = '%@' and month = '%@' and day = '%@' and time = '%@'", dayModel.year_string, dayModel.month_string, dayModel.day_string, model.date_string];
        FMResultSet *result = [dataBase executeQuery:sql_string];
        if ([result next]) {
            //输入修改内容  并更新到数据库
            [self showAlertViewWithTextAndChangeDBWithYear:dayModel.year_string Month:dayModel.month_string Day:dayModel.day_string Time:model.date_string];
        }else {
            [self showHud:@"未绑定事件"];
            return;
        }
    }
    
    //关闭数据库
    [dataBase close];
}

- (void)showAlertViewWithTextAndChangeDBWithYear:(NSString *)year Month:(NSString *)month Day:(NSString *)day Time:(NSString *)time {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入修改内容" preferredStyle:UIAlertControllerStyleAlert];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    //增加确定按钮；
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *userNameTextField = alertController.textFields.firstObject;
        NSLog(@"支付密码 = %@",userNameTextField.text);
        if ([userNameTextField.text isEqualToString:@""]) {
            [weakSelf showHud:@"修改内容不能为空"];
        }else {
            //获取数据库文件
            FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
            if ([dataBase open]) {
                NSString *update_string = [NSString stringWithFormat:@"update t_scheduleitem set content = '%@' where year = '%@' and month = '%@' and day = '%@' and time = '%@'", userNameTextField.text, year, month, day, time];
                BOOL success = [dataBase executeUpdate:update_string];
                if (success) {
                    NSLog(@"修改内容成功！！");
                    [weakSelf.collectionV reloadData];
                }else {
                    NSLog(@"修改内容失败！！");
                }
            }
            
            [dataBase close];
        }
    }]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入修改内容";
//        textField.secureTextEntry = YES;
    }];
    
    [[self getCurrentVC] presentViewController:alertController animated:true completion:nil];
}

- (void)showHud:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = text;
    [hud hide:YES afterDelay:1.0];
    hud = nil;
}

//获取Window当前显示的ViewController
- (UIViewController*)getCurrentVC{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}


@end
