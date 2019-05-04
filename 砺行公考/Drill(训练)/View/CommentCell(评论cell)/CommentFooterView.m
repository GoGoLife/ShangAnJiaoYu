//
//  CommentFooterView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/25.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CommentFooterView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation CommentFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    self.dotParise_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dotParise_button.titleLabel.font = SetFont(12);
    [self.dotParise_button setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [self.dotParise_button setImage:[UIImage imageNamed:@"parise_button"] forState:UIControlStateNormal];
    [self.dotParise_button setTitle:@"1212" forState:UIControlStateNormal];
    [self addSubview:self.dotParise_button];
    [self.dotParise_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    self.comment_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.comment_button setImage:[UIImage imageNamed:@"comment_button"] forState:UIControlStateNormal];
    [self.comment_button addTarget:self action:@selector(touchCommentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.comment_button];
    [self.comment_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.dotParise_button.mas_left).offset(-20);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (void)setParise_numbers_string:(NSString *)parise_numbers_string {
    _parise_numbers_string = parise_numbers_string;
    [self.dotParise_button setTitle:_parise_numbers_string forState:UIControlStateNormal];
}

//点击评论按钮
- (void)touchCommentButtonAction {
    if ([_delegate respondsToSelector:@selector(touchCommentButtonTargetAction:)]) {
        [_delegate touchCommentButtonTargetAction:self.section];
    }
}

@end
