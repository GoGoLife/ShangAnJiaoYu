//
//  View_CollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "View_CollectionViewCell.h"
#import <Masonry.h>
#import "GlobarFile.h"

@implementation View_CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.backgroundColor = SetColor(246, 246, 246, 1);
    self.contentLabel.font = SetFont(14);
    ViewRadius(self.contentLabel, 5.0);
    [self.contentView addSubview:self.contentLabel];
    __weak typeof(self) weakSelf = self;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.contentLabel.backgroundColor = ButtonColor;
    }else {
        self.contentLabel.backgroundColor = SetColor(246, 246, 246, 1);
    }
}

@end
