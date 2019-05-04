//
//  PasswordViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PasswordViewController.h"
#import "SetPasswordViewController.h"

@interface PasswordViewController ()

@property (nonatomic, assign) NSInteger second;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIButton *date;

//提示验证码是否错误
@property (nonatomic, strong) UILabel *messageLabel;

//保存后台返回的验证码
@property (nonatomic, strong) NSString *code_string;

@property (nonatomic, strong) UITextField *code;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self setBack];
}
    
- (void)setUI {
    UILabel *label = [[UILabel alloc] init];
    label.text = self.forgotPassword ? @"忘记密码?" : @"请输入验证码";
    label.font = SetFont(32);
    [self.view addSubview:label];
    
    UILabel *phone = [[UILabel alloc] init];
    phone.text = self.phone;
    phone.font = SetFont(13);
    [self.view addSubview:phone];
    
    self.date = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.date setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.date.titleLabel.font = SetFont(13);
    [self.date setTitleColor:SetColor(48, 132, 252, 1) forState:UIControlStateNormal];
    [self.date addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.date];
    
    //验证码
    self.code = [[UITextField alloc] init];
    self.code.font = SetFont(18);
    self.code.keyboardType = UIKeyboardTypeNumberPad;
    self.code.placeholder = @"请输入短信验证码";
    [self.view addSubview:self.code];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = SetFont(12);
    self.messageLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.messageLabel];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.backgroundColor = [UIColor grayColor];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    ViewRadius(next, 25.0);
    [next addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
    
    __weak typeof(self) weakSelf = self;
    //请输入验证码
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    //手机号码
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(weakSelf.view.mas_right).offset(-100);
        make.height.mas_equalTo(30);
    }];
    
    //倒计时
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(phone.mas_right).offset(5);
        make.top.equalTo(phone.mas_top);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    //验证码
    [self.code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phone.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.code.mas_bottom);
        make.left.equalTo(weakSelf.code.mas_left);
        make.right.equalTo(weakSelf.code.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    //提示信息
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.code.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.code.mas_left);
    }];
    
    //按钮
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.messageLabel.mas_bottom).offset(60);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
}

#pragma mark ----  需要修改
//点击获取验证码
- (void)getCode {
    self.second = 60;
    self.date.enabled = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction) userInfo:nil repeats:YES];
    NSDictionary *parme = @{@"login_name" : self.phone};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/send_register_verify_code" Dic:parme SuccessBlock:^(id responseObject) {
        NSLog(@"code === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            //表示请求验证码成功    对验证码进行赋值操作
            weakSelf.code_string = responseObject[@"data"];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//定时器方法
- (void)timerFunction {
    --self.second;
    [self.date setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.date setTitle:[NSString stringWithFormat:@"(%ld秒)", self.second] forState:UIControlStateNormal];
    if (self.second == 0) {
        [self.date setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.date.enabled = YES;
        [self.date setTitleColor:SetColor(48, 132, 252, 1) forState:UIControlStateNormal];
    }
}

- (void)touchBtn {
    //进行验证码校验
    if ([self.code_string isEqualToString:@"成功"] && ![self.code.text isEqualToString:@""]) {
        //验证码校验成功之后    用验证码去注册用户
        NSDictionary *parma = @{
                                @"login_name":self.phone,
                                @"verify_code":self.code.text
                                };
        __weak typeof(self) weakSelf = self;
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/user_verify_register" Dic:parma SuccessBlock:^(id responseObject) {
            NSLog(@"通过验证码注册 === %@", responseObject);
            //表示注册成功
            if ([responseObject[@"state"] integerValue] == 1) {
                //存储app_token
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"app_token"] forKey:APP_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"user_information"][0][@"class_name"] forKey:@"class_name"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"user_information"][0][@"register_id_"] forKey:@"user_id"];
                
                SetPasswordViewController *set = [[SetPasswordViewController alloc] init];
                if (weakSelf.forgotPassword) {
                    //忘记密码   跳转重置密码界面
                    set.isForgotPassword = YES;
                }
                set.current_phone = weakSelf.phone;
                [weakSelf.navigationController pushViewController:set animated:YES];
            }
        } FailureBlock:^(id error) {
            
        }];
    }else {
        self.messageLabel.text = @"验证码错误,请重新输入";
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
