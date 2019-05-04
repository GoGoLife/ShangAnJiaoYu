//
//  MyOrderHeaderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/17.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "MyOrderHeaderView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation MyOrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatViewUI];
    }
    return self;
}

- (void)creatViewUI {
    self.order_status_label = [[UILabel alloc] init];
    self.order_status_label.font = SetFont(14);
    self.order_status_label.textColor = SetColor(255, 85, 0, 1);
    [self addSubview:self.order_status_label];
    __weak typeof(self) weakSelf = self;
    [self.order_status_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.mas_centerY);
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
