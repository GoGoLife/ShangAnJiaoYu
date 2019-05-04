//
//  MyOrderFooterView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "MyOrderFooterView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface MyOrderFooterView ()

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation MyOrderFooterView

- (instancetype)initWithFrame:(CGRect)frame withActionButtonTitlesArray:(NSArray *)titles {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI:titles];
        self.titleArray = titles;
    }
    return self;
}

StringWidth()
- (void)initViewUI:(NSArray *)titles {
    self.shop_finish_content = [[UILabel alloc] init];
    self.shop_finish_content.font = SetFont(12);
    self.shop_finish_content.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.shop_finish_content];
    __weak typeof(self) weakSelf = self;
    [self.shop_finish_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.shop_finish_content.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat finishWidth = 0.0;
    NSInteger tag = 0;
    for (NSDictionary *titleDic in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(14);
        UIColor *buttonColor = SetColor([titleDic[@"R"] integerValue], [titleDic[@"G"] integerValue], [titleDic[@"B"] integerValue], 1);
        [button setTitleColor: buttonColor forState:UIControlStateNormal];
        [button setTitle:titleDic[@"title"] forState:UIControlStateNormal];
        ViewBorderRadius(button, 15.0, 1.0, buttonColor);
        button.tag = tag;
        [button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        CGFloat width = [self calculateRowWidth:titleDic[@"title"] withFont:14] + 20;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.shop_finish_content.mas_bottom).offset(20);
            make.right.equalTo(weakSelf.mas_right).offset(-20 - finishWidth);
            make.size.mas_equalTo(CGSizeMake(width, 30.0));
        }];
        finishWidth = finishWidth + width + 20;
        tag++;
    }
}

- (void)touchButtonAction:(UIButton *)sender {
    NSInteger index = sender.tag;
    if ([_delegate respondsToSelector:@selector(touchButtonTargetAction:)]) {
        [_delegate touchButtonTargetAction:self.titleArray[index][@"title"]];
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
