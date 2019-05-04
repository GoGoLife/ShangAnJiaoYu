//
//  PartnerViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PartnerViewController.h"
//考伴圈
#import "PartnerCircleViewController.h"
//考伴列表
#import "PartnerListViewController.h"
//会话列表
#import "ConversationListViewController.h"

#import "MyPartnerDynamicViewController.h"

@interface PartnerViewController ()

@property (nonatomic, strong) PartnerCircleViewController *circleVC;

@property (nonatomic, strong) PartnerListViewController *list;

@property (nonatomic, strong) ConversationListViewController *conversationList;

@end

@implementation PartnerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.font = SetFont(32);
    label.text = @"考伴";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(40);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    UIImageView *rightImage = [[UIImageView alloc] init];
    rightImage.image = [UIImage imageNamed:@"date"];
    [self.view addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    rightImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPersonalVC)];
    [rightImage addGestureRecognizer:tap];
    
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"考麦KM", @"考圈KQ", @"考伴KB"]];
    segment.frame = FRAME(0, 100, SCREENBOUNDS.width, 44);
    [segment setSelectedSegmentIndex:0];
    segment.tintColor = WhiteColor;
    [segment setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size: 22]} forState:UIControlStateNormal];
    [segment setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size: 22]} forState:UIControlStateSelected];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName : DetailTextColor} forState:UIControlStateNormal];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [segment addTarget:self action:@selector(changeRootVC:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
    //考麦
    self.list = [[PartnerListViewController alloc] init];
    [self addChildViewController:self.list];
    [self.view addSubview:self.list.view];
    [self.list didMoveToParentViewController:self];
    self.list.view.hidden = YES;
    
    //考圈
    self.circleVC = [[PartnerCircleViewController alloc] init];
    [self addChildViewController:self.circleVC];
    [self.view addSubview:self.circleVC.view];
    [self.circleVC didMoveToParentViewController:self];
    self.circleVC.view.hidden = YES;

    //考伴
    self.conversationList = [[ConversationListViewController alloc] init];
    [self addChildViewController:self.conversationList];
    [self.view addSubview:self.conversationList.view];
    [self.conversationList didMoveToParentViewController:self];
    self.conversationList.view.hidden = NO;
    
}


//改变显示的VC
- (void)changeRootVC:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        self.circleVC.view.hidden = YES;
        self.list.view.hidden = YES;
        self.conversationList.view.hidden = NO;
    }else if(segment.selectedSegmentIndex == 1) {
        self.circleVC.view.hidden = NO;
        self.list.view.hidden = YES;
        self.conversationList.view.hidden = YES;
    }else {
        self.circleVC.view.hidden = YES;
        self.list.view.hidden = NO;
        self.conversationList.view.hidden = YES;
    }
}

//跳转到我的动态页面
- (void)pushPersonalVC {
    MyPartnerDynamicViewController *partner = [[MyPartnerDynamicViewController alloc] init];
    partner.phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"huanxinID"];
    [self.navigationController pushViewController:partner animated:YES];
}

@end
