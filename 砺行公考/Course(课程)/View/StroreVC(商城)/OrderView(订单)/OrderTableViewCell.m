//
//  OrderTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation OrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    __weak typeof(self) weakSelf = self;
    self.left_image = [[UIImageView alloc] init];
    self.left_image.image = [UIImage imageNamed:@"select_no"];
    [self.contentView addSubview:self.left_image];
    [self.left_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(0, 20));
    }];
    
    self.image_view = [[UIImageView alloc] init];
    self.image_view.backgroundColor = RandomColor;
    ViewRadius(self.image_view, 5.0);
    [self.contentView addSubview:self.image_view];
    [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.left_image.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40 - 90 - 10 - 20;
    self.content_label.numberOfLines = 2;
    self.content_label.lineBreakMode = NSLineBreakByTruncatingTail;
    self.content_label.text = @" 砺行暑期特训：超赞的暑期时间安排计划";
    [self.contentView addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.image_view.mas_top).offset(5);
        make.left.equalTo(weakSelf.image_view.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
    }];
    
    self.category_label = [[UILabel alloc] init];
    self.category_label.font = SetFont(12);
    self.category_label.textColor = DetailTextColor;
    self.category_label.text = @"分类：纯网络班学员";
    [self.contentView addSubview:self.category_label];
    [self.category_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.content_label.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.content_label.mas_left);
    }];
    
    self.price_label = [[UILabel alloc] init];
    self.price_label.font = SetFont(16);
    self.price_label.textColor = SetColor(242, 68, 89, 1);
    self.price_label.text = @"￥328";
    [self.contentView addSubview:self.price_label];
    [self.price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.category_label.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.category_label.mas_left);
    }];
    
    self.pay_peoples_label = [[UILabel alloc] init];
    self.pay_peoples_label.font = SetFont(10);
    self.pay_peoples_label.textColor = DetailTextColor;
    self.pay_peoples_label.text = @"2482人付款";
    [self.contentView addSubview:self.pay_peoples_label];
    [self.pay_peoples_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.price_label.mas_bottom);
        make.left.equalTo(weakSelf.price_label.mas_right).offset(10);
    }];
    
    self.number_label = [[UILabel alloc] init];
    self.number_label.font = SetFont(14);
//    self.number_label.text = @"x1";
    [self.contentView addSubview:self.number_label];
    [self.number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.price_label.mas_centerY);
    }];
}

- (void)setIsShowSelectButton:(BOOL)isShowSelectButton {
    _isShowSelectButton = isShowSelectButton;
    if (_isShowSelectButton) {
        [self.left_image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
        }];
    }else {
        [self.left_image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        self.left_image.image = [UIImage imageNamed:@"select_yes"];
    }else {
        self.left_image.image = [UIImage imageNamed:@"select_no"];
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
