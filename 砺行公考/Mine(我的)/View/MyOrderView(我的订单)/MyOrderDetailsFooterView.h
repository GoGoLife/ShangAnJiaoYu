//
//  MyOrderDetailsFooterView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderDetailsFooterView : UIView

/**
 商品价格
 */
@property (nonatomic, strong) UILabel *price_content_label;

/**
 运费价格
 */
@property (nonatomic, strong) UILabel *freight_content_label;

/**
 减免价格
 */
@property (nonatomic, strong) UILabel *remission_content_label;

@end

NS_ASSUME_NONNULL_END
