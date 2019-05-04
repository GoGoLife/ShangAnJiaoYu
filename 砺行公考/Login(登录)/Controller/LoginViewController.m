//
//  LoginViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "PhoneViewController.h"

@interface LoginViewController ()

//登录按钮
@property (nonatomic, strong) UIButton *registerBtn;
    
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.view.backgroundColor = [UIColor grayColor];
    self.view.layer.contents = (id)[UIImage imageNamed:@"app_home"].CGImage;
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerBtn setTitle:@"注册/登录" forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.registerBtn setBackgroundColor:[UIColor whiteColor]];
    [self.registerBtn addTarget:self action:@selector(touchButton) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(self.registerBtn, 25.0);
    [self.view addSubview:self.registerBtn];
    
    __weak typeof(self) weakSelf = self;
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-80);
        make.height.mas_equalTo(50);
     }];
}
    
- (void)touchButton {
    PhoneViewController *phone = [[PhoneViewController alloc] init];
    [self.navigationController pushViewController:phone animated:YES];
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
