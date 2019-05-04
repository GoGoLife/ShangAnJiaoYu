//
//  ShowChatGroupInfoCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ShowChatGroupInfoCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation ShowChatGroupInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatCellView];
    }
    return self;
}

- (void)creatCellView {
    __weak typeof(self) weakSelf = self;
    CGFloat height = (SCREENBOUNDS.width - 20 * 6) / 5;
    
    self.image_view = [[UIImageView alloc] init];
    ViewRadius(self.image_view, 5.0);
    self.image_view.backgroundColor = RandomColor;
    [self.contentView addSubview:self.image_view];
    [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(height - 20);
    }];
    
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(12);
    self.name_label.textAlignment = NSTextAlignmentCenter;
    self.name_label.text = @"18268865135";
    [self.contentView addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.image_view.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(20.0);
    }];
    
    self.type_label = [[UILabel alloc] init];
    self.type_label.font = SetFont(12);
    self.type_label.textAlignment = NSTextAlignmentCenter;
    self.type_label.text = @"群主";
    [self.contentView addSubview:self.type_label];
    [self.type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.name_label.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(20.0);
    }];
}



@end
