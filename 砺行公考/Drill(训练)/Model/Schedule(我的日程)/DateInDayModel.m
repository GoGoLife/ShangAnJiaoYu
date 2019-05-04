//
//  DateInDayModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/18.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "DateInDayModel.h"

@implementation DateInDayModel

//拼接时间
- (NSString *)date_string {
    _date_string = [NSString stringWithFormat:@"%@:%@", self.hour_string, self.minutes_string];
    return _date_string;
}

@end
