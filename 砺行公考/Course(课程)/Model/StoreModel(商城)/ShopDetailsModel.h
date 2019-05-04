//
//  ShopDetailsModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/26.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopDetailsModel : NSObject

/** 商品大类id */
@property (nonatomic, strong) NSString *shop_id;

//商品简介   视频+图片
@property (nonatomic, strong) NSArray *shop_intro_array;

@property (nonatomic, strong) NSArray *shop_mp4_array;

//商品title
@property (nonatomic, strong) NSString *title_string;

//商品标签数组
@property (nonatomic, strong) NSArray *tag_array;

//价格
@property (nonatomic, strong) NSString *price_string;

//付款人数
@property (nonatomic, strong) NSString *pay_numbers_string;

//授课时间
@property (nonatomic, strong) NSString *date_string;

//评价数据
@property (nonatomic, strong) NSArray *shop_comment_array;

//详情图片
@property (nonatomic, strong) NSArray *shop_details_array;

//详情文字说明
@property (nonatomic, strong) NSString *shop_details_string;

@property (nonatomic, assign) CGFloat shop_details_string_height;

@end


@interface ShopCommentModel : NSObject

//商品评价的ID
@property (nonatomic, strong) NSString *shop_comment_id;

//评论人的头像
@property (nonatomic, strong) NSString *header_image_url;

//评论人的名字
@property (nonatomic, strong) NSString *name_string;

//评论人的标签
@property (nonatomic, strong) NSString *tag_string;

//评论人的等级
@property (nonatomic, strong) NSString *grade_string;

//评论人的分类
@property (nonatomic, strong) NSString *category_string;

//评论数据
@property (nonatomic, strong) NSString *comment_string;

//评论发布的图片
@property (nonatomic, strong) NSArray *image_array;

//评论cell的高度
@property (nonatomic, assign) CGFloat comment_cell_height;

@end

NS_ASSUME_NONNULL_END
