//
//  EvaluteHeaderReusableView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "EvaluteHeaderReusableView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "StarsView.h"

@interface EvaluteHeaderReusableView ()

@property (nonatomic, strong) StarsView *stars;

@end

@implementation EvaluteHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    UIImageView *left_image = [[UIImageView alloc] init];
    left_image.backgroundColor = RandomColor;
    ViewRadius(left_image, 5.0);
    [self addSubview:left_image];
    [left_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(14);
    title_label.numberOfLines = 0;
    title_label.text = @" 长效班会员：砺行教育全app所有权限全部享受";
    [self addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(left_image.mas_top);
        make.left.equalTo(left_image.mas_right).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
    
    UILabel *category_label = [[UILabel alloc] init];
    category_label.font = SetFont(12);
    category_label.textColor = DetailTextColor;
    category_label.text = @"分类：纯网络班学员";
    [self addSubview:category_label];
    [category_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(left_image.mas_bottom);
        make.left.equalTo(title_label.mas_left);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(left_image.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @"为宝贝打分";
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    self.stars = [[StarsView alloc] initWithStarSize:CGSizeMake(20, 20) space:(SCREENBOUNDS.width - 220) / 4 numberOfStar:5];
    self.stars.score = 1.0;
    self.stars.supportDecimal = NO;
    [self addSubview:self.stars];
    [self.stars mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(SCREENBOUNDS.width - 120);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.stars.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(back_view, 8.0);
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.left.equalTo(line1.mas_left).offset(20);
        make.right.equalTo(line1.mas_right).offset(-20);
        make.height.mas_equalTo(180);
    }];
    
    UITextView *textview = [[UITextView alloc] init];
    textview.backgroundColor = back_view.backgroundColor;
    textview.font = SetFont(14);
    textview.textColor = DetailTextColor;
    textview.text = @"宝贝满足你的期待吗？说说它的优点和美中不足的地方吧～";
    [back_view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
}

@end
