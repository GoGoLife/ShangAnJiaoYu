//
//  SetPasswordViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "DealViewController.h"
#import "LoginSuccessViewController.h"
#import <Hyphenate/Hyphenate.h>

@interface SetPasswordViewController ()

//请设置您的密码
@property (nonatomic, strong) UILabel *label;

//输入密码
@property (nonatomic, strong) UITextField *firstPassword;

//确认密码
@property (nonatomic, strong) UITextField *secondPassword;

//注册按钮
@property (nonatomic, strong) UIButton *registerButton;

//用户协议
@property (nonatomic, strong) UILabel *label1;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self setBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI {
    self.label = [[UILabel alloc] init];
    self.label.text = self.isForgotPassword ? @"请重置您的密码" : @"请设置您的密码";
    self.label.font = SetFont(26);
    
    self.firstPassword = [[UITextField alloc] init];
    self.firstPassword.placeholder = @"在此输入您的密码";
    self.firstPassword.font = SetFont(12);
    self.firstPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.secondPassword = [[UITextField alloc] init];
    self.secondPassword.placeholder = @"再次确认您的密码";
    self.secondPassword.font = SetFont(12);
    self.secondPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerButton.backgroundColor = [UIColor grayColor];
    NSString *buttonTitle = self.isForgotPassword ? @"确认" : @"注册";
    [self.registerButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(self.registerButton, 20.0);
    
    self.label1 = [[UILabel alloc] init];
    self.label1.font = SetFont(12);
    NSString *str = @"注册即表示您已阅读，并同意《用户注册协议》";
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[str rangeOfString:@"《用户注册协议》"]];
    self.label1.attributedText = attrDescribeStr;
    self.label1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchString)];
    [self.label1 addGestureRecognizer:tap];
    if (self.isForgotPassword) {
        self.label1.hidden = YES;
    }
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.firstPassword];
    [self.view addSubview:self.secondPassword];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.label1];
    
    __weak typeof(self) weakSelf = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    [self.firstPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.secondPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstPassword.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.firstPassword.mas_left);
        make.right.equalTo(weakSelf.firstPassword.mas_right);
        make.height.equalTo(weakSelf.firstPassword.mas_height);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.secondPassword.mas_bottom).offset(40);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.registerButton.mas_bottom).offset(2);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
}

//跳转到用户协议
- (void)touchString {
    DealViewController *deal = [[DealViewController alloc] init];
    [self.navigationController pushViewController:deal animated:YES];
}

//跳转到注册成功欢迎界面
- (void)touchBtn {
    //校验两次输入的密码是否一致
    if ([self.firstPassword.text isEqualToString:self.secondPassword.text]) {
        //表示未注册过的新号码   登录操作
        NSDictionary *parma = @{@"new_password":self.secondPassword.text};
        __weak typeof(self) weakSelf = self;
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/set_password" Dic:parma SuccessBlock:^(id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1) {
                if (weakSelf.isForgotPassword) {
                    //表示忘记密码  应该调用忘记密码的接口  重置密码
                    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    //保存登录状态   表示登录成功
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                    [app_delegate setHomeVCToWindowRoot];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:weakSelf.current_phone forKey:@"huanxinID"];
                    [[EMClient sharedClient] loginWithUsername:weakSelf.current_phone password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
                        if (!aError) {
                            NSLog(@"登录成功！！！");
                        }else {
                            NSLog(@"aError === %@", aError.errorDescription);
                        }
                    }];
                    
                    return;
                }
                //保存登录状态   表示登录成功
                [[NSUserDefaults standardUserDefaults] setObject:weakSelf.current_phone forKey:@"account"];
                
                [[EMClient sharedClient] registerWithUsername:weakSelf.current_phone password:@"123456"];
                
                //环信注册
                NSString *appToken = [[NSUserDefaults standardUserDefaults] objectForKey:APP_TOKEN];
                [weakSelf registerHuanxinUserToService:appToken];
                
//                [[EMClient sharedClient] registerWithUsername:weakSelf.current_phone password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
//                    if (!aError) {
//
//                    }else {
//                        [self showHUDWithTitle:@"环信注册失败！！！"];
//                    }
//                }];
            }else {
                [weakSelf showHUDWithTitle:@"登录失败"];
            }
        } FailureBlock:^(id error) {
            [weakSelf showHUDWithTitle:@"登录失败"];
        }];
    }else {
        [self showHUDWithTitle:@"两次输入的密码不一致，请重新输入"];
    }
}

//增加环信用户到我们自己的后台
- (void)registerHuanxinUserToService:(NSString *)app_token {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_im_name" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"add huanxin user == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            //登录状态
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.current_phone forKey:@"huanxinID"];
            [[EMClient sharedClient] loginWithUsername:weakSelf.current_phone password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    NSLog(@"登录成功！！！");
                }else {
                    NSLog(@"aError === %@", aError.errorDescription);
                }
            }];
            
            LoginSuccessViewController *success = [[LoginSuccessViewController alloc] init];
            [weakSelf.navigationController pushViewController:success animated:YES];
        }else {
            NSLog(@"添加环信用户到后台失败");
        }
    } FailureBlock:^(id error) {
        NSLog(@"添加环信用户到后台失败");
    }];
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
