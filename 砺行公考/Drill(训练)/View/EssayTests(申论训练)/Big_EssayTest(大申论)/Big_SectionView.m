//
//  Big_SectionView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Big_SectionView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation Big_SectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(big_touchSectionAction)];
        [self addGestureRecognizer:tap];
        [self creatViewUI];
    }
    return self;
}

- (void)creatViewUI {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(back_view, 8.0);
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.backgroundColor = ButtonColor;
    self.leftLabel.font = SetFont(12);
    self.leftLabel.textColor = WhiteColor;
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    ViewRadius(self.leftLabel, 10.0);
    [back_view addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back_view.mas_left).offset(20);
        make.centerY.equalTo(back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = SetColor(192, 192, 192, 1);
    label.text = @"点击选择采点";
    [back_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(back_view.mas_centerX);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
}

- (void)big_touchSectionAction {
    if ([_delegate respondsToSelector:@selector(touchSectionPushVC:)]) {
        [_delegate touchSectionPushVC:self.section];
    }
}

@end
