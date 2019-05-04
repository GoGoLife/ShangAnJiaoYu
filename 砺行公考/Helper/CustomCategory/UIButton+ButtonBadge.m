//
//  UIButton+ButtonBadge.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/2.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "UIButton+ButtonBadge.h"
#import <Masonry.h>

@implementation UIButton (ButtonBadge)

- (void)setBadgeString:(NSString *)badge Font:(NSInteger)font {
    UILabel *badge_label = [[UILabel alloc] init];
    badge_label.backgroundColor = [UIColor redColor];
    badge_label.textColor = [UIColor whiteColor];
    badge_label.font = [UIFont systemFontOfSize:font];
    badge_label.textAlignment = NSTextAlignmentCenter;
    badge_label.layer.masksToBounds = YES;
    badge_label.layer.cornerRadius = 10.0;
    badge_label.text = badge;
    [self addSubview:badge_label];
    __weak typeof(self) weakSelf = self;
    [badge_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

@end
