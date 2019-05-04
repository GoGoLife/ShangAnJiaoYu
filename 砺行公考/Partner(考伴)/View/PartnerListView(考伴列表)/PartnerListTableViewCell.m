//
//  PartnerListTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PartnerListTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation PartnerListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    self.left_image = [[UIImageView alloc] init];
    self.left_image.image = [UIImage imageNamed:@"select_no"];
    [self.contentView addSubview:self.left_image];
    __weak typeof(self) weakSelf = self;
    [self.left_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(0, 16));
    }];
    
    self.header_image = [[UIImageView alloc] init];
    self.header_image.backgroundColor = RandomColor;
    ViewRadius(self.header_image, 25.0);
    [self.contentView addSubview:self.header_image];
    [self.header_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.left_image.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.top_label = [[UILabel alloc] init];
    self.top_label.font = SetFont(16);
    self.top_label.text = @"XXX好友";
    [self.contentView addSubview:self.top_label];
    [self.top_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_image.mas_top);
        make.left.equalTo(weakSelf.header_image.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-60);
        make.height.mas_equalTo(50);
    }];
    
    self.date_label = [[UILabel alloc] init];
    self.date_label.font = SetFont(12);
    self.date_label.textColor = DetailTextColor;
    self.date_label.text = @"12:00";
    [self.contentView addSubview:self.date_label];
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_image.mas_top);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
    }];
}

- (void)setIsCanSelect:(BOOL)isCanSelect {
    _isCanSelect = isCanSelect;
    if (_isCanSelect) {
        [self.left_image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(16);
        }];
    }else {
        [self.left_image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
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
