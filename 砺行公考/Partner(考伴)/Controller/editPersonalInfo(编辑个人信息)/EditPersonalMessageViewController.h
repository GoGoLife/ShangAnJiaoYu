//
//  EditPersonalMessageViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditPersonalMessageViewController : BaseViewController

@property (nonatomic, copy) void(^returnMessageString)(NSString *message);

@end

NS_ASSUME_NONNULL_END
