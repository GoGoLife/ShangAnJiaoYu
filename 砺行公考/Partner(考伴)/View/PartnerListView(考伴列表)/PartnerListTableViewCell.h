//
//  PartnerListTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PartnerListTableViewCell : UITableViewCell

//是否可以选择
@property (nonatomic, assign) BOOL isCanSelect;

//是否选择
@property (nonatomic, strong) UIImageView *left_image;

//头像
@property (nonatomic, strong) UIImageView *header_image;

//名称
@property (nonatomic, strong) UILabel *top_label;

//消息
@property (nonatomic, strong) UILabel *message_label;

//时间
@property (nonatomic, strong) UILabel *date_label;

//有无新消息标志
@property (nonatomic, strong) UILabel *badge_label;

@end

NS_ASSUME_NONNULL_END
