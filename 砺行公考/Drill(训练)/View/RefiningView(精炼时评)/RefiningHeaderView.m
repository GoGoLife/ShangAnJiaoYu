//
//  RefiningHeaderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "RefiningHeaderView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation RefiningHeaderView

+ (instancetype)creatHeaderViewWithModel:(RefiningModel *)model Frame:(CGRect)frame {
    RefiningHeaderView *header = [[RefiningHeaderView alloc] initWithFrame:frame];
    [header creatViewUI:model];
    return header;
}

- (void)creatViewUI:(RefiningModel *)model {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSelfAction:)];
    [self addGestureRecognizer:ges];
    
    __weak typeof(self) weakSelf = self;
    self.recommend_field = [[UITextField alloc] init];
    self.recommend_field.enabled = NO;
    self.recommend_field.font = SetFont(12);
    self.recommend_field.textColor = SetColor(242, 68, 89, 1);
    self.recommend_field.text = @"   讲师推荐";
    
    UIImageView *left_image = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 12, 17)];
    left_image.image = [UIImage imageNamed:@"fire"];
    self.recommend_field.leftView = left_image;
    self.recommend_field.leftViewMode = UITextFieldViewModeAlways;
    
    [self addSubview:self.recommend_field];
    [self.recommend_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
    
    self.header_imageview = [[UIImageView alloc] init];
    [self.header_imageview sd_setImageWithURL:[NSURL URLWithString:model.header_url] placeholderImage:[UIImage imageNamed:@"date"]];
    self.header_imageview.layer.masksToBounds = YES;
    self.header_imageview.layer.cornerRadius = 20.0;
    [self addSubview:self.header_imageview];
    [self.header_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.recommend_field.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(14);
    self.name_label.textColor = DetailTextColor;
    self.name_label.text = model.name;
    [self addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_imageview.mas_top);
        make.left.equalTo(weakSelf.header_imageview.mas_right).offset(10);
    }];
    
    self.time_label = [[UILabel alloc] init];
    self.time_label.font = SetFont(12);
    self.time_label.textColor = SetColor(191, 191, 191, 1);
    self.time_label.text = model.time;
    [self addSubview:self.time_label];
    [self.time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.name_label.mas_centerY);
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(16);
    self.content_label.textColor = SetColor(74, 74, 74, 1);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 90;
    self.content_label.numberOfLines = 0;
    self.content_label.text = model.content_string;
    [self addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.name_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.name_label.mas_left);
        make.right.equalTo(weakSelf.time_label.mas_right);
    }];
}

- (void)touchSelfAction:(UITapGestureRecognizer *)ges {
    if ([_delegate respondsToSelector:@selector(returnCurrentTouchIndex:)]) {
        [_delegate returnCurrentTouchIndex:self.section];
    }
}

@end
