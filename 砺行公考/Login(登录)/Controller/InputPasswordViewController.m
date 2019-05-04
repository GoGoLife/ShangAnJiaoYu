//
//  InputPasswordViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/2.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "InputPasswordViewController.h"
#import "PasswordViewController.h"
#import <Hyphenate/Hyphenate.h>

@interface InputPasswordViewController ()

@property (nonatomic, strong) UILabel *phone_label;

@property (nonatomic, strong) UITextField *password;

@end

@implementation InputPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    [self setBack];
}

- (void)setUI {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(32);
    label.text = @"请输入您的密码";
    [self.view addSubview:label];
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(40);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    self.phone_label = [[UILabel alloc] init];
//    phone.text = @"18268865135";
    self.phone_label.text = self.phone;
    [self.view addSubview:self.phone_label];
    [self.phone_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(30);
        make.left.equalTo(label.mas_left);
    }];
    
    self.password = [[UITextField alloc] init];
    self.password.secureTextEntry = YES;
//    self.password.text = @"123456";
    //纯数字键盘
    self.password.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.password];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phone_label.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.phone_label.mas_left);
        make.right.equalTo(weakSelf.view.mas_right).offset(-70);
        make.height.mas_equalTo(44);
    }];
    
    //切换明密文按钮
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.backgroundColor = [UIColor redColor];
    [changeBtn addTarget:self action:@selector(clickDisplayTextFieldText:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-30);
        make.centerY.equalTo(weakSelf.password.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.password.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *forgotPass = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotPass.titleLabel.font = SetFont(12);
    [forgotPass setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgotPass setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [forgotPass addTarget:self action:@selector(pushForgotPasswordView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPass];
    [forgotPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(5);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
    }];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setTitle:@"登录" forState:UIControlStateNormal];
    next.backgroundColor = [UIColor grayColor];
    [next addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(next, 25.0);
    [self.view addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgotPass.mas_bottom).offset(50);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
        make.height.mas_equalTo(50);
    }];
    
}

//密码的明密文切换
- (void)clickDisplayTextFieldText:(UIButton *)button {
    
    button.selected = !button.selected;
    self.password.font = [UIFont systemFontOfSize:17];
    if (button.selected) {
            self.password.secureTextEntry = NO;
        } else{
            self.password.secureTextEntry = YES;
        }
}

- (void)pushForgotPasswordView {
    PasswordViewController *password = [[PasswordViewController alloc] init];
    password.forgotPassword = YES;
    password.phone = self.phone;
    [self.navigationController pushViewController:password animated:YES];
}

//登录操作
- (void)login {
//    if (![self evaluatePassword:self.password.text]) {
//        [self showHUDWithTitle:@"密码格式不对"];
//        return;
//    }
    if (![self.phone_label.text isEqualToString:self.phone]) {
        [self showHUDWithTitle:@"账号不正确"];
        return;
    }
    
    
    
    NSDictionary *dic = @{
                          @"login_name" : self.phone_label.text,//@"18268865135",
                          @"login_password" : self.password.text//@"123456"
                          };
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/user_password_login" Dic:dic SuccessBlock:^(id responseObject) {
        NSLog(@"login success === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            __weak typeof(self) weakSelf = self;
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"app_token"] forKey:APP_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"user_information"][0][@"class_name"] forKey:@"class_name"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"user_information"][0][@"register_id_"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.phone_label.text forKey:@"account"];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.phone_label.text forKey:@"huanxinID"];
            
            
            [[EMClient sharedClient] registerWithUsername:weakSelf.phone password:@"123456"];
            
            //环信注册
            NSString *appToken = [[NSUserDefaults standardUserDefaults] objectForKey:APP_TOKEN];
            [weakSelf registerHuanxinUserToService:appToken];
            
//            [[EMClient sharedClient] loginWithUsername:weakSelf.phone_label.text password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
//                if (!aError) {
//                    NSLog(@"登录成功！！！");
//                }else {
//                    NSLog(@"aError === %@", aError.errorDescription);
//                }
//            }];
            
            
//            AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            //保存登录状态   表示登录成功
//            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
//            [app_delegate setHomeVCToWindowRoot];

        }else {
            
        }
    } FailureBlock:^(id error) {
        NSLog(@"login error === %@", error);
    }];
}

//正则校验密码
- (BOOL)evaluatePassword:(NSString *)password {
    NSString *string = @"/^\\S{6,64}$/";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", string];
    return [predicate evaluateWithObject:password];
}

//增加环信用户到我们自己的后台
- (void)registerHuanxinUserToService:(NSString *)app_token {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_im_name" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"add huanxin user == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1 || [responseObject[@"msg"] isEqualToString:@"环信用户已经存在"]) {
            //登录状态
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
//            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.phone forKey:@"huanxinID"];
            [[EMClient sharedClient] loginWithUsername:weakSelf.phone password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    NSLog(@"登录成功！！！");
                }else {
                    NSLog(@"aError === %@", aError.errorDescription);
                }
            }];
            
            AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            //保存登录状态   表示登录成功
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
            [app_delegate setHomeVCToWindowRoot];
            
//            LoginSuccessViewController *success = [[LoginSuccessViewController alloc] init];
//            [weakSelf.navigationController pushViewController:success animated:YES];
        }else {
            NSLog(@"添加环信用户到后台失败");
        }
    } FailureBlock:^(id error) {
        NSLog(@"添加环信用户到后台失败");
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
