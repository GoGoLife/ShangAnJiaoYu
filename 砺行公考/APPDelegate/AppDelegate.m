//
//  AppDelegate.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import <IQKeyboardManager.h>
#import "VHallApi.h"
#import "DBManager.h"
#import "PhoneViewController.h"
#import <Hyphenate/Hyphenate.h>
#import <BaiduMobStat.h>
#import <JPUSHService.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <AlipaySDK/AlipaySDK.h>

//行测  大申论  小申论  通关训练
#import "TrainingHomeViewController.h"
#import "EssayTests_HomeViewController.h"

@interface AppDelegate ()<EMContactManagerDelegate, JPUSHRegisterDelegate>

//存储apptoken是否有效
@property (nonatomic, assign) BOOL isUsing;

@end

@implementation AppDelegate

//判断app_token是否过期
- (BOOL)app_token_is_using {
    __weak typeof(self) weakSelf = self;
    NSDictionary *parma = @{@"app_token":[[NSUserDefaults standardUserDefaults] objectForKey:APP_TOKEN]};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/verify_app_token" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"====== %@", responseObject);
        if ([responseObject[@"state"] integerValue]) {
            //token有效
            weakSelf.isUsing = YES;
        }else {
            //token无效
            weakSelf.isUsing = NO;
        }
    } FailureBlock:^(id error) {
        
    }];
    return self.isUsing;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"app token === %@", [[NSUserDefaults standardUserDefaults] objectForKey:APP_TOKEN]);
    
    //    [self setHomeVCToWindowRoot];
    
    NSInteger isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] integerValue];
    NSLog(@"isLogin == %ld", isLogin);
    if (isLogin) {
        [self setHomeVCToWindowRoot];
//        //判断apptoken是否有效
//        if ([self app_token_is_using]) {
//            //有效直接进首页
//
//        }else {
//            //无效则跳转登录页面
//            [[NSUserDefaults standardUserDefaults] setObject:@"无效" forKey:APP_TOKEN];
//            PhoneViewController *phone = [[PhoneViewController alloc] init];
//            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:phone];
//            self.window.rootViewController = nav;
//            [self.window makeKeyAndVisible];
//        }
    }else {
        [self setLoginVCToWindowRoot];
    }
    
    [self loginSuccessAfter];
    
    //环信
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    //极光
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
    }];
    [JPUSHService setupWithOption:launchOptions appKey:@"72f41dc13f4f5336b43eadd5" channel:@"" apsForProduction:NO];
//    //接收自定义通知消息
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    return YES;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的 Extras 附加字段，key 是自己定义的
    NSLog(@"content == %@\n   message == %@\n extras == %@", content, messageID, extras);
    
    
//    UIViewController *targetVC = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    
//    if ([content integerValue] == 0) {
//        //不跳转
//    }else if ([content integerValue] == 1) {
//        //跳转行测通关
//        tab.selectedIndex = 1;
//
//    }else if ([content integerValue] == 2) {
//        //跳转大申论通关
//        tab.selectedIndex = 2;
//    }else if ([content integerValue] == 3) {
//        //跳转小申论通关
//        tab.selectedIndex = 3;
//    }
}



