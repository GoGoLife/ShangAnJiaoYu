//
//  CommentHeaderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/25.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CommentHeaderView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation CommentHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    UILabel *top_line = [[UILabel alloc] init];
    top_line.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:top_line];
    [top_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    self.header_imageview = [[UIImageView alloc] init];
    self.header_imageview.backgroundColor = RandomColor;
    ViewRadius(self.header_imageview, 20.0);
    [self addSubview:self.header_imageview];
    [self.header_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(20);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(14);
    self.name_label.textColor = DetailTextColor;
    self.name_label.text = @"XXX法";
    [self addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_imageview.mas_top);
        make.left.equalTo(weakSelf.header_imageview.mas_right).offset(10);
    }];
    
    self.tag_label = [[UILabel alloc] init];
    self.tag_label.font = SetFont(10);
    self.tag_label.textColor = SetColor(48, 132, 252, 1);
    self.tag_label.text = @"杭州市言语大师";
    [self addSubview:self.tag_label];
    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.name_label.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.name_label.mas_centerY);
    }];
    
    self.date_label = [[UILabel alloc] init];
    self.date_label.font = SetFont(14);
    self.date_label.textColor = DetailTextColor;
    self.date_label.text = @"2小时之前";
    [self addSubview:self.date_label];
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.name_label.mas_centerY);
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 20 - 40 - 10 - 20;
    self.content_label.numberOfLines = 0;
    [self addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.name_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.name_label.mas_left);
        make.right.equalTo(weakSelf.date_label.mas_right);
    }];
    
    UILabel *bottom_line = [[UILabel alloc] init];
    bottom_line.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:bottom_line];
    [bottom_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
