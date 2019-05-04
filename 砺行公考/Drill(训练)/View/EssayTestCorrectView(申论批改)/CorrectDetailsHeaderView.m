//
//  CorrectDetailsHeaderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/24.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CorrectDetailsHeaderView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation CorrectDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    self.test_title_label = [[UILabel alloc] init];
    self.test_title_label.font = SetFont(14);
    self.test_title_label.textColor = DetailTextColor;
    self.test_title_label.text = @"2017年浙江省考 副省级 A卷";
    [self addSubview:self.test_title_label];
    [self.test_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
    }];
    
    self.question_title_label = [[UILabel alloc] init];
    self.question_title_label.font = SetFont(18);
    self.question_title_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.question_title_label.numberOfLines = 0;
    self.question_title_label.text = @"三、根据给定材料所反映的主要问题，用1200字左右的篇幅，自拟标题进行论述。要求中心明确，内容充实，论述深刻，有说服力。";
    [self addSubview:self.question_title_label];
    [self.question_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.test_title_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.test_title_label.mas_left);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