- (void)setLoginVCToWindowRoot {
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:login];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)setHomeVCToWindowRoot {
    BaseTabBarController *tab = [[BaseTabBarController alloc] init];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    [self loginSuccessAfter];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

#pragma mark ---- 登录成功之后需要执行的代码
- (void)loginSuccessAfter {
    if (![self isFileExist:@"lixing.sqlite"]) {
        //创建数据库表
        [[DBManager sharedInstance] creatTable];
        //添加两条固定数据到日程数据库的标签表
        [[DBManager sharedInstance] setDataToTagDBColor_R:@"9" Color_G:@"0" Color_B:@"137" isUsing:1 Content:@"听课"];
        [[DBManager sharedInstance] setDataToTagDBColor_R:@"243" Color_G:@"129" Color_B:@"129" isUsing:1 Content:@"训练"];
        [[DBManager sharedInstance] setDataToTagDBColor_R:@"0" Color_G:@"116" Color_B:@"228" isUsing:1 Content:@"讨论"];
        [[DBManager sharedInstance] setDataToTagDBColor_R:@"116" Color_G:@"219" Color_B:@"239" isUsing:1 Content:@"运动"];
        
        
        /*添加基本数据到数据库  （快捷入口）
         模块分类       1 ==== 解题训练
                        2 ===== 课程模块
                        3 === 考伴互动
                        4 === 我的互动
         */
        //解题训练模块
        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"drill_1" ImageUrl:@"" Title:@"基础能力" IsShow:@"0" CategoryModel:@"1" TargetVCNamed:@"BasicsHomeViewController" TargetData:@"1"];
        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"drill_2" ImageUrl:@"" Title:@"解题方法" IsShow:@"0" CategoryModel:@"1" TargetVCNamed:@"SolveFunctionViewController" TargetData:@"1"];
        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"drill_7" ImageUrl:@"" Title:@"申论全真题库" IsShow:@"0" CategoryModel:@"1" TargetVCNamed:@"ProvinceTestViewController" TargetData:@"2"];
        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"drill_3" ImageUrl:@"" Title:@"行测全真题库" IsShow:@"0" CategoryModel:@"1" TargetVCNamed:@"ProvinceTestViewController" TargetData:@"1"];
        
        //课程模块
        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"课程" ImageUrl:@"" Title:@"我的课程" IsShow:@"0" CategoryModel:@"2" TargetVCNamed:@"My_CourseViewController" TargetData:@"1"];
//        //考伴互动
//        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"category_4" ImageUrl:@"" Title:@"砺行长效班" IsShow:@"0" CategoryModel:@"3" TargetVCNamed:@"ProvinceTestViewController" TargetData:@"1"];
        //我的互动
        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"book_1" ImageUrl:@"" Title:@"错题本" IsShow:@"0" CategoryModel:@"4" TargetVCNamed:@"ErrorBookThreeViewController" TargetData:@"1"];
        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"book_3" ImageUrl:@"" Title:@"总结本" IsShow:@"0" CategoryModel:@"4" TargetVCNamed:@"SummarizeBookViewController" TargetData:@"1"];
        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"book_2" ImageUrl:@"" Title:@"优题本" IsShow:@"0" CategoryModel:@"4" TargetVCNamed:@"ExcellentBookViewController" TargetData:@"1"];
        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"book_4" ImageUrl:@"" Title:@"摘记本" IsShow:@"0" CategoryModel:@"4" TargetVCNamed:@"DigestBookViewController" TargetData:@"1"];
    }
    //注册微吼直播
    [VHallApi registerApp:@"a8bbdc002b14c1bf955715ede805db7c" SecretKey:@"7af39945ba0cced09601b8b779fd2465"];
    //登录
    [VHallApi loginWithAccount:@"18268865135" password:@"888888" success:^{
        NSLog(@"微吼-----登录成功");
    } failure:^(NSError *error) {
        NSLog(@"微吼-----登录失败");
    }];
    
    //注册环信
    EMOptions *options = [EMOptions optionsWithAppkey:@"wdsdsdff#huanxingss"];
    options.apnsCertName = @"";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    [[EMClient sharedClient] loginWithUsername:account password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"登录成功！！！");
        }else {
            NSLog(@"aError === %@", aError.errorDescription);
        }
    }];
    
    //通过接口获取砺行长效班的群
    [self getPublicGroupAddToDatabase];
    
    //百度统计SDK
    //相关设置
    [[BaiduMobStat defaultStat] setUserId:@"18268865135"];
    [[BaiduMobStat defaultStat] setShortAppVersion:@"1.0"];
    [[BaiduMobStat defaultStat] setChannelId:@"AppStore"];
    [[BaiduMobStat defaultStat] setEnableExceptionLog:YES];
    [[BaiduMobStat defaultStat] setLogSendWifiOnly:NO];
    [[BaiduMobStat defaultStat] setSessionResumeInterval:30];
    [[BaiduMobStat defaultStat] setEnableDebugOn:NO];
    [[BaiduMobStat defaultStat] setEnableGps:YES];
    
    [[BaiduMobStat defaultStat] startWithAppId:@"f661ce6c2c"];
}


