//
//  DigestTagCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "DigestTagCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation DigestTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = ButtonColor;
        ViewRadius(self, 5.0);
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.tag_label = [[UILabel alloc] init];
    self.tag_label.font = SetFont(12);
    self.tag_label.textColor = WhiteColor;
    self.tag_label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tag_label];
    __weak typeof(self) weakSelf = self;
    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 20));
    }];
    
    UIButton *delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete_button setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.contentView addSubview:delete_button];
    [delete_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.tag_label.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.tag_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10.0, 10.0));
    }];
    [delete_button addTarget:self action:@selector(deleteButtonBindAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteButtonBindAction {
    if ([_delegate respondsToSelector:@selector(deleteBindTagWithDigest:)]) {
        [_delegate deleteBindTagWithDigest:self.indexPath];
    }
}

@end
