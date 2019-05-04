//
//  NomalGroupSettingViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/15.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NomalGroupSettingViewController : BaseViewController

@property (nonatomic, strong) NSString *group_id;

@property (nonatomic, copy) void(^touchRemoveAllMessageHistory)(void);

@property (nonatomic, copy) void(^touchExitGroup)(void);

@end

NS_ASSUME_NONNULL_END
