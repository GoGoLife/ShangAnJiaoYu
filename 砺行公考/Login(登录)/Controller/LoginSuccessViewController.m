//
//  LoginSuccessViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "LoginSuccessViewController.h"
#import "FirstQuestionViewController.h"

@interface LoginSuccessViewController ()

@end

@implementation LoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(22);
    label.text = @"登录砺行成功";
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(22);
    label1.text = @"欢迎~";
    [self.view addSubview:label1];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"welcome"];
    [self.view addSubview:imageV];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"希望通过几个问题增进对您的了解";
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"越了解您，我们越能提供的备考计划和课程训练，帮助你实现上岸目标";
    label3.font = SetFont(13);
    label3.textColor = [UIColor grayColor];
    label3.numberOfLines = 0;
    [label3 setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:label3];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    next.backgroundColor = [UIColor blueColor];
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ViewRadius(next, 25.0);
    [next addTarget:self action:@selector(touchNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
    
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(220);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(40);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30);
        make.height.mas_equalTo(50);
    }];
}

- (void)touchNext {
    FirstQuestionViewController *first = [[FirstQuestionViewController alloc] init];
    [self.navigationController pushViewController:first animated:YES];
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
