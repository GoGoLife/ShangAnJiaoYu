//
//  PartnerCircleModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PartnerCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PartnerCircleModel : NSObject

//动态ID
@property (nonatomic, strong) NSString *moments_id_;

//动态内容
@property (nonatomic, strong) NSString *content_;

//创建时间
@property (nonatomic, strong) NSString *create_time_;

//动态图片数组
@property (nonatomic, strong) NSArray *moment_picture_url_array;

//发布动态人  相关信息
//发布人姓名
@property (nonatomic, strong) NSString *user_name_;

@property (nonatomic, strong) NSString *level_;

//登录名   （手机号码）
@property (nonatomic, strong) NSString *login_name_;

//头像
@property (nonatomic, strong) NSString *picture_;

//性别
@property (nonatomic, strong) NSString *sex_;

//签名
@property (nonatomic, strong) NSString *signature_;

//评论数组
@property (nonatomic, strong) NSArray<PartnerCommentModel*> *comment_array;

//自定义数据相关
@property (nonatomic, assign) CGFloat infomation_height;

/** 用户是否点赞  0 === 未点赞  1 === 已点赞*/
@property (nonatomic, assign) NSInteger user_like_status;

/** 点赞数量 */
@property (nonatomic, strong) NSString *praise_number_string;

/** 评论数量 */
@property (nonatomic, strong) NSString *comment_number_string;

/** 文本高度 */
@property (nonatomic, assign) CGFloat content_height;

@end

NS_ASSUME_NONNULL_END
