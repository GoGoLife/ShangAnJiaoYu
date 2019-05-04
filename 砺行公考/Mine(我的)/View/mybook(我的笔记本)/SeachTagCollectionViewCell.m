//
//  SeachTagCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SeachTagCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation SeachTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatUI:frame];
    }
    return self;
}

- (void)creatUI:(CGRect)frame {
    __weak typeof(self) weakSelf = self;
    self.tag_label = [[UILabel alloc] init];
    self.tag_label.textAlignment = NSTextAlignmentCenter;
    self.tag_label.font = SetFont(14);
    ViewRadius(self.tag_label, frame.size.height / 2);
    [self.contentView addSubview:self.tag_label];
    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end
