//
//  MyOrderDetailsFooterView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "MyOrderDetailsFooterView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation MyOrderDetailsFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *returnShop = [UIButton buttonWithType:UIButtonTypeCustom];
    returnShop.backgroundColor = back_view.backgroundColor;
    returnShop.titleLabel.font = SetFont(14);
    [returnShop setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [returnShop setTitle:@"货款全退" forState:UIControlStateNormal];
    ViewBorderRadius(returnShop, 15.0, 1.0, DetailTextColor);
    [back_view addSubview:returnShop];
    [returnShop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.centerY.equalTo(back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    //商品金额
    UILabel *price = [[UILabel alloc] init];
    price.font = SetFont(14);
    price.text = @"商品金额";
    [self addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
    }];
    
    self.price_content_label = [[UILabel alloc] init];
    self.price_content_label.font = SetFont(14);
    self.price_content_label.text = @"￥328.00";
    [self addSubview:self.price_content_label];
    [self.price_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(price.mas_centerY);
    }];
    
    //商品运费
    UILabel *freight = [[UILabel alloc] init];
    freight.font = SetFont(14);
    freight.text = @"运费";
    [self addSubview:freight];
    [freight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price.mas_bottom).offset(20);
        make.left.equalTo(price.mas_left);
    }];
    
    self.freight_content_label = [[UILabel alloc] init];
    self.freight_content_label.font = SetFont(14);
    self.freight_content_label.text = @"+￥5.00";
    [self addSubview:self.freight_content_label];
    [self.freight_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.price_content_label.mas_right);
        make.centerY.equalTo(freight.mas_centerY);
    }];
    
    //立减
    UILabel *remission = [[UILabel alloc] init];
    remission.font = SetFont(14);
    remission.text = @"立减";
    [self addSubview:remission];
    [remission mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(freight.mas_bottom).offset(20);
        make.left.equalTo(price.mas_left);
    }];
    
    self.remission_content_label = [[UILabel alloc] init];
    self.remission_content_label.font = SetFont(14);
    self.remission_content_label.text = @"-￥220.00";
    [self addSubview:self.remission_content_label];
    [self.remission_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.price_content_label.mas_right);
        make.centerY.equalTo(remission.mas_centerY);
    }];
    
    //合计
    UILabel *allLabel = [[UILabel alloc] init];
    allLabel.font = SetFont(14);
    allLabel.text = @"共3件商品 合计：￥989.00（含运费：￥5.00）";
    [self addSubview:allLabel];
    [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remission.mas_bottom).offset(20);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
    
    //分割线
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    //联系客服   呼叫客服
    CGFloat button_width = SCREENBOUNDS.width / 2;
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.titleLabel.font = SetFont(14);
    [chatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chatButton setTitle:@"联系客服" forState:UIControlStateNormal];
    [self addSubview:chatButton];
    [chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(weakSelf.mas_left);
        make.size.mas_equalTo(CGSizeMake(button_width, 50));
    }];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.titleLabel.font = SetFont(14);
    [phoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [phoneButton setTitle:@"呼叫客服" forState:UIControlStateNormal];
    [self addSubview:phoneButton];
    [phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(chatButton.mas_right);
        make.size.mas_equalTo(CGSizeMake(button_width, 50));
    }];
    
    //分割线
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chatButton.mas_bottom);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    //交易的订单信息
    UITextField *orderNumber = [[UITextField alloc] init];
    orderNumber.enabled = NO;
    orderNumber.font = SetFont(12);
    orderNumber.textColor = DetailTextColor;
    
    CGFloat width = [self calculateRowWidth:@"订单编号：" withFont:12];
    //左侧label
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, width, 20)];
    numberLabel.font = SetFont(12);
    numberLabel.textColor = DetailTextColor;
    numberLabel.text = @"订单编号：";
    
    orderNumber.leftViewMode = UITextFieldViewModeAlways;
    orderNumber.leftView = numberLabel;
    
    [self addSubview:orderNumber];
    [orderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    //支付宝交易号
    UITextField *payNumber = [[UITextField alloc] init];
    payNumber.enabled = NO;
    payNumber.font = SetFont(12);
    payNumber.textColor = DetailTextColor;
    
    //左侧label
    UILabel *payLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, width, 20)];
    payLabel.font = SetFont(12);
    payLabel.textColor = DetailTextColor;
    payLabel.text = @"交易编号：";
    
    payNumber.leftViewMode = UITextFieldViewModeAlways;
    payNumber.leftView = payLabel;
    
    [self addSubview:payNumber];
    [payNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNumber.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    //创建时间
    UITextField *creatTime = [[UITextField alloc] init];
    creatTime.enabled = NO;
    creatTime.font = SetFont(12);
    creatTime.textColor = DetailTextColor;
    
    //左侧label
    UILabel *creatLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, width, 20)];
    creatLabel.font = SetFont(12);
    creatLabel.textColor = DetailTextColor;
    creatLabel.text = @"床架时间：";
    
    creatTime.leftViewMode = UITextFieldViewModeAlways;
    creatTime.leftView = creatLabel;
    
    [self addSubview:creatTime];
    [creatTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payNumber.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    //付款时间
    UITextField *payTime = [[UITextField alloc] init];
    payTime.enabled = NO;
    payTime.font = SetFont(12);
    payTime.textColor = DetailTextColor;
    
    //左侧label
    UILabel *payTimeLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, width, 20)];
    payTimeLabel.font = SetFont(12);
    payTimeLabel.textColor = DetailTextColor;
    payTimeLabel.text = @"付款时间：";
    
    payTime.leftViewMode = UITextFieldViewModeAlways;
    payTime.leftView = payTimeLabel;
    
    [self addSubview:payTime];
    [payTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(creatTime.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.height.mas_equalTo(20);
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
