//
//  OrderFooterView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OrderFooterView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation OrderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    UILabel *pay_number_label = [[UILabel alloc] init];
    pay_number_label.font = SetFont(14);
    pay_number_label.text = @"购买数量";
    [self addSubview:pay_number_label];
    __weak typeof(self) weakSelf = self;
    [pay_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(15);
        make.left.equalTo(weakSelf.mas_left).offset(20);
    }];
    
    UIButton *add_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [add_button setImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
    ViewRadius(add_button, 12.0);
    [self addSubview:add_button];
    [add_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.centerY.equalTo(pay_number_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    UILabel *number_label = [[UILabel alloc] init];
    number_label.textAlignment = NSTextAlignmentCenter;
    number_label.font = SetFont(14);
    number_label.textColor = DetailTextColor;
    number_label.text = @"1";
    ViewBorderRadius(number_label, 5.0, 1.0, SetColor(246, 246, 246, 1));
    [self addSubview:number_label];
    [number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(add_button.mas_left).offset(-10);
        make.centerY.equalTo(pay_number_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 34));
    }];
    
    UIButton *less_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [less_button setImage:[UIImage imageNamed:@"less_button"] forState:UIControlStateNormal];
    ViewRadius(less_button, 12.0);
    [self addSubview:less_button];
    [less_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(number_label.mas_left).offset(-10);
        make.centerY.equalTo(pay_number_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    //配送方式
    UILabel *mode_label = [[UILabel alloc] init];
    mode_label.font = SetFont(14);
    mode_label.text = @"配送方式";
    [self addSubview:mode_label];
    [mode_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pay_number_label.mas_bottom).offset(30);
        make.left.equalTo(pay_number_label.mas_left);
    }];
    
    //配送方式内容
    UILabel *mode_content_label = [[UILabel alloc] init];
    mode_content_label.font = SetFont(14);
    mode_content_label.text = @"快递  免邮";
    [self addSubview:mode_content_label];
    [mode_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-46);
        make.centerY.equalTo(mode_label.mas_centerY);
    }];
    
    UIImageView *right_image = [[UIImageView alloc] init];
    right_image.backgroundColor = RandomColor;
    [self addSubview:right_image];
    [right_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mode_content_label.mas_right).offset(10);
        make.centerY.equalTo(mode_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    UITextField *message_content_field = [[UITextField alloc] init];
    message_content_field.textAlignment = NSTextAlignmentLeft;
    message_content_field.font = SetFont(14);
    message_content_field.placeholder = @"[选填]每个留言我们都会仔细查看欧～";
    
    CGFloat width = [self calculateRowWidth:@"卖家留言：" withFont:14];
    UILabel *message_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, width, 20)];
    message_label.font = SetFont(14);
    message_label.text = @"卖家留言：";
    message_content_field.leftView = message_label;
    message_content_field.leftViewMode = UITextFieldViewModeAlways;
    
    [self addSubview:message_content_field];
    [message_content_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mode_label.mas_bottom).offset(30);
        make.left.equalTo(mode_label.mas_left);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
}
StringWidth()

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
