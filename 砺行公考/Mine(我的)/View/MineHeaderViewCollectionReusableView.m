//
//  MineHeaderViewCollectionReusableView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "MineHeaderViewCollectionReusableView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation MineHeaderViewCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self creatViewUI];
    }
    return self;
}

- (void)creatViewUI {
    __weak typeof(self) weakSelf = self;
    self.header_image = [[UIImageView alloc] init];
    self.header_image.backgroundColor = RandomColor;
    ViewRadius(self.header_image, 35.0);
    [self addSubview:self.header_image];
    [self.header_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(20);
    self.name_label.text = @"取名字好难";
    [self addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
    }];
    
    self.sex_image = [[UIImageView alloc] init];
    self.sex_image.backgroundColor = RandomColor;
    ViewRadius(self.sex_image, 8.0);
    [self addSubview:self.sex_image];
    [self.sex_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.name_label.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.name_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    self.class_label = [[UILabel alloc] init];
    self.class_label.backgroundColor = SetColor(48, 132, 252, 0.08);
    self.class_label.textColor = SetColor(48, 132, 252, 1);
    self.class_label.font = SetFont(10);
    self.class_label.text = @"LV 28";
    self.class_label.textAlignment = NSTextAlignmentCenter;
    ViewRadius(self.class_label, 10.0);
    [self addSubview:self.class_label];
    [self.class_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.sex_image.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.name_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    //能力分
    self.score_label = [[UILabel alloc] init];
    self.score_label.font = SetFont(12);
    self.score_label.textColor = DetailTextColor;
    self.score_label.text = @"能力分";
    [self addSubview:self.score_label];
    [self.score_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.name_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.name_label.mas_left);
    }];
    
    self.score_content_label = [[UILabel alloc] init];
    self.score_content_label.font = SetFont(18);
    self.score_content_label.text = @"29838";
    [self addSubview:self.score_content_label];
    [self.score_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.score_label.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.score_label.mas_left);
    }];
    
    //能力币
//    self.money_label = [[UILabel alloc] init];
//    self.money_label.font = SetFont(12);
//    self.money_label.textColor = DetailTextColor;
//    self.money_label.text = @"能力币";
//    [self addSubview:self.money_label];
//    [self.money_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.score_label.mas_right).offset(60);
//        make.centerY.equalTo(weakSelf.score_label.mas_centerY);
//    }];
//
//    self.money_content_label = [[UILabel alloc] init];
//    self.money_content_label.font = SetFont(18);
//    self.money_content_label.text = @"29838";
//    [self addSubview:self.money_content_label];
//    [self.money_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.money_label.mas_left);
//        make.centerY.equalTo(weakSelf.score_content_label.mas_centerY);
//    }];
//
//    UILabel *line = [[UILabel alloc] init];
//    line.backgroundColor = SetColor(247, 247, 247, 1);
//    [self addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.score_content_label.mas_bottom).offset(20);
//        make.left.equalTo(weakSelf.mas_left).offset(20);
//        make.right.equalTo(weakSelf.mas_right).offset(-20);
//        make.height.mas_equalTo(1);
//    }];
//
//    UIView *back_view = [[UIView alloc] init];
//    [self addSubview:back_view];
//    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line.mas_bottom);
//        make.left.equalTo(weakSelf.mas_left);
//        make.bottom.equalTo(weakSelf.mas_bottom);
//        make.right.equalTo(weakSelf.mas_right);
//    }];
//
//    self.task_text_field = [[UITextField alloc] init];
//    self.task_text_field.enabled = NO;
//    self.task_text_field.font = SetFont(10);
//    self.task_text_field.text = @"  可获得能力分";
//
//
//    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 60, 20)];
//    left_label.font = SetFont(14);
//    left_label.textColor = SetColor(48, 132, 252, 1);
//    left_label.text = @"每日任务";
//    self.task_text_field.leftView = left_label;
//    self.task_text_field.leftViewMode = UITextFieldViewModeAlways;
//
//    UIImageView *right_image = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 10, 20)];
//    right_image.backgroundColor = RandomColor;
//    self.task_text_field.rightView = right_image;
//    self.task_text_field.rightViewMode = UITextFieldViewModeAlways;
//
//    [back_view addSubview:self.task_text_field];
//    [self.task_text_field mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(back_view.mas_top).offset(20);
//        make.left.equalTo(back_view.mas_left).offset(20);
//        make.right.equalTo(back_view.mas_right).offset(-20);
////        make.height.equalTo
//    }];
//
//    //完成率
//    self.percentage_label = [[UILabel alloc] init];
//    self.percentage_label.backgroundColor = SetColor(255, 197, 0, 1);
//    self.percentage_label.font = SetFont(10);
//    self.percentage_label.textColor = WhiteColor;
//    self.percentage_label.text = @"40%";
//    self.percentage_label.textAlignment = NSTextAlignmentCenter;
//    ViewRadius(self.percentage_label, 8.0);
//    [back_view addSubview:self.percentage_label];
//    [self.percentage_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.task_text_field.mas_bottom).offset(10);
//        make.left.equalTo(weakSelf.task_text_field.mas_left);
//        make.size.mas_equalTo(CGSizeMake(40, 16));
//    }];
//
//    self.slider = [[UISlider alloc] init];
////    self.slider.backgroundColor = SetColor(255, 197, 0, 1);
//    self.slider.minimumValue = 0;
//    self.slider.maximumValue = 100;
//    [self.slider setValue:70 animated:YES];
//    self.slider.thumbTintColor = [UIColor clearColor];
//    [back_view addSubview:self.slider];
//    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.percentage_label.mas_right).offset(10);
//        make.right.equalTo(weakSelf.task_text_field.mas_right);
//        make.centerY.equalTo(weakSelf.percentage_label.mas_centerY);
//        make.height.mas_equalTo(6);
//    }];
}

@end
