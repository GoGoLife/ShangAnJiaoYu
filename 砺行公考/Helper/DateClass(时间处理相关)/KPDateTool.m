//
//  KPDateTool.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/28.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "KPDateTool.h"

@implementation KPDateTool

/** 获取当前时间的时间戳(NSTimeInterval)  */
+ (NSTimeInterval)currentTimeStamp {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    return interval;
}

/** 获取当前时间的时间戳(NSString) */
+ (NSString *)currentTimeStampStr {
    NSTimeInterval interval = [self currentTimeStamp];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", interval];
    return timeString;
}

/** 获取当前时间(YYYY/MM/dd hh:mm:ss SS) */
+ (NSString *)currentDateStr {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS "];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/** 获取当前时间  并转化为指定格式*/
+ (NSString *)currentDateStrWithFormatter:(NSString *)formatStr {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/** 时间戳(NSString)转指定格式时间(YYYY/MM/dd hh:mm:ss SS) */
+ (NSString *)getDateStringWithTimeStr:(NSString *)str withFormatStr:(NSString *)formatStr {
    NSTimeInterval time = str.length == 13 ? [str doubleValue] / 1000 : [str doubleValue]; //时间戳为13位是精确到毫秒的，10位精确到秒，传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss SS"];
    [dateFormatter setDateFormat:formatStr];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

/** 字符串(YYYY/MM/dd hh:mm:ss SS)转时间戳(NSString) */
+ (NSString *)getTimeStrWithString:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *tempDate = [dateFormatter dateFromString:str];
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];
    return timeStr;
}

/** 将时间戳转换为格式化后的字符串 (刚刚 几分钟前 几小时前 几天以前...) */
+ (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval nowTimeinterval = [self currentTimeStamp];
    int timeInt = nowTimeinterval - timeIntrval; //时间差
    
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    int second = timeInt;
    if (year > 0) {
        return [NSString stringWithFormat:@"%d年以前",year];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%d个月以前",month];
    }else if(day > 0){
        return [NSString stringWithFormat:@"%d天以前",day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时以前",hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟以前",minute];
    }else{
        return [NSString stringWithFormat:@"刚刚"];
    }
}

/** 计算从 startTingDate 到 resultDate 相差的时间 */
+ (NSDateComponents *)dateDiffFromDate:(NSDate *)startTingDate toDate:(NSDate *)resultDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit *unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:startTingDate toDate:resultDate options:0];
    return cmps;
}

/** 判断某一日期(date)是否为今天 */
+ (BOOL)isToday:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]]; // 当前时间的 年月日
    
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

/** 判断某一日期(date)是否为昨天 */
+ (BOOL)isYesterday:(NSDate *)date {
    
    NSDate *nowDate = [self dateWithFormat:[NSDate date]];
    
    NSDate *selfDate = [self dateWithFormat:date];
    
    NSDateComponents *cmps = [self dateDiffFromDate:selfDate toDate:nowDate];
    
    return cmps.day == 1;
}

/** 判断某一日期(date)是否为明天 */
+ (BOOL)isTomorrow:(NSDate *)date {
    
    NSDate *nowDate = [self dateWithFormat:[NSDate date]];
    
    NSDate *selfDate = [self dateWithFormat:date];
    
    NSDateComponents *cmps = [self dateDiffFromDate:nowDate toDate:selfDate];
    
    return cmps.day == 1;
}

/** 判断某一日期(date)是否为今年 */
+ (BOOL)isThisYear:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    
    return nowCmps.year == selfCmps.year;
    
}

/** 格式化日期 */
+ (NSDate *)dateWithFormat:(NSDate *)date {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:date];
    return [fmt dateFromString:selfStr];
}

/** 格式化日期 按照指定格式*/
+ (NSDate *)dateWithFormat:(NSDate *)date WithCustomFormatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = formatter;//@"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:date];
    return [fmt dateFromString:selfStr];
}

/** 获取某一日期(date)的星期 */
+ (NSString *)weekdayStringFromDate:(NSDate *)date {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


#pragma mark - 待完成

/** 判断两个日期是否在同一个星期 */

/** 判断两个时间是否在同一天 */

/** 获取指定日期的周一的日期 */

#pragma mark --- 新添加
/**
 返回天数
 
 @return 返回当前年的每个月下面的天数
 */
+ (NSArray *)returnMonthInDays {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    //当前年份
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSMutableArray *dayArray = [NSMutableArray arrayWithCapacity:1];
    
    //新格式
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat:@"yyyy-MM"];
    
    for (NSInteger index = 1; index <= 12; index++) {
        NSString *MonthString = [NSString stringWithFormat:@"-%ld", index];
        //拼接当前年份  月份
        NSString *dateString = [yearString stringByAppendingString:MonthString];
        //将字符串转换成时间
        NSDate *currentDate = [newFormatter dateFromString:dateString];
        //计算月下的天数
        NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
        //将获取到的天数  添加到数组中
        [dayArray addObject:[NSString stringWithFormat:@"%ld", dayRange.length]];
    }
    
    return [dayArray copy];
}

/**
 返回天数
 
 @return 返回某一年的总天数
 */
+ (NSInteger)returnDaysInYear {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange yearRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:[NSDate date]];
    return yearRange.length;
}

/** 返回当前年份 */
+ (NSString *)returnCurrentYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

/** 返回当前月份 */
+ (NSString *)returnCurrentMonth {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    return [formatter stringFromDate:[NSDate date]];
}

/** 返回当前天 */
+ (NSString *)returnCurrentDay {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    return [formatter stringFromDate:[NSDate date]];
}
@end
