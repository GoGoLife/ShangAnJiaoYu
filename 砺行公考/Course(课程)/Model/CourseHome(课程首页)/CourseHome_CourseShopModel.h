//
//  CourseHome_CourseShopModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseHome_CourseShopModel : NSObject

//课程商品ID
@property (nonatomic, strong) NSString *course_shop_id;

//商品的图片
@property (nonatomic, strong) NSString *image_url_string;

//标题
@property (nonatomic, strong) NSString *course_title_string;

//标签array
@property (nonatomic, strong) NSArray *tag_array;

//价格
@property (nonatomic, strong) NSString *price_string;

//付款人数
@property (nonatomic, strong)NSString *pay_numbers_string;

//好评率
@property (nonatomic, strong) NSString *good_evaluate_string;

/** 其它标签  (三天试听权益) */
@property (nonatomic, strong) NSString *other_string;

@end

@interface CourseHome_MyCourseModel : NSObject

//课程ID
@property (nonatomic, strong) NSString *my_course_id;

//课程类型
@property (nonatomic, strong) NSString *my_course_type;

//图片地址
@property (nonatomic, strong) NSString *image_string;

//标题
@property (nonatomic, strong) NSString *title_string;

//详细简介
@property (nonatomic, strong) NSString *detail_string;

/** 直播间ID */
@property (nonatomic, strong) NSString *room_id;

/** 点播时长 */
@property (nonatomic, assign) NSInteger timeLength;

/** 直播时间 */
@property (nonatomic, assign) NSInteger liveTime;

@end
NS_ASSUME_NONNULL_END

