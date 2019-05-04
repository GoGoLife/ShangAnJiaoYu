//
//  OrderViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *small_tag_dic;

//商品信息Model
@property (nonatomic, strong) ShopDetailsModel *shopDetailsModel;

@end

NS_ASSUME_NONNULL_END
