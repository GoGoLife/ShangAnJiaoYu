//
//  ShopDisCountViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopDisCountViewController : BaseViewController

/**
 优惠券信息
 */
@property (nonatomic, strong) NSArray *disCount_array;

@property (nonatomic, copy) void(^returnUserChoosedDisCount)(NSDictionary *data_dic);

@end

NS_ASSUME_NONNULL_END
