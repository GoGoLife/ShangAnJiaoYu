//
//  RecommendCourseViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "RecommendCourseViewController.h"
#import <SJVideoPlayer.h>

@interface RecommendCourseViewController ()

@property (nonatomic, strong) NSString *text_view_title;

@property (nonatomic, strong) SJVideoPlayer *player;

@end

@implementation RecommendCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.text_view_title = @"在这里，魔法不只是一种神秘莫测的能量概念。它是实体化的物质，可以被引导、成形、塑造和操作。符文之地的魔法拥有自己的自然法则。源生态魔法随机变化的结果改变了科学法则。 符文之地有数块大陆，不过所有的生命都集中在最大魔法大陆——瓦罗兰。瓦罗兰大陆居于符文之地中心，是符文之地面积最大的大陆。 被祝福的符文之地上有大量源生态魔法能量，而此地居民可以触及其中的能量。符文之地的中心区域集中了数量巨大的源生态魔法能量，这些地方都是水晶枢纽的理想位置。水晶枢纽可以将源生能量塑形为自身实体化的存在。此外，水晶枢纽还可以成为能量车间，为需要魔法能量的建筑供能。水晶枢纽遍布符文之地，但最大的水晶枢纽都坐落在瓦罗兰大陆。&#911] 在这里，魔法不只是一种神秘莫测的能量概念。它是实体化的物质，可以被引导、成形、塑造和操作。符文之地的魔法拥有自己的自然法则。源生态魔法随机变化的结果改自然自然自然变了科学法则。文之地的魔法拥有自己的自然法则。";
    
    //get   文本高度
    CGFloat height = [self calculateRowHeight:self.text_view_title fontSize:14 withWidth:SCREENBOUNDS.width - 40] + 40;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, self.view.bounds.size.height)];
    [scroll setContentSize:CGSizeMake(SCREENBOUNDS.width, 200 + 80 + height + 230)];
    [self.view addSubview:scroll];
    
    self.player = [SJVideoPlayer player];
    self.player.view.frame = FRAME(0, 0, SCREENBOUNDS.width, 200);
    [scroll addSubview:self.player.view];
    self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"]];
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(22);
    label.text = @"砺行长效班计划";
    [scroll addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.player.view.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    UILabel *detail_label = [[UILabel alloc] init];
    detail_label.font = SetFont(12);
    detail_label.textColor = DetailTextColor;
    detail_label.text = @"2017-10-10  砺行宣传部";
    [scroll addSubview:detail_label];
    [detail_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
    }];
    
    
    UITextView *text_view = [[UITextView alloc] init];
    text_view.font = SetFont(14);
    text_view.scrollEnabled = NO;
    text_view.text = self.text_view_title;
    [scroll addSubview:text_view];
    [text_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detail_label.mas_bottom).offset(20);
        make.left.equalTo(detail_label.mas_left);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(height);
    }];
    
    UIImageView *bottom_image = [[UIImageView alloc] init];
    bottom_image.backgroundColor = RandomColor;
    ViewRadius(bottom_image, 8.0);
    [scroll addSubview:bottom_image];
    [bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(text_view.mas_bottom).offset(20);
        make.left.equalTo(text_view.mas_left);
        make.right.equalTo(text_view.mas_right);
        make.height.mas_equalTo(130);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
