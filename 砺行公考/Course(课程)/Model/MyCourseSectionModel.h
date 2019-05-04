//
//  MyCourseSectionModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCourseModel.h"

@interface MyCourseSectionModel : NSObject

//是否点击了Section
@property (nonatomic, assign) BOOL isSelected;

//课程包ID
@property (nonatomic, strong) NSString *my_course_pakeage_id;

//title
@property (nonatomic, strong) NSString *title_string;

//detail
@property (nonatomic, strong) NSString *detail_string;

//完成度
@property (nonatomic, strong) NSString *finish_string;

//完成度 百分比
@property (nonatomic, strong) NSString *slider_value_string;

//我的课程数组
@property (nonatomic, strong) NSArray<MyCourseModel *> *my_course_array;

@end
