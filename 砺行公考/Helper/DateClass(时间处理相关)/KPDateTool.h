//
//  KPDateTool.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/28.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPDateTool : NSObject

/** 获取当前时间的时间戳（NSTimeInterval）*/
+ (NSTimeInterval)currentTimeStamp;

/** 获取当前时间的时间戳（NSString）*/
+ (NSString *)currentTimeStampStr;

/** 获取当前时间 (YYYY/MM/dd hh:mm:ss SS) */
+ (NSString *)currentDateStr;

/** 获取当前时间  并转化为指定格式*/
+ (NSString *)currentDateStrWithFormatter:(NSString *)formatStr;

/** 时间戳(NSString)转指定格式时间(YYYY/MM/dd hh:mm:ss SS) */
//+ (NSString *)getDateStringWithTimeStr:(NSString *)str;
+ (NSString *)getDateStringWithTimeStr:(NSString *)str withFormatStr:(NSString *)formatStr;

/** 字符串(YYYY/MM/dd hh:mm:ss SS)转时间戳(NSString) */
+ (NSString *)getTimeStrWithString:(NSString *)str;

/** 将时间戳转换为格式化后的字符串 (刚刚 几分钟前 几小时前 几天以前...) */
+ (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval;


/** 计算从 startTingDate 到 resultDate 相差的时间 */
+ (NSDateComponents *)dateDiffFromDate:(NSDate *)startTingDate toDate:(NSDate *)resultDate;

/** 判断某一日期(date)是否为今天 */
+ (BOOL)isToday:(NSDate *)date;

/** 判断某一日期(date)是否为昨天 */
+ (BOOL)isYesterday:(NSDate *)date;

/** 判断某一日期(date)是否为明天 */
+ (BOOL)isTomorrow:(NSDate *)date;

/** 判断某一日期(date)是否为今年 */
+ (BOOL)isThisYear:(NSDate *)date;

/** 格式化日期 */
+ (NSDate *)dateWithFormat:(NSDate *)date;

/** 格式化日期 */
+ (NSDate *)dateWithFormat:(NSDate *)date WithCustomFormatter:(NSString *)formatter;

/** 获取某一日期(date)的星期 */
+ (NSString *)weekdayStringFromDate:(NSDate *)date;

/**
 返回天数

 @return 返回当前年的每个月下面的天数
 */
+ (NSArray *)returnMonthInDays;

/**
 返回天数

 @return 返回某一年的总天数
 */
+ (NSInteger)returnDaysInYear;

/** 返回当前年份 */
+ (NSString *)returnCurrentYear;

/** 返回当前月份 */
+ (NSString *)returnCurrentMonth;

/** 返回当前天 */
+ (NSString *)returnCurrentDay;

@end
