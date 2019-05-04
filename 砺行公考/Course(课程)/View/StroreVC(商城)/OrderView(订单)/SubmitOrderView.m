//
//  SubmitOrderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SubmitOrderView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation SubmitOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    self.all_choose_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.all_choose_button.titleLabel.font = SetFont(12);
    [self.all_choose_button setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [self.all_choose_button setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateNormal];
    [self.all_choose_button setTitle:@"全选" forState:UIControlStateNormal];
    [self addSubview:self.all_choose_button];
    self.all_choose_button.hidden = YES;
    [self.all_choose_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    self.submit_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submit_button.titleLabel.font = SetFont(18);
    self.submit_button.backgroundColor = SetColor(191, 191, 191, 1);
    [self.submit_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.submit_button setTitle:@"去支付" forState:UIControlStateNormal];
    [self.submit_button addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submit_button];
    [self.submit_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(120);
    }];
    
    self.price_label = [[UILabel alloc] init];
    self.price_label.font = SetFont(16);
    self.price_label.textColor = SetColor(242, 68, 89, 1);
    self.price_label.text = @"￥328.00";
    [self addSubview:self.price_label];
    [self.price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(18);
        make.right.equalTo(weakSelf.submit_button.mas_left).offset(-10);
    }];
    
    self.left_label = [[UILabel alloc] init];
    self.left_label.font = SetFont(16);
    self.left_label.text = @"实付款：";
    [self addSubview:self.left_label];
    [self.left_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.price_label.mas_top);
        make.right.equalTo(weakSelf.price_label.mas_left).offset(0);
    }];
    
    self.discounts_label = [[UILabel alloc] init];
    self.discounts_label.font = SetFont(10);
    self.discounts_label.textColor = SetColor(242, 68, 89, 1);
    self.discounts_label.text = @"优惠 ￥600";
    [self addSubview:self.discounts_label];
    self.discounts_label.hidden = YES;
    [self.discounts_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.price_label.mas_bottom).offset(5);
        make.right.equalTo(weakSelf.price_label.mas_right);
    }];
}

- (void)setIsUpdateLayout:(BOOL)isUpdateLayout {
    _isUpdateLayout = isUpdateLayout;
    __weak typeof(self) weakSelf = self;
    if (_isUpdateLayout) {
        [self.price_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top).offset(10);
        }];
        self.all_choose_button.hidden = NO;
        self.discounts_label.hidden = NO;
    }else {
        [self.price_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top).offset(18);
        }];
        self.all_choose_button.hidden = YES;
        self.discounts_label.hidden = YES;
    }
}

- (void)touchAction {
    if ([_delegate respondsToSelector:@selector(touchSubmitButtonAction)]) {
        [_delegate touchSubmitButtonAction];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
