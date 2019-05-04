//
//  DBManager.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/29.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "GlobarFile.h"

@interface DBManager : NSObject

+ (DBManager *)sharedInstance;

//数据库   懒加载
- (NSString *)creatSqlite;

//创建表
- (void)creatTable;

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
             Data_Course_ids:(NSString *)course_ids;

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
                      Content:(NSString *)content;

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
                                TargetData:(NSString *)targetData;

@end
