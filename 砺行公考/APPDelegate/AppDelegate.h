//
//  AppDelegate.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setLoginVCToWindowRoot;

- (void)setHomeVCToWindowRoot;

#pragma mark ---- 登录成功之后需要执行的代码
- (void)loginSuccessAfter;

@end

