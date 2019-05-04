//
//  MyCourseModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "MyCourseModel.h"

@implementation MyCourseModel

- (NSString *)tag_string {
    if (self.isStudy) {
        _tag_string = @"已学习";
    }else {
        _tag_string = @"推荐学习";
    }
    return _tag_string;
}

@end
