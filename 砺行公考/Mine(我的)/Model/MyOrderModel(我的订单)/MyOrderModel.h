//
//  MyOrderModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/17.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderModel : NSObject

/** 订单ID */
@property (nonatomic, strong) NSString *order_id;

/** 订单状态 */
@property (nonatomic, strong) NSString *order_status;

/** 订单实际付款 */
@property (nonatomic, strong) NSString *order_real_payment;

/** 运费 */
@property (nonatomic, strong) NSString *order_send_cost;

/** 订单下的商品数量 */
@property (nonatomic, strong) NSString *order_commodity_total;

/** 订单下的商品集合 */
@property (nonatomic, strong) NSArray *order_commodity_list;

@end

/**
 订单下的商品Model
 */
@interface OrderUnderShopModel : NSObject

/** 商品ID */
@property (nonatomic, strong) NSString *order_shop_id;

/** 商品小类ID */
@property (nonatomic, strong) NSString *order_shop_tyep_id;

/** 商品标签 */
@property (nonatomic, strong) NSString *order_shop_label;

/** 商品标题 */
@property (nonatomic, strong) NSString *order_shop_title;

/** 商品价格 */
@property (nonatomic, strong) NSString *order_shop_price;

/** 购买的商品数量 */
@property (nonatomic, strong) NSString *order_shop_number;

/** 商品图片 */
@property (nonatomic, strong) NSString *order_shop_imageUrl;

/** 商品分类 */
@property (nonatomic, strong) NSString *order_shop_type_title;

@end

NS_ASSUME_NONNULL_END
