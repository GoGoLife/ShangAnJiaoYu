//
//  CurrentQuestionInfoView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/19.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CurrentQuestionInfoView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation CurrentQuestionInfoView

/**
 初始化view

 @param frame frame
 @param info 字符串信息  (格式：title++++++require)
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame withInfoString:(NSString *)info {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = SetColor(155, 155, 155, 0.8);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCurrentView)];
        [self addGestureRecognizer:tap];
        
        NSArray *array = [info componentsSeparatedByString:@"++++++"];
        [self creatViewUIWithInfoArray:array];
    }
    return self;
}

StringHeight()
- (void)creatViewUIWithInfoArray:(NSArray *)infoArray {
    CGFloat title_height = [self calculateRowHeight:infoArray[0] fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    CGFloat require_height = [self calculateRowHeight:infoArray[1] fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = WhiteColor;
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(title_height + require_height + 50.0);
    }];
    
    UILabel *require_label = [[UILabel alloc] init];
    require_label.backgroundColor = WhiteColor;
    require_label.font = SetFont(14);
    require_label.textColor = SetColor(74, 74, 74, 1);
    require_label.numberOfLines = 0;
    require_label.text = infoArray[1];
    [back_view addSubview:require_label];
    [require_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back_view.mas_left).offset(20);
        make.bottom.equalTo(back_view.mas_bottom).offset(-20);
        make.right.equalTo(back_view.mas_right).offset(-20);
    }];
    
    UILabel *title_label = [[UILabel alloc] init];
    title_label.backgroundColor = WhiteColor;
    title_label.font = SetFont(16);
    title_label.numberOfLines = 0;
    title_label.text = infoArray[0];
    [back_view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back_view.mas_left).offset(20);
        make.bottom.equalTo(require_label.mas_top).offset(-20);
        make.right.equalTo(back_view.mas_right).offset(-20);
    }];
}

- (void)removeCurrentView {
    [self removeFromSuperview];
}

@end
