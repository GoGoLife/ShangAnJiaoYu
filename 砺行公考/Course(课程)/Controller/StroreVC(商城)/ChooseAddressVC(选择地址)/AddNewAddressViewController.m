//
//  AddNewAddressViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AddNewAddressViewController.h"
#import "selectAddressPicker.h"

@interface AddNewAddressViewController ()

//收货人
@property (nonatomic, strong) UITextField *people_field;

//联系方式
@property (nonatomic, strong) UITextField *phone_field;

//所在地区
@property (nonatomic, strong) UITextField *address_field;

//详细地址
@property (nonatomic, strong) UITextField *details_field;

@property (nonatomic, assign) BOOL is_default;

@end

@implementation AddNewAddressViewController

StringWidth()
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.title = @"添加新地址";
    
    //联系人
    self.people_field = [[UITextField alloc] init];
    self.people_field.font = SetFont(14);
    self.people_field.placeholder = @"请输入联系人";
    
    CGFloat width = [self calculateRowWidth:@"收货人：" withFont:14];
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, width, 20)];
    left_label.textColor = DetailTextColor;
    left_label.font = SetFont(14);
    left_label.text = @"收货人：";
    self.people_field.leftView = left_label;
    self.people_field.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.people_field];
    __weak typeof(self) weakSelf = self;
    [self.people_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(15);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    //手机号码
    self.phone_field = [[UITextField alloc] init];
    self.phone_field.font = SetFont(14);
    self.phone_field.placeholder = @"请输入电话号码";
    
    CGFloat width1 = [self calculateRowWidth:@"联系方式：" withFont:14];
    UILabel *left_label1 = [[UILabel alloc] initWithFrame:FRAME(0, 0, width1, 20)];
    left_label1.textColor = DetailTextColor;
    left_label1.font = SetFont(14);
    left_label1.text = @"联系方式：";
    self.phone_field.leftView = left_label1;
    self.phone_field.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.phone_field];
    [self.phone_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.people_field.mas_bottom).offset(1);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    //所在地
    self.address_field = [[UITextField alloc] init];
    [self.address_field resignFirstResponder];
    self.address_field.font = SetFont(14);
    self.address_field.placeholder = @"请选择所在地";
    self.address_field.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddress)];
    [self.address_field addGestureRecognizer:ges];
    
    
    CGFloat width2 = [self calculateRowWidth:@"所在地区：" withFont:14];
    UILabel *left_label2 = [[UILabel alloc] initWithFrame:FRAME(0, 0, width2, 20)];
    left_label2.textColor = DetailTextColor;
    left_label2.font = SetFont(14);
    left_label2.text = @"所在地区：";
    self.address_field.leftView = left_label2;
    self.address_field.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.address_field];
    [self.address_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phone_field.mas_bottom).offset(1);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    //详细地址
    self.details_field = [[UITextField alloc] init];
    self.details_field.font = SetFont(14);
    self.details_field.placeholder = @"请输入详细地址";
    
    CGFloat width3 = [self calculateRowWidth:@"详细地址：" withFont:14];
    UILabel *left_label3 = [[UILabel alloc] initWithFrame:FRAME(0, 0, width3, 20)];
    left_label3.textColor = DetailTextColor;
    left_label3.font = SetFont(14);
    left_label3.text = @"详细地址：";
    self.details_field.leftView = left_label3;
    self.details_field.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.details_field];
    [self.details_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.address_field.mas_bottom).offset(1);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.details_field.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @"设为默认地址";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(12);
    label1.textColor = DetailTextColor;
    label1.text = @"每次下单时都会使用默认地址";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(3);
        make.left.equalTo(label.mas_left);
    }];
    
    UISwitch *switch_button = [[UISwitch alloc] init];
    switch_button.on = NO;
    self.is_default = NO;
    [switch_button addTarget:self action:@selector(changeSwitchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switch_button];
    [switch_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    UIButton *save_button = [UIButton buttonWithType:UIButtonTypeCustom];
    save_button.backgroundColor = SetColor(48, 132, 252, 1);
    [save_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [save_button setTitle:@"保存" forState:UIControlStateNormal];
    ViewRadius(save_button, 20.0);
    [save_button addTarget:self action:@selector(submitNewAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save_button];
    [save_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
}

- (void)changeSwitchTypeAction:(UISwitch *)switch_button {
    self.is_default = switch_button.on;
}

//选择地址
- (void)selectAddress {
    [self.view endEditing:YES];
    selectAddressPicker *picker = [[selectAddressPicker alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 260 - 64, SCREENBOUNDS.width, 260)];
    __weak typeof(self) weakSelf = self;
    picker.stringblockr = ^(NSString *address) {
        weakSelf.address_field.text = address;
    };
    [self.view addSubview:picker];
}

//提交新地址
- (void)submitNewAddressAction {
    NSString *new_address_string = [NSString stringWithFormat:@"%@-%@", self.address_field.text, self.details_field.text];
    NSDictionary *parma = @{@"name_":self.people_field.text,
                            @"phone_":self.phone_field.text,
                            @"address_":new_address_string,
                            @"is_default_":self.is_default ? @"1" : @"0"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_receiving_address" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"add new address result ==== %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [weakSelf showHUDWithTitle:@"保存失败"];
        }
    } FailureBlock:^(id error) {
        [weakSelf showHUDWithTitle:@"保存失败"];
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
