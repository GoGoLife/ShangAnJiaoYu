//
//  ServiceCenterViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ServiceCenterViewController.h"

@interface ServiceCenterViewController ()

@end

@implementation ServiceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"客服中心";
    [self setBack];
    
    [self initViewUI];
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(32);
    label.text = @"砺行客服中心";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    UILabel *phone1 = [[UILabel alloc] init];
    phone1.font = SetFont(14);
    phone1.textColor = DetailTextColor;
    phone1.text = @"一号线：0579-8868-8990";
    [self.view addSubview:phone1];
    [phone1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
    }];
    
    UILabel *phone2 = [[UILabel alloc] init];
    phone2.font = SetFont(14);
    phone2.textColor = DetailTextColor;
    phone2.text = @"二号线：0579-8868-8990";
    [self.view addSubview:phone2];
    [phone2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phone1.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
    }];
    
    UILabel *phone3 = [[UILabel alloc] init];
    phone3.font = SetFont(14);
    phone3.textColor = DetailTextColor;
    phone3.text = @"三号线：0579-8868-8990";
    [self.view addSubview:phone3];
    [phone3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phone2.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = SetFont(12);
    label2.textColor = DetailTextColor;
    label2.text = @"热线服务时间为工作日的 9:00-12:00 与 13:00-17:00";
    [self.view addSubview:label2];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phone3.mas_bottom).offset(20);
        make.left.equalTo(phone3.mas_left);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.font = SetFont(12);
    label3.textColor = DetailTextColor;
    label3.numberOfLines = 0;
    label3.text = @"如果不再服务时间或热线较忙的情况下，可以先留下您的信息，我们的工作人员会在24个工作小时内致电提供服务哦～";
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(line.mas_left);
        make.right.equalTo(line.mas_right);
    }];
    
    UITextField *user_phone = [[UITextField alloc] init];
    user_phone.backgroundColor = SetColor(246, 246, 246, 1);
    user_phone.font = SetFont(14);
    user_phone.textColor = DetailTextColor;
    
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    user_phone.leftView = left_label;
    user_phone.leftViewMode = UITextFieldViewModeAlways;
    
    user_phone.text = @"请输入您的电话号码";
    ViewRadius(user_phone, 8.0);
    [self.view addSubview:user_phone];
    [user_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(10);
        make.left.equalTo(line.mas_left);
        make.right.equalTo(line.mas_right);
        make.height.mas_equalTo(50.0);
    }];
    
    UITextView *textview = [[UITextView alloc] init];
    textview.font = SetFont(14);
    textview.backgroundColor = SetColor(246, 246, 246, 1);
    textview.textColor = DetailTextColor;
    textview.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    textview.text = @"简要描述您的问题～";
    ViewRadius(textview, 8.0);
    [self.view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(user_phone.mas_bottom).offset(10);
        make.left.equalTo(user_phone.mas_left);
        make.right.equalTo(user_phone.mas_right);
        make.height.mas_equalTo(180);
    }];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.backgroundColor = ButtonColor;
    [submit setTitleColor:WhiteColor forState:UIControlStateNormal];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    ViewRadius(submit, 25.0);
    [self.view addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
        make.height.mas_equalTo(50.0);
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
