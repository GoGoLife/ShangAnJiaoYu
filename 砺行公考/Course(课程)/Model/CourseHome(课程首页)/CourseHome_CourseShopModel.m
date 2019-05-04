//
//  CourseHome_CourseShopModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CourseHome_CourseShopModel.h"
#import "KPDateTool.h"

@interface CourseHome_CourseShopModel ()

@end

@implementation CourseHome_CourseShopModel

@end




@interface CourseHome_MyCourseModel ()

@end

@implementation CourseHome_MyCourseModel

- (NSString *)detail_string {
    if ([self.my_course_type isEqualToString:@"1"]) {
        //直播
        _detail_string = [NSString stringWithFormat:@"直播时间:%@ 小时", [KPDateTool getTimeStrWithString:[NSString stringWithFormat:@"%ld", self.liveTime]]];
    }else {
        //点播
        _detail_string = [NSString stringWithFormat:@"点播时长:%@ 小时", [NSString stringWithFormat:@"%ld", self.timeLength / 1000 / 60 / 60]];
    }
    return _detail_string;
}

@end
