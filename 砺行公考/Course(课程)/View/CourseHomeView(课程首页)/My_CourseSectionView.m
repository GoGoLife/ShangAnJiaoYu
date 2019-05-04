//
//  My_CourseSectionView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "My_CourseSectionView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation My_CourseSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = SetColor(246, 246, 246, 1);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSelfAction)];
        [self addGestureRecognizer:tap];
        [self creatViewUI];
    }
    return self;
}

- (void)creatViewUI {
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = WhiteColor;
    [self addSubview:back_view];
    __weak typeof(self) weakSelf = self;
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(14);
//    self.title_label.text = @"言语理解的基础轮·课程包";
    [back_view addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(15);
        make.left.equalTo(back_view.mas_left).offset(13);
    }];
    
    self.detail_label = [[UILabel alloc] init];
    self.detail_label.font = SetFont(12);
//    self.detail_label.text = @"言语·初级·4课时";
    [back_view addSubview:self.detail_label];
    [self.detail_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.title_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.title_label.mas_left);
    }];
    
    self.finish_label = [[UILabel alloc] init];
    self.finish_label.font = SetFont(10);
//    self.finish_label.text = @"课时完成度 78%";
    [back_view addSubview:self.finish_label];
    [self.finish_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detail_label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.title_label.mas_left);
    }];
    
    self.slider = [[UISlider alloc] init];
    self.slider.backgroundColor = SetColor(246, 246, 246, 1);
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 100;
//    [self.slider setValue:70 animated:YES];
    self.slider.thumbTintColor = [UIColor clearColor];
    [back_view addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.finish_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.finish_label.mas_left);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.height.mas_equalTo(6);
    }];
}

//点击self  执行方法
- (void)touchSelfAction {
    if ([_delegate respondsToSelector:@selector(touchSelfTargetAction:)]) {
        [_delegate touchSelfTargetAction:self.section];
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
