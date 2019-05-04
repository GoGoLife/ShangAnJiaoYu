//
//  AnswerResultView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AnswerResultView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface AnswerResultView()

@end

@implementation AnswerResultView

- (instancetype)initWithFrame:(CGRect)frame withCordArray:(NSArray *)array {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = SetColor(127, 127, 127, 0.8);
        [self UIWithArray:array];
    }
    return self;
}

- (void)UIWithArray:(NSArray *)array {
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 180) / 5;
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = WhiteColor;
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf);
        make.height.mas_equalTo(width * 4 + 80 + 44 + 170);
    }];
    
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = SetFont(14);
    dateLabel.text = @"答题时间：08:32";
    [back_view addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.centerY.equalTo(dateLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.reactionView = [[ChainReactionView alloc] initWithFrame:CGRectZero withNameArray:array];
    [back_view addSubview:self.reactionView];
    [self.reactionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(0);
        make.left.equalTo(back_view.mas_left).offset(0);
        make.right.equalTo(back_view.mas_right).offset(0);
        make.height.mas_equalTo(width * 4 + 80 + 44);
    }];
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    [save setTitle:@"退出" forState:UIControlStateNormal];
    [save setTitleColor:WhiteColor forState:UIControlStateNormal];
    save.backgroundColor = ButtonColor;
    ViewRadius(save, 25.0);
    [save addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:save];
    [save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.reactionView.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake((SCREENBOUNDS.width - 55) / 2, 50));
    }];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"交卷并查看结果" forState:UIControlStateNormal];
    [submit setTitleColor:ButtonColor forState:UIControlStateNormal];
    [submit setBackgroundColor:WhiteColor];
    ViewBorderRadius(submit, 25.0, 1.0, ButtonColor);
    [submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(save.mas_top);
        make.left.equalTo(save.mas_right).offset(15);
        make.size.equalTo(save);
    }];
}

//有值的时候   赋值操作
- (void)setData_array:(NSArray *)data_array {
    _data_array = data_array;
    self.reactionView.data_array = _data_array;
}

- (void)removeView {
    [self removeFromSuperview];
}

//保存进度并退出
- (void)saveAction {
    self.touchSaveActionBlock();
}

//交卷并查看结果
- (void)submitAction {
    self.touchSubmitActionBlock();
}

@end
