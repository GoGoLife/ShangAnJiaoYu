//
//  PasswordViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PasswordViewController : BaseViewController

@property (nonatomic, strong) NSString *phone;

//是否忘记密码
@property (nonatomic, assign) BOOL forgotPassword;

@end

NS_ASSUME_NONNULL_END
