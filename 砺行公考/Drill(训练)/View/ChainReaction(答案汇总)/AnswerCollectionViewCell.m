//
//  AnswerCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AnswerCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation AnswerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self UI];
    }
    return self;
}

- (void)UI {
    self.label = [[UILabel alloc] init];
    self.label.font = SetFont(18);
    ViewRadius(self.label, self.bounds.size.width / 2);
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label];
    __weak typeof(self) weakSelf = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end
