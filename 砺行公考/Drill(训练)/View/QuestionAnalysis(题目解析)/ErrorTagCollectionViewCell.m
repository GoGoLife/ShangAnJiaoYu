//
//  ErrorTagCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/10.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ErrorTagCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface ErrorTagCollectionViewCell()

@property (nonatomic, strong) UIImageView *rightImageV;



@end

@implementation ErrorTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        __weak typeof(self) weakSelf = self;
        self.back_view = [[UIView alloc] init];
        self.back_view.backgroundColor = WhiteColor;
        ViewBorderRadius(self.back_view, 15.0, 1.0, SetColor(48, 132, 252, 1));
        [self.contentView addSubview:self.back_view];
        [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    self.rightImageV = [[UIImageView alloc] init];
    self.rightImageV.backgroundColor = RandomColor;
    [self.back_view addSubview:self.rightImageV];
    [self.rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-10);
        make.centerY.equalTo(weakSelf.back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(0, 14));
    }];
    
    self.contentLable = [[UILabel alloc] init];
    self.contentLable.font = SetFont(14);
    self.contentLable.textColor = SetColor(48, 132, 252, 1);
    self.contentLable.textAlignment = NSTextAlignmentCenter;
    [self.back_view addSubview:self.contentLable];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.back_view.mas_top);
        make.left.equalTo(weakSelf.back_view.mas_left).offset(10);
        make.bottom.equalTo(weakSelf.back_view.mas_bottom);
        make.right.equalTo(weakSelf.rightImageV.mas_left);
    }];
}

- (void)setIsShowEditButton:(BOOL)isShowEditButton {
    if (isShowEditButton) {
        [self.rightImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(14);
        }];
    }else {
        [self.rightImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

//- (void)setSelected:(BOOL)selected {
//    if (selected) {
////        self.back_view.backgroundColor = SetColor(48, 132, 252, 1);
//        self.back_view.layer.borderColor = ButtonColor.CGColor;
//        self.contentLable.textColor = WhiteColor;
//
//    }else {
////        self.back_view.backgroundColor = WhiteColor;
//        self.contentLable.textColor = SetColor(48, 132, 252, 1);
//    }
//}

@end
