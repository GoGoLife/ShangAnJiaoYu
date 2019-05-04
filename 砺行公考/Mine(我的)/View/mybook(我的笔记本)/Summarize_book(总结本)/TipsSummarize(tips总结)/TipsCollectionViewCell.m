//
//  TipsCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "TipsCollectionViewCell.h"

@implementation TipsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.imageview = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.imageview.layer.cornerRadius = 5.0;
        self.imageview.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageview];
    }
    return self;
}

@end
