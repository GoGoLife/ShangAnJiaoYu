//
//  ScheduleCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ScheduleCollectionViewCell.h"
#import <Masonry.h>

@interface ScheduleCollectionViewCell ()

/**
 遮罩层
 */
@property (nonatomic, strong) UIView *back_view;

@end

@implementation ScheduleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.label = [[MYLabel alloc] init];
    self.label.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.label];
    __weak typeof(self) weakSelf = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.select_image = [[UIImageView alloc] init];
    self.select_image.backgroundColor = [UIColor blueColor];
    self.select_image.hidden = YES;
    [self.contentView addSubview:self.select_image];
    [self.select_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label.mas_top);
        make.right.equalTo(weakSelf.label.mas_right);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    //添加双击手势
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTapGesture];
}

- (void)setIsSecelt:(BOOL)isSecelt {
    _isSecelt = isSecelt;
    if (_isSecelt) {
        self.select_image.hidden = NO;
    }else {
        self.select_image.hidden = YES;
    }
}

- (void)setTextAlignment:(VerticalAlignment)textAlignment {
    [self.label setVerticalAlignment:textAlignment];
}

/**
 添加遮罩层
 */
- (void)addBackViewToSelf {
    self.back_view = [[UIView alloc] initWithFrame:self.bounds];
    self.back_view.backgroundColor = [UIColor grayColor];
    self.back_view.alpha = 0.8;
    [self addSubview:self.back_view];
}

/**
 移除遮罩层
 */
- (void)removeBackView {
    [self.back_view removeFromSuperview];
}

/**
 双击手势响应方法

 @param gesture 手势
 */
- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    if (!self.indexPath) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(doubleGestureWithAction:)]) {
        [_delegate doubleGestureWithAction:self.indexPath];
    }
}
@end
