//
//  InvatationViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/24.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "InvatationViewController.h"

@interface InvatationViewController ()

@property (nonatomic, strong) UILabel *invatation_label;

@end

@implementation InvatationViewController

- (void)getInvatationCode {
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_invite_code" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSString *invatation_code = [NSString stringWithFormat:@"%ld", [responseObject[@"data"][@"invite_code_"] integerValue]];
            weakSelf.invatation_label.text = invatation_code;
            [[NSUserDefaults standardUserDefaults] setObject:invatation_code forKey:@"invatation_code"];
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请码";
    [self setBack];
    
    self.invatation_label = [[UILabel alloc] init];
    self.invatation_label.font = SetFont(22);
    self.invatation_label.backgroundColor = SetColor(246, 246, 246, 1);
    self.invatation_label.textColor = DetailTextColor;
    self.invatation_label.textAlignment = NSTextAlignmentCenter;
    self.invatation_label.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"invatation_code"] ?: @"";
    ViewRadius(self.invatation_label, 8.0);
    [self.view addSubview:self.invatation_label];
    __weak typeof(self) weakSelf = self;
    [self.invatation_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(30);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
        make.height.mas_equalTo(50.0);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = SetFont(14);
    button.backgroundColor = ButtonColor;
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button setTitle:@"生成邀请码" forState:UIControlStateNormal];
    ViewRadius(button, 15.0);
    [button addTarget:self action:@selector(getInvatationCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.invatation_label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.invatation_label.mas_left).offset(20);
        make.right.equalTo(weakSelf.invatation_label.mas_right).offset(-20);
        make.height.mas_equalTo(30.0);
    }];
}

- (void)getInvatationCodeAction {
    [self getInvatationCode];
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
