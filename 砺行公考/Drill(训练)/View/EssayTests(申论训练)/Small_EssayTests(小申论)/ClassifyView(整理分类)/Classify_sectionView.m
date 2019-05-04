//
//  Classify_sectionView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Classify_sectionView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface Classify_sectionView()

@property (nonatomic, strong) UIView *back_view;

@property (nonatomic, strong) UILabel *left_label;

@end

@implementation Classify_sectionView
StringWidth()

- (instancetype)initWithFrame:(CGRect)frame withIndexPath:(NSInteger)section {
    if (self == [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSelfAction)];
        [self addGestureRecognizer:ges];
        [self setViewUIWithIndexPath:section];
    }
    return self;
}

- (void)setViewUIWithIndexPath:(NSInteger)section {
    __weak typeof(self) weakSelf = self;
    self.back_view = [[UIView alloc] init];
    self.back_view.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(self.back_view, 8.0);
    [self addSubview:self.back_view];
    [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    self.left_label = [[UILabel alloc] init];
    self.left_label.font = SetFont(12);
    self.left_label.backgroundColor = SetColor(48, 132, 252, 1);
    self.left_label.textColor = WhiteColor;
    ViewRadius(self.left_label, 10.0);
    self.left_label.textAlignment = NSTextAlignmentCenter;
    NSString *left_string = self.isBlock ? [NSString stringWithFormat:@"第%ld段", section + 1] : [NSString stringWithFormat:@"%ld", section + 1];
    self.left_label.text = left_string;
    [self.back_view addSubview:self.left_label];
    CGFloat width = self.isBlock ? [self calculateRowWidth:left_string withFont:12] + 20 : 20;
    [self.left_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.back_view.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, 20));
    }];
    
    
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(14);
    title_label.textColor = DetailTextColor;
    title_label.text = @"点击选择采点";
    [self.back_view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.back_view.mas_centerX);
        make.centerY.equalTo(weakSelf.back_view.mas_centerY);
    }];
}

- (void)setIsBlock:(BOOL)isBlock {
    __weak typeof(self) weakSelf = self;
    NSString *left_string = isBlock ? [NSString stringWithFormat:@"第%ld段", self.section + 1] : [NSString stringWithFormat:@"%ld", self.section + 1];
    self.left_label.text = left_string;
    CGFloat width = isBlock ? [self calculateRowWidth:left_string withFont:12] + 20 : 20;
    [self.left_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.back_view.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, 20));
    }];
}

//代理传递  点击的是哪一个section
- (void)touchSelfAction {
    if ([_delegate respondsToSelector:@selector(touchSectionAction:)]) {
        [_delegate touchSectionAction:self.section];
    }
}

@end
