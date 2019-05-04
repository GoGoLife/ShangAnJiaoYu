//
//  ChangeBookIndexView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/11.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ChangeBookIndexView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation ChangeBookIndexView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI {
    //宽度
    CGFloat button_width = (SCREENBOUNDS.width - 2) / 3;
    
    UIButton *delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
    delete_button.tag = 100;
    delete_button.titleLabel.font = SetFont(10);
    [delete_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [delete_button setImage:[UIImage imageNamed:@"book_delete"] forState:UIControlStateNormal];
    [delete_button setTitle:@"删除" forState:UIControlStateNormal];
    [self initButton:delete_button];
    [delete_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delete_button];
    __weak typeof(self) weakSelf = self;
    [delete_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.width.mas_equalTo(button_width);
        make.height.equalTo(weakSelf.mas_height);
    }];
    
    UIButton *move_button = [UIButton buttonWithType:UIButtonTypeCustom];
    move_button.tag = 200;
    move_button.titleLabel.font = SetFont(10);
    [move_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [move_button setImage:[UIImage imageNamed:@"book_move"] forState:UIControlStateNormal];
    [move_button setTitle:@"移动至" forState:UIControlStateNormal];
    [self initButton:move_button];
    [move_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:move_button];
    [move_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(delete_button.mas_right);
        make.width.mas_equalTo(button_width);
        make.height.equalTo(weakSelf.mas_height);
    }];
    
    UIButton *copy_button = [UIButton buttonWithType:UIButtonTypeCustom];
    copy_button.tag = 300;
    copy_button.titleLabel.font = SetFont(10);
    [copy_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [copy_button setImage:[UIImage imageNamed:@"book_copy"] forState:UIControlStateNormal];
    [copy_button setTitle:@"复制至" forState:UIControlStateNormal];
    [self initButton:copy_button];
    [copy_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:copy_button];
    [copy_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(move_button.mas_right);
        make.width.mas_equalTo(button_width);
        make.height.equalTo(weakSelf.mas_height);
    }];
}

- (void)buttonAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(ChangeBookIndexAction:)]) {
        [_delegate ChangeBookIndexAction:button.tag];
    }
}


//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    float  spacing = 15;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height) - 5, 0.0 - 5, 0.0 - 5, - titleSize.width - 5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(10, - imageSize.width - 16, - (totalHeight - titleSize.height), 0);
}
@end
