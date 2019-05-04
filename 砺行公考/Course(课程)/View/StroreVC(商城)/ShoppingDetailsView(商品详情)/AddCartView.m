//
//  AddCartView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AddCartView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation AddCartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initViewUI];
    }
    return self;
}


- (void)initViewUI {
    CGFloat width = SCREENBOUNDS.width / 3;
    self.kf_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kf_button.tag = 100;
    self.kf_button.titleLabel.font = SetFont(10);
    [self.kf_button setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [self.kf_button setTitle:@"客服" forState:UIControlStateNormal];
    [self.kf_button setImage:[UIImage imageNamed:@"kefu"] forState:UIControlStateNormal];
    [self initButton:self.kf_button];
    [self.kf_button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.kf_button];
    __weak typeof(self) weakSelf = self;
    [self.kf_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.left.equalTo(weakSelf.mas_left);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.width.mas_equalTo(width / 2);
    }];
    
    self.cart_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cart_button.tag = 200;
    self.cart_button.titleLabel.font = SetFont(10);
    [self.cart_button setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [self.cart_button setTitle:@"购物车" forState:UIControlStateNormal];
    [self.cart_button setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [self initButton:self.cart_button];
    [self.cart_button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cart_button];
    [self.cart_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.left.equalTo(weakSelf.kf_button.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.width.mas_equalTo(width / 2);
    }];
    
    self.add_cart_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.add_cart_button.tag = 300;
    self.add_cart_button.frame = FRAME(width + 10, 10, width - 20, 40);
    self.add_cart_button.titleLabel.font = SetFont(14);
    self.add_cart_button.backgroundColor = DetailTextColor;
    [self.add_cart_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.add_cart_button setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self setButtonBounds:self.add_cart_button];
    [self.add_cart_button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.add_cart_button];
    
    self.pay_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pay_button.tag = 400;
    self.pay_button.frame = FRAME(CGRectGetMaxX(self.add_cart_button.frame), 10, width - 20, 40);
    self.pay_button.titleLabel.font = SetFont(14);
    self.pay_button.backgroundColor = SetColor(48, 132, 252, 1);
    [self.pay_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.pay_button setTitle:@"立即购买" forState:UIControlStateNormal];
    [self setButtonOtherBounds:self.pay_button];
    [self.pay_button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pay_button];
}

//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    float  spacing = 15;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height) - 5, 0.0 - 5, 0.0 - 5, - titleSize.width - 5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(10, - imageSize.width - 16, - (totalHeight - titleSize.height), 0);
}

//设置button 左下  左上  设置圆角
- (void)setButtonBounds:(UIButton *)button {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

//设置button 右下  右上  设置圆角
- (void)setButtonOtherBounds:(UIButton *)button {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

- (void)touchButtonAction:(UIButton *)button {
    NSInteger index = button.tag;
    if ([_delegate respondsToSelector:@selector(touchButtonTargetAction:)]) {
        [_delegate touchButtonTargetAction:index];
    }
}

@end
