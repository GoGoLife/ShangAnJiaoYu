//
//  MyOrderDetailsHeaderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "MyOrderDetailsHeaderView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation MyOrderDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.backgroundColor = SetColor(48, 132, 252, 1);
    typeLabel.font = SetFont(16);
    typeLabel.textColor = WhiteColor;
    typeLabel.text = @"   买家已付款";
    [self addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(58);
    }];
    
    //地址信息
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingwei"]];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLabel.mas_bottom).offset(15);
        make.left.equalTo(typeLabel.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 24));
    }];
    
    UILabel *pay_user_info = [[UILabel alloc] init];
    pay_user_info.font = SetFont(14);
    pay_user_info.text = @"收货人：陈璐 13736179920";
    [self addSubview:pay_user_info];
    [pay_user_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLabel.mas_bottom).offset(10);
        make.left.equalTo(image.mas_right).offset(10);
    }];
    
    UILabel *address_info = [[UILabel alloc] init];
    address_info.font = SetFont(12);
    address_info.numberOfLines = 0;
    address_info.text = @"收货地址：浙江省宁波市鄞州区中河街道飞虹新村二区11幢207";
    [self addSubview:address_info];
    [address_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pay_user_info.mas_bottom).offset(10);
        make.left.equalTo(pay_user_info.mas_left);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(address_info.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = SetColor(255, 85, 0, 1);
    label.text = @"买家已付款";
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
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
