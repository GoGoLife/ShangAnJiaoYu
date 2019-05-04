//
//  SaveMessageViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SaveMessageViewController.h"
#import "EssayTests_HomeViewController.h"

@interface SaveMessageViewController ()

@property (nonatomic, strong) UITextView *textview;

@end

@implementation SaveMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @"总结提醒栏(将保存至您的总结本-申论总结中)";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(back_view, 8.0);
    [self.view addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(180);
    }];
    
    self.textview = [[UITextView alloc] init];
    self.textview.backgroundColor = SetColor(246, 246, 246, 1);
    self.textview.font = SetFont(14);
    self.textview.textColor = SetColor(74, 74, 74, 1);
    self.textview.text = @"在此输入";
    [back_view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = SetColor(192, 192, 192, 1);
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button setTitle:@"提交并保存" forState:UIControlStateNormal];
    ViewRadius(button, 25.0);
    [button addTarget:self action:@selector(submitAndSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_bottom).offset(50);
        make.left.equalTo(weakSelf.view.mas_left).offset(30);
        make.right.equalTo(weakSelf.view.mas_right).offset(-30);
        make.height.mas_equalTo(50);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 提交并保存  实现方法    同时返回到最开始的界面
 */
- (void)submitAndSaveAction {
    
    NSString *question_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"big_essayTest_id"];
    
    NSArray *id_array = @[question_id];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:id_array options:kNilOptions error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *parma = @{@"content_":self.textview.text,
                            @"question_id_":jsonString,
                            @"type_":@"4"
                            };
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_tips_total" Dic:parma imageArray:@[] SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf deleteUserMaterials];
            [weakSelf hidden];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[EssayTests_HomeViewController class]]) {
                    EssayTests_HomeViewController *A =(EssayTests_HomeViewController *)controller;
                    [weakSelf.navigationController popToViewController:A animated:YES];
                }
            }
        }
    } FailureBlock:^(id error) {
        
    }];
}

/**
 删除用户做题时间的所有的采点信息
 */
- (void)deleteUserMaterials {
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_user_question_catch" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"材料采点删除成功");
        }else {
            NSLog(@"材料采点删除失败");
        }
    } FailureBlock:^(id error) {
        NSLog(@"材料采点删除失败");
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
