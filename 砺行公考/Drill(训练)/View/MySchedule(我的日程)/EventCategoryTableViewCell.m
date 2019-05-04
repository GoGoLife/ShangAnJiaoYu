//
//  EventCategoryTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/28.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "EventCategoryTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation EventCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delete_button.hidden = YES;
    self.delete_button.backgroundColor = [UIColor redColor];
    ViewRadius(self.delete_button, 10.0);
    [self.contentView addSubview:self.delete_button];
    __weak typeof(self) weakSelf = self;
    [self.delete_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.color_label = [[UILabel alloc] init];
    self.color_label.backgroundColor = RandomColor;
    ViewRadius(self.color_label, 5.0);
    [self.contentView addSubview:self.color_label];
    [self.color_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(16);
    self.content_label.text = @"睡眠";
    [self.contentView addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)setIsShowDeleteButton:(BOOL)isShowDeleteButton {
    _isShowDeleteButton = isShowDeleteButton;
    __weak typeof(self) weakSelf = self;
    if (_isShowDeleteButton) {
        self.delete_button.hidden = NO;
        [self.color_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(70);
        }];
    }else {
        self.delete_button.hidden = YES;
        [self.color_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
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
