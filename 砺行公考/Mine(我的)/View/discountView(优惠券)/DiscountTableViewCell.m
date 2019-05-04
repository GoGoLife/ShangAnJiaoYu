//
//  DiscountTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "DiscountTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation DiscountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = WhiteColor;
    [self.contentView addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    self.left_label = [[UILabel alloc] init];
    self.left_label.textColor = SetColor(242, 68, 89, 1);
    self.left_label.font = SetFont(22);
    self.left_label.text = @"￥200";
    [back_view addSubview:self.left_label];
    [self.left_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back_view.mas_left).offset(20);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
    
    self.discount_type_label = [[UILabel alloc] init];
    self.discount_type_label.font = SetFont(18);
    self.discount_type_label.text = @"学费卷";
    [back_view addSubview:self.discount_type_label];
    [self.discount_type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(15);
        make.left.equalTo(weakSelf.left_label.mas_right).offset(20);
    }];
    
    self.details_label = [[UILabel alloc] init];
    self.details_label.font = SetFont(12);
    self.details_label.textColor = DetailTextColor;
    self.details_label.numberOfLines = 0;
    self.details_label.text = @"·限参加砺行课程时抵用学费\n（部分特殊课程除外）";
    [back_view addSubview:self.details_label];
    [self.details_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.discount_type_label.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.discount_type_label.mas_left);
    }];
    
    self.date_label = [[UILabel alloc] init];
    self.date_label.font = SetFont(12);
    self.date_label.textColor = DetailTextColor;
    self.date_label.text = @"2017.09.02-2018.09.20";
    [back_view addSubview:self.date_label];
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.details_label.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.details_label.mas_left);
    }];
}

- (void)setIsUse:(BOOL)isUse {
    _isUse = isUse;
    if (_isUse) {
        self.left_label.textColor = SetColor(242, 68, 89, 1);
        self.discount_type_label.textColor = DetailTextColor;
//        self.details_label.textColor = DetailTextColor;
//        self.date_label.textColor = DetailTextColor;
    }else {
        self.left_label.textColor = DetailTextColor;
        self.discount_type_label.textColor = [UIColor blackColor];
//        self.details_label.textColor = DetailTextColor;
//        self.date_label.textColor = DetailTextColor;
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
