//
//  DBManager.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/29.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DBManager.h"


@interface DBManager()

@end

@implementation DBManager

+ (DBManager *)sharedInstance {
    static DBManager *dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[DBManager alloc] init];
    });
    return dbManager;
}

//数据库   懒加载
- (NSString *)creatSqlite {
    //创建数据库路径   砺行数据库
    NSString *path = CREATE_FILE_DOCUMENT(@"lixing.sqlite");
    //返回数据库
    return path;
}

//- (FMDatabase *)dataBase {
//    _dataBase = [[DBManager sharedInstance] creatSqlite];
//    return _dataBase;
//}

- (void)creatTable {
    //获取数据库
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self creatSqlite]];
    //打开数据库
    if ([dataBase open]) {
        //打开成功   创建表 ----- 日程表 （首页）
        BOOL success = [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_scheduleitem"
                                                    "(id integer PRIMARY KEY AUTOINCREMENT,"
                                                    "year string NOT NULL DEFAULT '',"
                                                    "month string NOT NULL DEFAULT '',"
                                                    "day string NOT NULL DEFAULT '',"
                                                    "time string NOT NULL,"
                                                    "indexpath string NOT NULL,"
                                                    "select_type string NOT NULL DEFAULT '0',"
                                                    "color_r string NOT NULL,"
                                                    "color_g string NOT NULL,"
                                                    "color_b string NOT NULL,"
                                                    "content string NOT NULL DEFAULT '',"
                                                    "tag_index string NOT NULL,"
                                                    "course_ids string NOT NULL DEFAULT '');"];
        if (success) {
            NSLog(@"日程表创建成功");
        }else {
            NSLog(@"日程表创建失败");
        }
    }
    
    //创建表 ----- 日程标签表
    if ([dataBase open]) {
        NSString *sql_string = @"create table if not exists t_scheduletag (id integer primary key autoincrement,"
                                                                            "color_r string not null,"
                                                                            "color_g string not null,"
                                                                            "color_b string not null,"
                                                                            "is_using integer default 0,"
                                                                            "content string not null)";
        BOOL success = [dataBase executeUpdate:sql_string];
        if (success) {
            NSLog(@"创建标签表成功");
        }else {
            NSLog(@"创建标签表失败");
        }
    }
    
    //创建表  ----- 快捷入口的表
    if ([dataBase open]) {
        NSString *creat_sql_string = @"create table if not exists t_shortcut (id integer primary key autoincrement,"
                                                                                    "imageNamed string default '',"
                                                                                    "imageUrl string default '',"
                                                                                    "title string not null,"
                                                                                    "isShow string default '0',"
                                                                                    "categoryModel string not null,"
                                                                                    "targetVCNamed string not null,"
                                                                                    "targetData string)";
        BOOL success = [dataBase executeUpdate:creat_sql_string];
        if (success) {
            NSLog(@"快捷入口表创建成功");
        }else {
            NSLog(@"快捷入口表创建失败");
        }
    }
    [dataBase close];
}

/**
 添加数据    日程表

 @param year 年
 @param month 月
 @param day 日
 @param time 事件包含的时间
 @param indexpath 在collectionview中的体现
 @param select_type 是否选择
 @param color_r 颜色R
 @param color_g 颜色G
 @param color_b 颜色B
 @param content 我的日程显示的标签内容
 @param tag_index 绑定的标签index
 @param course_ids 绑定的课程数组
 */
- (void)setDataToDBData_Year:(NSString *)year
                  Data_Month:(NSString *)month
                    Data_Day:(NSString *)day
                   Data_time:(NSString *)time
              Data_indexPath:(NSString *)indexpath
               Data_isSelect:(NSString *)select_type
                Data_Color_R:(NSString *)color_r
                Data_Color_G:(NSString *)color_g
                Data_Color_B:(NSString *)color_b
                Data_Content:(NSString *)content
              Data_Tag_Index:(NSString *)tag_index
             Data_Course_ids:(NSString *)course_ids {
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self creatSqlite]];
    if ([dataBase open]) {
        NSString *sql_string = @"INSERT INTO t_scheduleitem (year, month, day, time, indexpath, select_type, color_r, color_g, color_b, content, tag_index, course_ids) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);";
        BOOL success = [dataBase executeUpdate:sql_string,  year, month, day, time, indexpath, select_type, color_r, color_g, color_b, content, tag_index, course_ids];
        if (success) {
            NSLog(@"添加数据到日程表成功");
        }else {
            NSLog(@"添加数据到日程表失败");
        }
    }
    [dataBase close];
}


/**
 添加标签数据到标签数据库

 @param color_r 标签颜色R
 @param color_g 标签颜色G
 @param color_b 标签颜色B
 @param is_using 标签是否正在用
 @param content 标签内容
 */
- (void)setDataToTagDBColor_R:(NSString *)color_r
                      Color_G:(NSString *)color_g
                      Color_B:(NSString *)color_b
                      isUsing:(NSInteger)is_using
                      Content:(NSString *)content {
    FMDatabase *db = [FMDatabase databaseWithPath:[self creatSqlite]];
    NSString *insert_sql_string = @"insert into t_scheduletag (color_r, color_g, color_b, is_using, content) values (?,?,?,?,?);";
    if ([db open]) {
        BOOL success = [db executeUpdate:insert_sql_string, color_r, color_g, color_b, @(is_using), content];
        if (success) {
            NSLog(@"添加标签数据到数据库成功");
        }else {
            NSLog(@"添加标签数据到数据库失败");
        }
    }
    [db close];
}


/**
 添加数据到快捷入口表

 @param imageNamed 本地图片名称
 @param imageUrl 图片URL
 @param title 内容
 @param isShow 是否显示
 @param categoryModel 模块分类
 @param targetVCNamed 绑定的入口类
 @param targetData 绑定的数据
 */
- (void)insertDataToShortcutWithImageNamed:(NSString *)imageNamed
                                  ImageUrl:(NSString *)imageUrl
                                     Title:(NSString *)title
                                    IsShow:(NSString *)isShow
                             CategoryModel:(NSString *)categoryModel
                             TargetVCNamed:(NSString *)targetVCNamed
                                TargetData:(NSString *)targetData{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self creatSqlite]];
    NSString *insert_sql_string = @"insert into t_shortcut (imageNamed, imageUrl, title, isShow, categoryModel, targetVCNamed, targetData) values (?,?,?,?,?,?,?)";
    if ([db open]) {
        BOOL success = [db executeUpdate:insert_sql_string, imageNamed, imageUrl, title, isShow, categoryModel, targetVCNamed, targetData];
        if (success) {
            NSLog(@"快捷入口表添加数据成功");
        }else {
            NSLog(@"快捷入口表添加数据失败");
        }
    }
    [db close];
}
@end
