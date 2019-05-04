//
//  OrderTwoFooterView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/19.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OrderTwoFooterView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation OrderTwoFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    //配送方式
    __weak typeof(self) weakSelf = self;
    UILabel *mode_label = [[UILabel alloc] init];
    mode_label.font = SetFont(14);
    mode_label.text = @"配送方式";
    [self addSubview:mode_label];
    [mode_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(20);
        make.left.equalTo(weakSelf.mas_left).offset(20);
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
    right_image.image = [UIImage imageNamed:@"right"];
    [self addSubview:right_image];
    [right_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mode_content_label.mas_right).offset(10);
        make.centerY.equalTo(mode_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 16));
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
        make.top.equalTo(mode_label.mas_bottom).offset(10);
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
