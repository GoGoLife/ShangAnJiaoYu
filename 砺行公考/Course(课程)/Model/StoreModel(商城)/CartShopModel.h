//
//  CartShopModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//
/** ========== 数据格式 ===========
 "id_": "9cc0f7b6718d4d7a9e3b385a6b52ecd8",
 "lable": "商品标签1,商品标签2,商品标签3,商品标签4",
 "status_": "1",
 "payment_number_": 0,
 "price_": 400,
 "name_": "蓝色",
 "number_": 0
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartShopModel : NSObject

//商品ID
@property (nonatomic, strong) NSString *cart_shop_id;

//商品下某种类型的ID
@property (nonatomic, strong) NSString *cart_shop_type_id;

//商品图片
@property (nonatomic, strong) NSString *cart_shop_image_url;

//商品名称
@property (nonatomic, strong) NSString *cart_title;

//商品分类标签
@property (nonatomic, strong) NSString *cart_category_title;

//商品价格
@property (nonatomic, strong) NSString *cart_price;

//商品付款人数
@property (nonatomic, strong) NSString *cart_payNumbers;

//商品购买数量
@property (nonatomic, strong) NSString *cart_shop_numbers;

//是否已经选择
@property (nonatomic, assign) BOOL isSelected;

/** 商品是否有效 */
@property (strong, nonatomic) NSString *status_;

/** 商品标签 */
@property (strong, nonatomic) NSString *lable_;

@end

NS_ASSUME_NONNULL_END
