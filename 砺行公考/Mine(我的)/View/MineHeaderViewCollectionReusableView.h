//
//  MineHeaderViewCollectionReusableView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineHeaderViewCollectionReusableView : UICollectionReusableView

//头像
@property (nonatomic, strong) UIImageView *header_image;

//名称
@property (nonatomic, strong) UILabel *name_label;

//性别
@property (nonatomic, strong) UIImageView *sex_image;

//等级
@property (nonatomic, strong) UILabel *class_label;

//能力分
@property (nonatomic, strong) UILabel *score_label;

//能力分
@property (nonatomic, strong) UILabel *score_content_label;

//能力币
@property (nonatomic, strong) UILabel *money_label;

//能力币
@property (nonatomic, strong) UILabel *money_content_label;

//每日任务
@property (nonatomic, strong) UITextField *task_text_field;

//完成百分比
@property (nonatomic, strong) UILabel *percentage_label;

//
@property (nonatomic, strong) UISlider *slider;

@end

NS_ASSUME_NONNULL_END
