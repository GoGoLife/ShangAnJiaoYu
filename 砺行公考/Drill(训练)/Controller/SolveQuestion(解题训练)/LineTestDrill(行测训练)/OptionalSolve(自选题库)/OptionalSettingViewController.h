//
//  OptionalSettingViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface OptionalSettingViewController : BaseViewController

@property (nonatomic, copy) void(^returnUserSelectSetting)(NSArray *array);

@end
