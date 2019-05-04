//
//  BigEssayThirdViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigEssayThirdViewController.h"
#import "ChooseDefaultContentViewController.h"

@interface BigEssayThirdViewController ()

@property (nonatomic, strong) UITextField *my_field;

@end

@implementation BigEssayThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"撰写标题";
    [self setBack];
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextVC)];
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"示范标题";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    UITextField *default_field = [[UITextField alloc] init];
    
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 20, 0)];
    default_field.leftView = left_label;
    default_field.leftViewMode = UITextFieldViewModeAlways;
    
    default_field.backgroundColor = SetColor(246, 246, 246, 1);
    default_field.font = SetFont(14);
    default_field.text = self.default_title;
    ViewRadius(default_field, 8.0);
    [self.view addSubview:default_field];
    [default_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_greaterThanOrEqualTo(50.0);
    }];
    
    UILabel *my_title_label = [[UILabel alloc] init];
    my_title_label.font = SetFont(14);
    my_title_label.textColor = DetailTextColor;
    my_title_label.text = @"我的标题";
    [self.view addSubview:my_title_label];
    [my_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(default_field.mas_bottom).offset(20);
        make.left.equalTo(default_field.mas_left);
    }];
    
    self.my_field = [[UITextField alloc] init];
    
    UILabel *left_label_my = [[UILabel alloc] initWithFrame:FRAME(0, 0, 20, 0)];
    self.my_field.leftView = left_label_my;
    self.my_field.leftViewMode = UITextFieldViewModeAlways;
    
    self.my_field.backgroundColor = SetColor(246, 246, 246, 1);
    self.my_field.font = SetFont(14);
    ViewRadius(self.my_field, 8.0);
    [self.view addSubview:self.my_field];
    [self.my_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(my_title_label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_greaterThanOrEqualTo(50.0);
    }];
}

- (void)pushNextVC {
    //BigTraining_my_title
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults] setObject:self.my_field.text forKey:@"BigTraining_my_title"];
    ChooseDefaultContentViewController *choose = [[ChooseDefaultContentViewController alloc] init];
    choose.type = ChooseContentType_YinYan;
    [self.navigationController pushViewController:choose animated:YES];
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
