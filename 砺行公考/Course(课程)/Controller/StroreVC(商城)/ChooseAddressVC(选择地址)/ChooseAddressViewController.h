//
//  ChooseAddressViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChooseAddressFinishDelegate <NSObject>

- (void)selectFinishAction:(NSString *)nameStrng AddressConten:(NSString *)addressString AddressID:(NSString *)address_id;

@end

@interface ChooseAddressViewController : BaseViewController

@property (nonatomic, weak) id<ChooseAddressFinishDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
