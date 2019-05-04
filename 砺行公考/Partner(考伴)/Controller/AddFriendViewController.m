//
//  AddFriendViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AddFriendViewController.h"
#import <Hyphenate/Hyphenate.h>
#import "MyPartnerDynamicViewController.h"

@interface AddFriendViewController ()

@property (nonatomic, strong) UITextField *field;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加朋友";
    
    [self setBack];
    
    self.field = [[UITextField alloc] init];
    self.field.font = SetFont(14);
    self.field.placeholder = @"请输入手机号";
    self.field.clearButtonMode = UITextFieldViewModeAlways;
    ViewBorderRadius(self.field, 5.0, 1.0, DetailTextColor);
    
    UILabel *left_view = [[UILabel alloc] init];
    left_view.frame = FRAME(0, 0, 20, 10);
    self.field.leftView = left_view;
    self.field.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.field];
    __weak typeof(self) weakSelf = self;
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *find_button = [UIButton buttonWithType:UIButtonTypeCustom];
    find_button.backgroundColor = ButtonColor;
    [find_button setTitle:@"查找" forState:UIControlStateNormal];
    ViewRadius(find_button, 25.0);
    [find_button addTarget:self action:@selector(searchUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:find_button];
    [find_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.field.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
        make.height.mas_equalTo(50);
    }];
}

- (void)searchUserInfo {
    NSDictionary *parma = @{@"im_name_":self.field.text};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_user_message" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            //表示查找到了信息
            if ([weakSelf isFriendForUser:weakSelf.field.text]) {
                [weakSelf showHUDWithTitle:[NSString stringWithFormat:@"%@已经是您的好友", weakSelf.field.text]];
            }else {
                //跳转到查看信息界面
                MyPartnerDynamicViewController *partner = [[MyPartnerDynamicViewController alloc] init];
                partner.phone = responseObject[@"data"][@"name_"];
                partner.other_id_ = responseObject[@"data"][@"id_"];
                [weakSelf.navigationController pushViewController:partner animated:YES];
            }
        }else {
            [weakSelf showHUDWithTitle:@"未找到联系人"];
        }
    } FailureBlock:^(id error) {
        [weakSelf showHUDWithTitle:@"未找到联系人"];
    }];
}



/**
 判断当前查找的用户是否已经是好友关系

 @param im_name 当前查找的用户
 @return 返回当前关系
 */
- (BOOL)isFriendForUser:(NSString *)im_name {
    __block BOOL isFriend = NO;
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        NSLog(@"alist == %@", aList);
        @try {
            if ([aList containsObject:im_name]) {
                //存在  则表示是好友关系
                isFriend = YES;
            }else {
                isFriend = NO;
            }
        } @catch (NSException *exception) {
            isFriend = NO;
        } @finally {
            isFriend = NO;
        }
    }];
    return isFriend;
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
