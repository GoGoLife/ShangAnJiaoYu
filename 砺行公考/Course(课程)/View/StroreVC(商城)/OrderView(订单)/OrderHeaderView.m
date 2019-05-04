
//
//  OrderHeaderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OrderHeaderView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation OrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
//        [self initViewUI];
    }
    return self;
}

StringWidth()
- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    CGFloat offset_width = 0.0;
    for (NSInteger index = self.tag_array.count - 1; index >= 0; index--) {
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(10);
        label.textColor = SetColor(255, 85, 0, 1);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.tag_array[index];
        ViewBorderRadius(label, 0.0, 1.0, SetColor(255, 85, 0, 1));
        [self addSubview:label];
        CGFloat width = [self calculateRowWidth:self.tag_array[index] withFont:10];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right).offset(-20 - offset_width);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(width + 5);
        }];
//        CGFloat width = [self calculateRowWidth:self.tag_array[index] withFont:10];
        offset_width = offset_width + width + 10;
    }
}

- (void)setTag_array:(NSArray *)tag_array {
    _tag_array = tag_array;
//    [self layoutIfNeeded];
    [self initViewUI];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
