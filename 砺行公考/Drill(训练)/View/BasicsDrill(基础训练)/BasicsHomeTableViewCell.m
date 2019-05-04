//
//  BasicsHomeTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BasicsHomeTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation BasicsHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = SetColor(238, 238, 238, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    ViewRadius(back_view, 5.0);
    back_view.backgroundColor = WhiteColor;
    [self.contentView addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    
    self.rightImageV = [[UIImageView alloc] init];
//    self.rightImageV.backgroundColor = RandomColor;
    [back_view addSubview:self.rightImageV];
    [self.rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(26);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(12, 16));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = SetFont(20);
    self.titleLabel.text = @"思维反应速度特训";
    [back_view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
//        make.right.equalTo(weakSelf.rightImageV.mas_left).offset(-10);
    }];
    
    self.passLabel = [[UILabel alloc] init];
    self.passLabel.textAlignment = NSTextAlignmentCenter;
    self.passLabel.font = SetFont(12);
    self.passLabel.backgroundColor = SetColor(242, 68, 89, 1);
    self.passLabel.textColor = WhiteColor;
    ViewRadius(self.passLabel, 11.0);
    self.passLabel.text = @"已通过";
    [back_view addSubview:self.passLabel];
    [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(56, 22));
    }];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = SetFont(12);
    self.dateLabel.textColor = SetColor(191, 191, 191, 1);
    self.dateLabel.text = @"2017-11-1";
    [back_view addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back_view.mas_left).offset(20);
        make.bottom.equalTo(back_view.mas_bottom).offset(-10);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = SetFont(12);
    self.contentLabel.textColor = DetailTextColor;
    self.contentLabel.text = @"此处放置本训练的简介，能达到什么效果，有什么特别之处，吸引尽可能多的学院进入学习";
    self.contentLabel.numberOfLines = 0;
    [back_view addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.right.equalTo(weakSelf.rightImageV.mas_right);
        make.bottom.equalTo(weakSelf.dateLabel.mas_top).offset(-10);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = SetFont(12);
    self.numberLabel.textColor = SetColor(191, 191, 191, 1);
    self.numberLabel.text = @"12332人已通过";
    [back_view addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentLabel.mas_right);
        make.centerY.equalTo(weakSelf.dateLabel.mas_centerY);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
