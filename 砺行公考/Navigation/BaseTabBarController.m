//
//  BaseTabBarController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "CourseViewController.h"
#import "DrillViewController.h"
#import "PartnerViewController.h"
#import "MineViewController.h"

#import "CourseHomeViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DrillViewController *drill = [[DrillViewController alloc] init];
    [self setUpOneChildVcWithVc:drill Image:@"训练_灰" selectedImage:@"训练" title:@"训练"];
    
//    CourseViewController *course = [[CourseViewController alloc] init];
    CourseHomeViewController *course = [[CourseHomeViewController alloc] init];
    [self setUpOneChildVcWithVc:course Image:@"课程_灰" selectedImage:@"课程" title:@"课程"];
    
    PartnerViewController *partner = [[PartnerViewController alloc] init];
    [self setUpOneChildVcWithVc:partner Image:@"考伴_灰" selectedImage:@"考伴" title:@"考伴"];
    
    MineViewController *mine = [[MineViewController alloc] init];
    [self setUpOneChildVcWithVc:mine Image:@"我的_灰" selectedImage:@"我的" title:@"我的"];
}
    
#pragma mark - 初始化设置tabBar上面单个按钮的方法
    
    /**
     *  @author li bo, 16/05/10
     *
     *  设置单个tabBarButton
     *
     *  @param Vc            每一个按钮对应的控制器
     *  @param image         每一个按钮对应的普通状态下图片
     *  @param selectedImage 每一个按钮对应的选中状态下的图片
     *  @param title         每一个按钮对应的标题
     */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
    {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:Vc];
        
        UIImage *myImage = [UIImage imageNamed:image];
        myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
        Vc.tabBarItem.image = myImage;
        
        UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
        mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        Vc.tabBarItem.selectedImage = mySelectedImage;
        
        Vc.tabBarItem.title = title;
        
        Vc.navigationItem.title = title;
        
        [self addChildViewController:nav];
        
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
