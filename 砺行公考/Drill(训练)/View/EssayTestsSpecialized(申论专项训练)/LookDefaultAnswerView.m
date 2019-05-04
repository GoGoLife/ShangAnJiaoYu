//
//  LookDefaultAnswerView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "LookDefaultAnswerView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation LookDefaultAnswerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = SetColor(74, 74, 74, 0.8);
        [self initViewUI];
    }
    return self;
}

StringHeight()
- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = WhiteColor;
    ViewRadius(back_view, 5.0);
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(210);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = SetColor(67, 154, 247, 1);
    label.text = @"参考答案";
    [back_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [back_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [cancel addTarget:self action:@selector(touchCancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.backgroundColor = WhiteColor;
    self.content_label.font = SetFont(16);
    self.content_label.textColor = SetColor(67, 154, 247, 1);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.content_label.numberOfLines = 0;
    [back_view addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(back_view.mas_right).offset(-20);
    }];
}

- (void)touchCancelAction {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
