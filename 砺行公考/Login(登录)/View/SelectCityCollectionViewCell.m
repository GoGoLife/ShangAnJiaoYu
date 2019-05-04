//
//  SelectCityCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/2.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SelectCityCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation SelectCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = SetFont(12);
    self.textLabel.textColor = [UIColor grayColor];
//    ViewRadius(self.textLabel, 15.0);
    ViewBorderRadius(self.textLabel, 15.0, 1.0, [UIColor grayColor]);
    [self.contentView addSubview:self.textLabel];
    __weak typeof(self) weakSelf = self;
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end
