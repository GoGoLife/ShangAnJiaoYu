//
//  BaseViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)setBack {
    [self setUpNav];
}
    
setBack();
pop();

- (void)showHUD {
    [self.view addSubview:self.hud];
//    [_hud showAnimated:YES];
    [_hud show:YES];
}

- (void)hidden {
//    [_hud hideAnimated:YES];
    [_hud hide:YES];
}

- (void)showHUDWithTitle:(NSString *)title {
    self.hud.labelText = title;
    _hud.mode = MBProgressHUDModeText;
    [self.view addSubview:_hud];
    [_hud show:YES];
    [_hud hide:YES afterDelay:1.0];
}

- (MBProgressHUD *)hud {
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return _hud;
}

#pragma mark 实现搜索条背景透明化
- (UIImage*)GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)setleftOrRight:(NSString *)typeString BarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    if ([typeString isEqualToString:@"left"]) {
        ((UIViewController *)target).navigationItem.leftBarButtonItem = barButtonItem;
    }else {
        ((UIViewController *)target).navigationItem.rightBarButtonItem = barButtonItem;
    }
}

- (void)setleftOrRight:(NSString *)typeString BarButtonItemWithImage:(UIImage *)image target:(nullable id)target action:(nullable SEL)action {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    if ([typeString isEqualToString:@"left"]) {
        ((UIViewController *)target).navigationItem.leftBarButtonItem = barButtonItem;
    }else {
        ((UIViewController *)target).navigationItem.rightBarButtonItem = barButtonItem;
    }
}

StringHeight();
StringWidth();

//判断文件是否已经在沙盒中已经存在？
-(BOOL)isFileExist:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

// 获取视频第一帧
- (UIImage*)getVideoPreViewImage:(NSURL *)path {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(1.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
