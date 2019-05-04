//
//  PartnerCircleCommantTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PartnerCircleCommantTableViewCell : UITableViewCell

//头像
@property (nonatomic, strong) UIImageView *header_image;

//姓名
@property (nonatomic, strong) UILabel *name_label;

//评论内容
@property (nonatomic, strong) UILabel *comment_content_label;

@end

NS_ASSUME_NONNULL_END
