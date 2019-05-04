//
//  BaseViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "GlobarFile.h"
#import <MBProgressHUD.h>
#import "MOLoadHTTPManager.h"
#import "AppDelegate.h"
#import "KPDateTool.h"
#import "DBManager.h"
#import "LYSSlideMenuController.h"
#import <BaiduMobStat.h>
#import <MJRefresh.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
//返回按钮
- (void)setBack;

//返回方法
- (void)pop;

- (void)showHUD;

- (void)hidden;

- (void)showHUDWithTitle:(NSString *)title;


/**
 根据颜色生成图片

 @param color 颜色
 @param height 高度
 @return image
 */
- (UIImage *)GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

//返回指定宽度字符串的高度
- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize withWidth:(CGFloat)width;

//返回字符串的宽度
- (CGFloat)calculateRowWidth:(NSString *)string withFont:(CGFloat)font;

- (void)setleftOrRight:(NSString *)typeString BarButtonItemWithTitle:(NSString *)title target:(nullable id)target action:(nullable SEL)action;

- (void)setleftOrRight:(NSString *)typeString BarButtonItemWithImage:(UIImage *)image target:(nullable id)target action:(nullable SEL)action;

//判断文件是否已经在沙盒中已经存在？
-(BOOL)isFileExist:(NSString *)fileName;

/**
 获取视频第一帧图片

 @param path 视频URL
 @return image
 */
- (UIImage*) getVideoPreViewImage:(NSURL *)path;

@end

NS_ASSUME_NONNULL_END
