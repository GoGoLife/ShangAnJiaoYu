//
//  DayModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/18.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DayModel : NSObject

/**
 年份
 */
@property (nonatomic, strong) NSString *year_string;

/**
 月份
 */
@property (nonatomic, strong) NSString *month_string;


/**
 日期
 */
@property (nonatomic, strong) NSString *day_string;

/**
 周几
 */
@property (nonatomic, strong) NSString *week_string;

/**
 当前天下的时间数组
 */
@property (nonatomic, strong) NSArray *dateIndayData;

@end

NS_ASSUME_NONNULL_END
