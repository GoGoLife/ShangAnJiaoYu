//
//  CorrentDetailsFooterView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/24.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CorrectDetailsFooterView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation CorrectDetailsFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    __weak typeof(self) weakSelf = self;
    UILabel *user_name = [[UILabel alloc] init];
    user_name.font = SetFont(12);
    user_name.textColor = DetailTextColor;
    user_name.text = @"作者：超人不会飞";
    [self addSubview:user_name];
    [user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
    }];
    
    UILabel *score = [[UILabel alloc] init];
    score.font = SetFont(20);
    score.textColor = SetColor(48, 132, 252, 1);
    score.text = @"19";
    [self addSubview:score];
    [score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.centerY.equalTo(user_name.mas_centerY);
    }];
    
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(22);
    title_label.text = @"这是大标题啊大标题";
    [self addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(user_name.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    self.content_label = [[YYLabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.textColor = SetColor(104, 104, 104, 1);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.content_label.numberOfLines = 0;
    [self addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
//        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
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
