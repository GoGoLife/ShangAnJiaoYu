//
//  DiscountTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscountTableViewCell : UITableViewCell

/**
 是否可用
 */
@property (nonatomic, assign) BOOL isUse;

/**
 优惠价格
 */
@property (nonatomic, strong) UILabel *left_label;

/**
 优惠卷类型
 */
@property (nonatomic, strong) UILabel *discount_type_label;

/**
 优惠券限制说明
 */
@property (nonatomic, strong) UILabel *details_label;

/**
 优惠券可使用时间
 */
@property (nonatomic, strong) UILabel *date_label;

@end

NS_ASSUME_NONNULL_END
