//
//  RefiningModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefiningModel : NSObject

/** 父评论的ID */
@property (nonatomic, strong) NSString *parent_id;

/** 是否是讲师推荐 */
@property (nonatomic, strong) NSString *isReCommend;

/** 头像地址 */
@property (nonatomic, strong) NSString *header_url;

/** 名称 */
@property (nonatomic, strong) NSString *name;

/** 时间 */
@property (nonatomic, strong) NSString *time;

/** 评论内容是文本 */
@property (nonatomic, strong) NSString *content_string;

/** 评论内容是图片 */
@property (nonatomic, strong) NSString *content_image_url;

/** 老师点评 */
@property (nonatomic, strong) NSString *teacher_review;

/** 点赞数量 */
@property (nonatomic, strong) NSString *praise_number;

/** 评论的文本  高度 */
@property (nonatomic, assign) CGFloat content_string_height;

/** 老师点评内容的高度 */
@property (nonatomic, assign) CGFloat teacher_review_height;

/** 子评论数组 */
@property (nonatomic, strong) NSArray *son_array;

/** 是否点赞 */
@property (nonatomic, assign) BOOL isPraise;

@end

#pragma mark ------ Refining 发表的文本 model
@interface RefiningContentModel : NSObject

/** 精炼时评的ID */
@property (nonatomic, strong) NSString *refining_id;

/**
 发布的精炼时评的type 1 == 视频  2 == 话题  3 == 文章
 */
@property (nonatomic, assign) NSInteger publish_type;

/** 发布的视频的URL */
@property (nonatomic, strong) NSString *refining_video_url;

/** 发布的内容 */
@property (nonatomic, strong) NSString *content;

/** 发布的内容的高度 */
@property (nonatomic, assign) CGFloat content_height;

/** 判断是否出于展开状态 */
@property (nonatomic, assign) BOOL isOn;

@end

#pragma mark ******* 子评论 *********
@interface RefiningSonModel : NSObject

@property (nonatomic, strong) NSString *son_content;

@property (nonatomic, assign) CGFloat son_height;

@end

NS_ASSUME_NONNULL_END
