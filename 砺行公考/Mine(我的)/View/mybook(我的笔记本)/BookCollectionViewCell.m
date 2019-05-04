//
//  BookCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BookCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation BookCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    __weak typeof(self) weakSelf = self;
    self.imageview = [[UIImageView alloc] init];
    self.imageview.backgroundColor = RandomColor;
    ViewRadius(self.imageview, 8.0);
    [self.contentView addSubview:self.imageview];
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(weakSelf.contentView.mas_width);
    }];
    
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(14);
    self.name_label.text = @"分析观点";
    [self.contentView addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageview.mas_bottom).offset(8);
        make.left.equalTo(weakSelf.imageview.mas_left);
        make.width.lessThanOrEqualTo(@(weakSelf.bounds.size.width / 3 * 2));
    }];
    
    self.numbers_label = [[UILabel alloc] init];
    self.numbers_label.font = SetFont(12);
    self.numbers_label.textColor = DetailTextColor;
    self.numbers_label.text = @"已收录223条";
    [self.contentView addSubview:self.numbers_label];
    [self.numbers_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.name_label.mas_bottom).offset(8);
        make.left.equalTo(weakSelf.name_label.mas_left);
        make.width.lessThanOrEqualTo(@(weakSelf.bounds.size.width / 3 * 2));
    }];
    
    self.edit_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.edit_button.titleLabel.font = SetFont(12);
    [self.edit_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [self.edit_button setTitle:@"编辑" forState:UIControlStateNormal];
    [self.edit_button addTarget:self action:@selector(touchEditButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.edit_button];
    [self.edit_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(0);
        make.centerY.equalTo(weakSelf.numbers_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
}

- (void)setIsShowEditButton:(BOOL)isShowEditButton {
    _isShowEditButton = isShowEditButton;
    if (_isShowEditButton) {
        [self.edit_button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
        }];
        [self.numbers_label mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.lessThanOrEqualTo(@(self.bounds.size.width / 3 * 2));
        }];
    }else {
        [self.edit_button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.numbers_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo(@(self.bounds.size.width));
        }];
    }
}

//点击编辑
- (void)touchEditButtonAction {
    if ([_delegate respondsToSelector:@selector(touchEditButtonActionWithIndexPath:)]) {
        [_delegate touchEditButtonActionWithIndexPath:self.indexPath];
    }
}

@end
