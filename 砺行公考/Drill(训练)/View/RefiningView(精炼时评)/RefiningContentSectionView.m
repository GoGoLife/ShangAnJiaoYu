//
//  RefiningContentSectionView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/5/2.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "RefiningContentSectionView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface RefiningContentSectionView ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation RefiningContentSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.label = [[UILabel alloc] init];
    self.label.font = SetFont(18);
    [self addSubview:self.label];
    [self addSubview:self.label];
    __weak typeof(self) weakSelf = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.button addTarget:self action:@selector(touchButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchButtonAction {
    self.touchButtonChangeOnStatusAction(self.section);
}

- (void)setIsShowButton:(BOOL)isShowButton {
    _isShowButton = isShowButton;
    if (_isShowButton) {
        self.button.hidden = NO;
    }else {
        self.button.hidden = YES;
    }
}

@end
