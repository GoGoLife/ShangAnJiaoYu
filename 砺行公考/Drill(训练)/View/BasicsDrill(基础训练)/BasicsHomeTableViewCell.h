//
//  BasicsHomeTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicsHomeTableViewCell : UITableViewCell

//标题
@property (nonatomic, strong) UILabel *titleLabel;

//收藏图标
@property (nonatomic, strong) UIImageView *rightImageV;

//内容简介
@property (nonatomic, strong) UILabel *contentLabel;

//时间
@property (nonatomic, strong) UILabel *dateLabel;

//通过人数
@property (nonatomic, strong) UILabel *numberLabel;

//已通过标签
@property (nonatomic, strong) UILabel *passLabel;

@end
