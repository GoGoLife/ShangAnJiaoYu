//
//  FirstCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "FirstCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation FirstCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    __weak typeof(self) weakSelf = self;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = WhiteColor;
    ViewRadius(backView, 5.0);
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.leftImageV = [[UIImageView alloc] init];
    [backView addSubview:self.leftImageV];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(24, 30));
    }];
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.font = SetFont(16);
    self.topLabel.text = @"公考基础能力训练";
    [backView addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(20);
        make.top.equalTo(backView.mas_top).offset(20);
    }];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.font = SetFont(12);
    self.bottomLabel.textColor = SetColor(155, 155, 155, 1);
    self.bottomLabel.text = @"一句话介绍清楚基础训练题库的特点";
    [backView addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.topLabel.mas_left);
    }];
    
    self.rightImageV = [[UIImageView alloc] init];
    [backView addSubview:self.rightImageV];
    [self.rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-20);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10, 20));
    }];
    
    
}

@end
