//
//  DrillCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DrillCollectionViewCell.h"
#import <Masonry.h>
#import "GlobarFile.h"

@implementation DrillCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    __weak typeof(self) weakSelf = self;
    self.imageV = [[UIImageView alloc] init];
//    self.imageV.backgroundColor = RandomColor;
    ViewRadius(self.imageV, 5.0);
    [self.contentView addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 25, 0));
    }];
    
    self.label = [[UILabel alloc] init];
    self.label.font = SetFont(12);
    self.label.text = @"方法训练";
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.imageV.mas_centerX);
        make.top.equalTo(weakSelf.imageV.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    self.delete_imageview = [[UIImageView alloc] init];
    self.delete_imageview.image = [UIImage imageNamed:@"right_top_less"];
    [self.contentView addSubview:self.delete_imageview];
    [self.delete_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    self.delete_imageview.hidden = YES;
}

- (void)setIsShowDeleteButton:(BOOL)isShowDeleteButton {
    _isShowDeleteButton = isShowDeleteButton;
    if (_isShowDeleteButton) {
        self.delete_imageview.hidden = NO;
    }else {
        self.delete_imageview.hidden = YES;
    }
}

@end
