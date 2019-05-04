//
//  ThinkHomeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ThinkHomeViewController.h"
#import "RefiningViewController.h"

@interface ThinkHomeViewController ()

@property (nonatomic, strong) NSArray *small_circle_data;

@end

@implementation ThinkHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.small_circle_data = @[@{@"title":@"日程总览",@"color_r":@"115",@"color_g":@"136",@"color_b":@"193"},
                               @{@"title":@"阅读书评",@"color_r":@"141",@"color_g":@"117",@"color_b":@"175"},
                               @{@"title":@"精炼时评",@"color_r":@"158",@"color_g":@"173",@"color_b":@"116"},
                               @{@"title":@"优秀示范",@"color_r":@"186",@"color_g":@"160",@"color_b":@"120"},
                               @{@"title":@"思考笔记",@"color_r":@"120",@"color_g":@"166",@"color_b":@"200"},
                               @{@"title":@"维度",@"color_r":@"185",@"color_g":@"134",@"color_b":@"133"},
                               @{@"title":@"今日训练",@"color_r":@"227",@"color_g":@"178",@"color_b":@"138"}];
    
    CGFloat corner = M_PI * 2.0 / 7;
    // 半径为 （转盘半径➖按钮半径）的一半
    CGFloat r = (SCREENBOUNDS.width - 40) / 3;
    CGFloat x = self.view.center.x;
    CGFloat y = self.view.center.y - 100.0;
    CGFloat BtnWidth = r - 30;
    
    UIButton *center_button = [UIButton buttonWithType:UIButtonTypeCustom];
    center_button.backgroundColor = SetColor(130, 180, 231, 1);
    center_button.frame = FRAME(0, 0, r, r);
    center_button.layer.masksToBounds = YES;
    center_button.layer.cornerRadius = r / 2;
    center_button.center = CGPointMake(self.view.center.x, self.view.center.y - 100.0);
    center_button.titleLabel.font = SetFont(20);
    [center_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [center_button setTitle:@"使用指南" forState:UIControlStateNormal];
    [self.view addSubview:center_button];
    
    for (int i = 0 ; i < self.small_circle_data.count; i++) {
        NSDictionary *dic = self.small_circle_data[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = SetFont(16);
        [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
        btn.backgroundColor = SetColor([dic[@"color_r"] integerValue], [dic[@"color_g"] integerValue], [dic[@"color_b"] integerValue], 1);
        btn.frame = CGRectMake(0, 0, BtnWidth, BtnWidth);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = BtnWidth / 2;
        CGFloat  num = (i + 0.5) * 1.0;
        btn.center = CGPointMake(x + r * cos(corner * num), y + r *sin(corner * num));
        btn.tag = i;
        [self.view addSubview:btn];
        
        [btn addTarget:self action:@selector(touchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)touchBtnAction:(UIButton *)sender {
    NSString *btn_title = self.small_circle_data[sender.tag][@"title"];
    if ([btn_title isEqualToString:@"精炼时评"]) {
        RefiningViewController *refining = [[RefiningViewController alloc] init];
        [self.navigationController pushViewController:refining animated:YES];
    }else {
        [self showHUDWithTitle:@"敬请期待"];
    }
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
