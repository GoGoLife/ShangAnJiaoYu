//
//  MyPartnerDynamicViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyPartnerDynamicViewController : BaseViewController

@property (nonatomic, copy) void(^AddFriendSuccess)(void);

/** 手机号码 */
@property (nonatomic, strong) NSString *phone;

/**
 根据id 查看当前人的动态信息
 */
@property (nonatomic, strong) NSString *other_id_;

@end

NS_ASSUME_NONNULL_END
