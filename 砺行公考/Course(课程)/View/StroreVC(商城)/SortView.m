//
//  SortView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SortView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation SortView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
//        [self initViewUI];
    }
    return self;
}

- (instancetype)init {
    if (self == [super init]) {
//        [self initViewUI];
    }
    return self;
}

+ (instancetype)creatSortViewWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray {
    SortView *sortView = [[SortView alloc] init];
    [sortView initViewUIWithTitle:titleArray];
    return sortView;
}

- (void)initViewUIWithTitle:(NSArray *)titleArray {
    CGFloat button_width = SCREENBOUNDS.width / titleArray.count;
    for (NSInteger index = 0; index < titleArray.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index + 100;
        button.titleLabel.font = SetFont(14);
        [button setTitleColor:DetailTextColor forState:UIControlStateNormal];
        [button setTitle:titleArray[index] forState:UIControlStateNormal];
        [self addSubview:button];
        __weak typeof(self) weakSelf = self;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top);
            make.left.equalTo(weakSelf.mas_left).offset(button_width * index);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.width.mas_equalTo(button_width);
        }];
    }
}

@end
