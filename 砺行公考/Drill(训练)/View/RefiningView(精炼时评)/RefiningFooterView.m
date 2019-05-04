//
//  RefiningFooterView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "RefiningFooterView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation RefiningFooterView

+ (instancetype)creatFooterViewWithModel:(RefiningModel *)model Frame:(CGRect)frame {
    RefiningFooterView *footer = [[RefiningFooterView alloc] initWithFrame:frame];
    [footer creatFooterView:model];
    return footer;
}

- (void)creatFooterView:(RefiningModel *)model {
    __weak typeof(self) weakSelf = self;
    
    self.teacher_review_label = [[UILabel alloc] init];
    self.teacher_review_label.font = SetFont(16);
    self.teacher_review_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 90;
    self.teacher_review_label.numberOfLines = 0;
    self.teacher_review_label.text = model.teacher_review;//@"按揭房圣诞节福利卡按揭房圣诞节福利卡按揭房圣诞节福利卡按揭房圣诞节福利卡按揭房圣诞节福利卡";
    [self addSubview:self.teacher_review_label];
    [self.teacher_review_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(70);
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
    
    self.praise_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.praise_button.backgroundColor = WhiteColor;
    self.praise_button.titleLabel.font = SetFont(12);
    [self.praise_button setTitleColor:SetColor(191, 19, 191, 1) forState:UIControlStateNormal];
    [self.praise_button setImage:[UIImage imageNamed:@"parise_button"] forState:UIControlStateNormal];
    [self.praise_button setTitle:@"2019" forState:UIControlStateNormal];
    [self.praise_button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [self addSubview:self.praise_button];
    [self.praise_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    [self.praise_button addTarget:self action:@selector(touchPraiseAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.share_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.share_button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self addSubview:self.share_button];
    [self.share_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.praise_button.mas_left).offset(-10);
        make.centerY.equalTo(weakSelf.praise_button.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    self.share_button.hidden = YES;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

- (void)touchPraiseAction {
    if ([_delegate respondsToSelector:@selector(touchPraiseButtonAction:withSection:)]) {
        [_delegate touchPraiseButtonAction:self.praise_button withSection:self.section];
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
