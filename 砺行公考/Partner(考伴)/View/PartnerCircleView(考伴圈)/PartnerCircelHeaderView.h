//
//  PartnerCircelHeaderView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewMenu.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PartnerCircleHeaderViewDelegate <NSObject>
@optional


/**
 点击发布评论   这里的是父评论

 @param section section
 */
- (void)touchPublishComment:(NSInteger)section;

/**
 点击删除动态   （这里指的是我的动态）

 @param section section
 */
- (void)touchDeleteButtonAction:(NSInteger)section;

/**
 点赞操作

 @param section section
 */
- (void)touchPraiseButtonAction:(NSInteger)section PraiseLabel:(UILabel *)praise_label;

@end

@interface PartnerCircelHeaderView : UIView

//header的section
@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) UIButton *delete_button;

//是否显示删除按钮
@property (nonatomic, assign) BOOL isShowDeleteButton;

//头像
@property (nonatomic, strong) UIImageView *header_image;

//名称
@property (nonatomic, strong) UILabel *name_label;

//发表时间
@property (nonatomic, strong) UILabel *date_label;

//地址
@property (nonatomic, strong) UILabel *address_label;

//显示图片
@property (nonatomic, strong) UICollectionView *collectionview;

//点赞按钮
@property (nonatomic, strong) UIButton *spotPraise_button;

//点赞人数
@property (nonatomic, strong) UILabel *spotPraise_label;

//评论按钮
@property (nonatomic, strong) UIButton *comment_button;

//评论人数
@property (nonatomic, strong) UILabel *comment_label;

//考伴圈发表内容
@property (nonatomic, strong) TextViewMenu *content_label;

//内容高度
@property (nonatomic, assign) CGFloat content_height;

//collectionview   data
@property (nonatomic, strong) NSArray *collection_data_array;

/** 用户是否点赞 */
@property (nonatomic, assign) NSInteger user_like_status;

@property (nonatomic, weak) id<PartnerCircleHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
