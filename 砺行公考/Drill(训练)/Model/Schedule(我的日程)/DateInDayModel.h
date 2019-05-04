//
//  DateInDayModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/18.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateInDayModel : NSObject

/**
 代表时间
 */
@property (nonatomic, strong) NSString *date_string;

/**
 小时
 */
@property (nonatomic, strong) NSString *hour_string;

/**
 分钟
 */
@property (nonatomic, strong) NSString *minutes_string;

@property (nonatomic, strong) NSString *color_r;

@property (nonatomic, strong) NSString *color_g;

@property (nonatomic, strong) NSString *color_b;

/**
 表示是否选中
 */
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