//别人申请添加我为好友时的回调
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage {
    [[EMClient sharedClient].contactManager approveFriendRequestFromUser:aUsername completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"我同意了加好友的请求");
            //通知好友列表界面刷新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changedFriendList" object:nil];
        }
    }];
}


/**
 隐藏问题： 如果原本的isShow=== 1     执行方法之后  会重置
 */
//查询长效砺行班公开群  并  添加到本地数据库
- (void)getPublicGroupAddToDatabase {
    //删除数据库中的群数据
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    //拼接删除数据sql语句
    NSString *delete_sql_string = [NSString stringWithFormat:@"delete from t_shortcut where categoryModel = '%@'", @"3"];
    if ([dataBase open]) {
        BOOL success = [dataBase executeUpdate:delete_sql_string];
        if (success) {
            NSLog(@"删除群数据成功");
            //重新请求  并添加
            NSDictionary *parma = @{@"page_number":@"1",
                                    @"page_size":@"200"};
            [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_hx_group" Dic:parma SuccessBlock:^(id responseObject) {
//                NSLog(@"public group === %@", responseObject);
                if ([responseObject[@"state"] integerValue] == 1) {
                    for (NSDictionary *dic in responseObject[@"data"][@"rows"]) {
                        [[DBManager sharedInstance] insertDataToShortcutWithImageNamed:@"group_1" ImageUrl:@"" Title:dic[@"name_"] IsShow:@"0" CategoryModel:@"3" TargetVCNamed:@"ChatViewController" TargetData:dic[@"id_"]];
                    }
                }
            } FailureBlock:^(id error) {
                
            }];
        }else {
            NSLog(@"删除群数据失败");
        }
        
    }
    [dataBase close];
}

//注册 APNs 成功并上报 DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册 APNs 失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
        NSLog(@"11111111111 info === %@", notification.request.content.userInfo);
    }else{
        //从通知设置界面进入应用
        NSLog(@"22222222222  info === %@", notification.request.content.userInfo);
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"33333333 info === %@", userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)) {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"44444444444444444 info == %@", userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [JPUSHService setBadge:0];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        //点击通知
        [self touchJPUSHNotificationAction:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"555555555555555   info == %@", userInfo);
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"66666666666666666  info == %@", userInfo);
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)touchJPUSHNotificationAction:(NSDictionary *)userInfo {
    NSArray *dataArray = [userInfo[@"type_"] componentsSeparatedByString:@"&&"];
    NSInteger type = [dataArray[0] integerValue];
    NSString *training_id = dataArray[1];
    UIViewController *targetVC = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    switch (type) {
        case 1:
        {
            //行测通关
            TrainingHomeViewController *home = [[TrainingHomeViewController alloc] init];
            home.training_id = training_id;
            [targetVC.navigationController pushViewController:home animated:YES];
        }
            break;
        case 2:
        {
            EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
            home.type = ESSAY_TESTS_TYPE_BigTestTraining;
            home.TestTraining_id = training_id;
            [targetVC.navigationController pushViewController:home animated:YES];
        }
            break;
        case 3:
        {
            EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
            home.type = ESSAY_TESTS_TYPE_BigTestTraining;
            home.TestTraining_id = training_id;
            [targetVC.navigationController pushViewController:home animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (UIViewController *)topVC:(UIViewController *)rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootViewController;
        return [self topVC:tab.selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navc = (UINavigationController *)rootViewController;
        return [self topVC:navc.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController *pre = (UIViewController *)rootViewController.presentedViewController;
        return [self topVC:pre];
    }else{
        return rootViewController;
    }
}
@end
