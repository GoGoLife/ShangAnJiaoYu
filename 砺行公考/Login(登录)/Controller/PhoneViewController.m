//
//  PhoneViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PhoneViewController.h"
#import "PasswordViewController.h"
#import "InputPasswordViewController.h"

@interface PhoneViewController ()

@property (nonatomic, strong) UITextField *phone;

@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Hello!";
    label.font = SetFont(22);
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"欢迎回来";
    label1.font = SetFont(22);
    [self.view addSubview:label1];
    
    self.phone = [[UITextField alloc] init];
    self.phone.placeholder = @"请输入您的手机号";
    self.phone.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phone];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(191, 191, 191, 1);
    [self.view addSubview:line];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    next.backgroundColor = [UIColor grayColor];
    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ViewRadius(next, 25.0);
    [next addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
    
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
    }];
    
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(20);
        make.left.equalTo(label1.mas_left);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phone.mas_bottom);
        make.left.equalTo(weakSelf.phone.mas_left);
        make.right.equalTo(weakSelf.phone.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(40);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
}

//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile {
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else {
            return NO;
        }
    }
}

- (void)touchBtn {
    if (![self valiMobile:self.phone.text]) {
        [self showHUDWithTitle:@"请输入正确的手机号码"];
        return;
    }
    
    //判断用户是否已经注册过APP
    NSDictionary *dic = @{@"login_name":self.phone.text};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/is_user_register" Dic:dic SuccessBlock:^(id responseObject) {
        NSLog(@"verify_is_register ==== %@", responseObject);
        //state == 0 未注册   state == 1  已注册
        if ([responseObject[@"state"] integerValue] == 1) {
            if ([responseObject[@"data"][@"status"] integerValue] && [responseObject[@"data"][@"is_password"] integerValue]) {
                //表示已经注册
                //已经注册过的  跳转到填写密码界面
                InputPasswordViewController *input = [[InputPasswordViewController alloc] init];
                input.phone = self.phone.text;
                [self.navigationController pushViewController:input animated:YES];
            }else {
                PasswordViewController *password = [[PasswordViewController alloc] init];
                password.phone = self.phone.text;
                [self.navigationController pushViewController:password animated:YES];
            }
        }else {
            [self showHUDWithTitle:@"接口请求失败"];
        }
    } FailureBlock:^(id error) {
        
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
