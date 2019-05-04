//
//  StoreHomeCollectionViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *tag_array;

//左侧image
@property (nonatomic, strong) UIImageView *left_view;

//title
@property (nonatomic, strong) UILabel *title_label;

//标签
@property (nonatomic, strong) UILabel *tag_label;

//价格
@property (nonatomic, strong) UILabel *price_label;

//购买人数
@property (nonatomic, strong) UILabel *number_label;

//好评
@property (nonatomic, strong) UILabel *good_label;

//其它说明
@property (nonatomic, strong) UILabel *remark_label;



@end

NS_ASSUME_NONNULL_END
