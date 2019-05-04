//
//  SecondCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SecondCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation SecondCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    __weak typeof(self) weakSelf = self;
    UIView *backView = [[UIView alloc] init];
    ViewRadius(backView, 5.0);
    backView.backgroundColor = WhiteColor;
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.topImageV = [[UIImageView alloc] init];
    [backView addSubview:self.topImageV];
    [self.topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(15);
        make.left.equalTo(backView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(23, 25));
    }];
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.font = SetFont(16);
    self.centerLabel.text = @"全真题库";
    [backView addSubview:self.centerLabel];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topImageV.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.topImageV.mas_left);
    }];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.textColor = DetailTextColor;
    self.bottomLabel.font = SetFont(12);
    self.bottomLabel.text = @"一句话介绍";
    [backView addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.centerLabel.mas_left);
        make.right.equalTo(weakSelf.centerLabel.mas_right);
        make.bottom.equalTo(backView.mas_bottom).offset(-15);
    }];
    
    
}

@end
