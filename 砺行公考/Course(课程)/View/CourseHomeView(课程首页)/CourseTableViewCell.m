//
//  CourseTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CourseTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation CourseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    __weak typeof(self) weakSelf = self;
    self.left_view = [[UIImageView alloc] init];
//    self.left_view.backgroundColor = RandomColor;
    ViewRadius(self.left_view, 5.0);
    [self.contentView addSubview:self.left_view];
    [self.left_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(14);
    self.title_label.text = @"言语理解必守规则20条";
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.left_view.mas_top);
        make.left.equalTo(weakSelf.left_view.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-110);
    }];
    
    self.tag_label = [[UILabel alloc] init];
    self.tag_label.backgroundColor = SetColor(242, 68, 89, 0.08);
    self.tag_label.textColor = SetColor(242, 68, 89, 1);
    self.tag_label.font = SetFont(10);
    self.tag_label.textAlignment = NSTextAlignmentCenter;
//    self.tag_label.text = @"直播";
    [self.contentView addSubview:self.tag_label];
    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.left.equalTo(weakSelf.title_label.mas_left);
    }];
    
    self.detail_label = [[UILabel alloc] init];
    self.detail_label.font = SetFont(12);
    self.detail_label.textColor = DetailTextColor;
    self.detail_label.numberOfLines = 0;
//    self.detail_label.text = @"直播时间：10：00-12：00";
    [self.contentView addSubview:self.detail_label];
    [self.detail_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.title_label.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.title_label.mas_left);
        make.right.equalTo(weakSelf.title_label.mas_right);
        make.bottom.equalTo(weakSelf.tag_label.mas_top).offset(-5);
    }];
    
    self.touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.touchButton.titleLabel.font = SetFont(14);
    self.touchButton.backgroundColor = SetColor(48, 132, 252, 0.08);
    self.touchButton.titleLabel.font = SetFont(14);
    ViewRadius(self.touchButton, 5.0);
    [self.touchButton setTitleColor:ButtonColor forState:UIControlStateNormal];
    [self.contentView addSubview:self.touchButton];
    [self.touchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
}

//StringWidth()
//- (void)layoutSubviews {
//    __weak typeof(self) weakSelf = self;
//    CGFloat width = [self calculateRowWidth:self.tag_label.text withFont:10];
//    [self.tag_label mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(width + 20);
//    }];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
