//
//  EssayTests_HomeTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "EssayTests_HomeTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation EssayTests_HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
    }
    return self;
}


- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    self.video_back_image = [[UIImageView alloc] init];
//    self.video_back_image.backgroundColor = RandomColor;
    ViewRadius(self.video_back_image, 5.0);
    [self.contentView addSubview:self.video_back_image];
    [self.video_back_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREENBOUNDS.width - 40, 160));
    }];
    
    self.play_image = [[UIImageView alloc] init];
//    self.play_image.backgroundColor = RandomColor;
    self.play_image.image = [UIImage imageNamed:@"play"];
    ViewRadius(self.play_image, 25.0);
    [self.video_back_image addSubview:self.play_image];
    [self.play_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.video_back_image);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.test_number_label = [[UILabel alloc] init];
    self.test_number_label.backgroundColor = WhiteColor;
    self.test_number_label.font = SetFont(12);
    self.test_number_label.textAlignment = NSTextAlignmentCenter;
    ViewRadius(self.test_number_label, 10.0);
    self.test_number_label.text = @"题量 3";
    [self.video_back_image addSubview:self.test_number_label];
    [self.test_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.video_back_image.mas_left).offset(10);
        make.bottom.equalTo(weakSelf.video_back_image.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(18);
    self.title_label.numberOfLines = 0;
    self.title_label.text = @"2017年浙江省考";
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.video_back_image.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.video_back_image.mas_left);
    }];
    
    self.detail_label = [[UILabel alloc] init];
    self.detail_label.font = SetFont(12);
    self.detail_label.textColor = DetailTextColor;
    self.detail_label.numberOfLines = 0;
    self.detail_label.text = @"一句话简介概念省考的特点和着重训练能力方向，便于非学院理解和判断，便于非学院理解和判断";
    [self.contentView addSubview:self.detail_label];
    [self.detail_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.title_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.title_label.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
    self.didJoin_number = [[UILabel alloc] init];
    self.didJoin_number.font = SetFont(12);
    self.didJoin_number.textColor = DetailTextColor;
    self.didJoin_number.text = @"12345人已参加";
    [self.contentView addSubview:self.didJoin_number];
    [self.didJoin_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detail_label.mas_bottom).offset(16);
        make.left.equalTo(weakSelf.detail_label.mas_left);
    }];
    self.didJoin_number.hidden = YES;
    
    self.pay_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pay_button.titleLabel.font = SetFont(14);
    [self.pay_button setTitleColor:SetColor(48, 132, 252, 1) forState:UIControlStateNormal];
    self.pay_button.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(self.pay_button, 14.0);
    [self.pay_button addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pay_button setTitle:@"免费训练" forState:UIControlStateNormal];
    [self.contentView addSubview:self.pay_button];
    [self.pay_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.didJoin_number.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(90, 28));
    }];
}

- (void)touchAction {
    if ([_delegate respondsToSelector:@selector(touchGoPlayPloblem:)]) {
        [_delegate touchGoPlayPloblem:self.indexPath];
    }
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
