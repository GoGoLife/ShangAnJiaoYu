//
//  MyPartnerDynamicViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "MyPartnerDynamicViewController.h"
#import "PartnerCircelHeaderView.h"
#import "PartnerCircleCommantTableViewCell.h"

#import "ShowPersonalInfoViewController.h"

//数据model
#import "PartnerCircleModel.h"
#import "PartnerCommentModel.h"
#import <UIImageView+WebCache.h>
#import <Hyphenate/Hyphenate.h>

@interface MyPartnerDynamicViewController ()<UITableViewDelegate, UITableViewDataSource, PartnerCircleHeaderViewDelegate>

@property (nonatomic, strong) UILabel *title_label;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSDictionary *personalDic;

@end

@implementation MyPartnerDynamicViewController

- (void)getHttpData {
    
    NSDictionary *parma = @{};
    if (self.phone && self.other_id_) {
        parma = @{
                  @"page_number":@"1",
                  @"page_size":@"200",
                  @"other_id_":self.other_id_
                  };
    }else {
        parma = @{
                  @"page_number":@"1",
                  @"page_size":@"200",
                  @"my_moments":@"1"
                  };
    }
    
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_moments" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"my dynamic response == %@", responseObject);
        __weak typeof(self) weakSelf = self;
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"]) {
                PartnerCircleModel *model = [[PartnerCircleModel alloc] init];
                model.moments_id_ = dic[@"moments_id_"];
                model.content_ = dic[@"moment_message"][@"content_"];
                model.create_time_ = dic[@"moment_message"][@"create_time_"];
                model.moment_picture_url_array = dic[@"moment_message"][@"moment_picture_url_"];
                model.level_ = dic[@"user_message"][@"level_"];
                model.login_name_ = dic[@"user_message"][@"login_name_"];
                model.picture_ = dic[@"user_message"][@"picture_"];
                model.sex_ = dic[@"user_message"][@"sex_"];
                model.signature_ = dic[@"user_message"][@"signature_"];
                model.user_name_ = dic[@"user_message"][@"user_name_"];
                model.user_like_status = [dic[@"moment_message"][@"user_like_status"] integerValue];
                model.praise_number_string = [NSString stringWithFormat:@"%ld人点赞", [dic[@"comment_like_message"][@"total_"] integerValue]];
                model.comment_number_string = [NSString stringWithFormat:@"%ld", [dic[@"comment_dict"] count]];
                //评论内容
                NSMutableArray *comment_array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *comment_dic in dic[@"comment_dict"]) {
                    PartnerCommentModel *commentModel = [[PartnerCommentModel alloc] init];
                    commentModel.id_ = comment_dic[@"id_"];
                    commentModel.content_ = comment_dic[@"content_"];
                    commentModel.create_time_ = comment_dic[@"create_time_"];
                    commentModel.name_ = comment_dic[@"name_"];
                    commentModel.parent_id_ = comment_dic[@"parent_id_"];
                    commentModel.parent_name_ = comment_dic[@"parent_name_"];
                    commentModel.parent_user_id_ = comment_dic[@"parent_user_id_"];
                    commentModel.picture_ = comment_dic[@"picture_"];
                    commentModel.user_id_ = comment_dic[@"user_id_"];
                    [comment_array addObject:commentModel];
                }
                model.comment_array = [comment_array copy];
                [dataArray addObject:model];
            }
            weakSelf.dataArray = [dataArray copy];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的考伴动态";
    [self setBack];
    
//    [self setShowPersonInfomationView];
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[PartnerCircleCommantTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [self getHttpDataWithPersonal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo) name:@"ChangeUserInfoNotifacation" object:nil];
}

- (void)changeUserInfo {
    [self getHttpDataWithPersonal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    PartnerCircleModel *model = self.dataArray[section - 1];
    return model.comment_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    }
    PartnerCircleModel *model = self.dataArray[indexPath.section - 1];
    PartnerCommentModel *commentModel = model.comment_array[indexPath.row];
    PartnerCircleCommantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.header_image sd_setImageWithURL:[NSURL URLWithString:commentModel.picture_] placeholderImage:[UIImage imageNamed:@"date"]];
    cell.name_label.text = commentModel.name_;
    cell.comment_content_label.text = commentModel.finish_content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.0;
    }
    PartnerCircleModel *model = self.dataArray[indexPath.section - 1];
    PartnerCommentModel *commentModel = model.comment_array[indexPath.row];
    return commentModel.comment_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 220.0;
    }
    PartnerCircleModel *model = self.dataArray[section - 1];
    return model.infomation_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header_view = [[UIView alloc] init];
        header_view.backgroundColor = WhiteColor;
        [self setShowPersonInfomationView:header_view];
        return header_view;
    }
    PartnerCircleModel *model = self.dataArray[section - 1];
    PartnerCircelHeaderView *header_view = [[PartnerCircelHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, model.infomation_height)];
    header_view.delegate = self;
    [header_view layoutIfNeeded];
    header_view.section = section - 1;
    header_view.isShowDeleteButton = YES;
    [header_view.header_image sd_setImageWithURL:[NSURL URLWithString:model.picture_] placeholderImage:[UIImage imageNamed:@"date"]];
    header_view.name_label.text = model.user_name_;
    header_view.date_label.text = model.create_time_;
    header_view.content_label.text = model.content_;
    header_view.user_like_status = model.user_like_status;
    header_view.spotPraise_label.text = model.praise_number_string;
    header_view.comment_label.text = model.comment_number_string;
    header_view.collection_data_array = model.moment_picture_url_array;
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = SetColor(246, 246, 246, 1);
    return footer_view;
}


//设置个头信息
- (void)setShowPersonInfomationView:(UIView *)header_view {
//    PartnerCircleModel *model = self.dataArray[0];
    UIImageView *header = [[UIImageView alloc] init];
    [header sd_setImageWithURL:[NSURL URLWithString:self.personalDic[@"picture"]] placeholderImage:[UIImage imageNamed:@"date"]];
    ViewRadius(header, 30.0);
    [header_view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UIButton *edit_button = [UIButton buttonWithType:UIButtonTypeCustom];
    edit_button.titleLabel.font = SetFont(14);
    edit_button.backgroundColor = ButtonColor;
    [edit_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    if (self.phone && self.other_id_) {
        [edit_button setTitle:@"添加好友" forState:UIControlStateNormal];
        [edit_button addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [edit_button setTitle:@"编辑信息" forState:UIControlStateNormal];
        [edit_button addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    ViewRadius(edit_button, 15.0);
    [header_view addSubview:edit_button];
    [edit_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.centerY.equalTo(header.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(85, 30));
    }];
    
    UILabel *name_label = [[UILabel alloc] init];
    name_label.font = SetFont(22);
    name_label.text = self.personalDic[@"nickname"] ?: self.personalDic[@"name_"];
    [header_view addSubview:name_label];
    [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(10);
        make.left.equalTo(header.mas_left);
    }];
    
    UILabel *partner_number_label = [[UILabel alloc] init];
    partner_number_label.font = SetFont(14);
    partner_number_label.textColor = DetailTextColor;
    partner_number_label.text = [NSString stringWithFormat:@"考伴号：%@", self.personalDic[@"name_"]];
    [header_view addSubview:partner_number_label];
    [partner_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name_label.mas_bottom).offset(10);
        make.left.equalTo(name_label.mas_left);
    }];
    
    UILabel *details_label = [[UILabel alloc] init];
    details_label.font = SetFont(14);
    details_label.textColor = DetailTextColor;
    details_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
//    details_label.numberOfLines = 0;
    details_label.text = [self.personalDic[@"signature_"] isEqualToString:@""] ? @"签名：未设置" : [NSString stringWithFormat:@"签名:%@", self.personalDic[@"signature_"]];
    [header_view addSubview:details_label];
    [details_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(partner_number_label.mas_bottom).offset(20);
        make.left.equalTo(partner_number_label.mas_left);
    }];
    
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(16);
    self.title_label.text = [NSString stringWithFormat:@"我的考伴动态(%ld)", self.dataArray.count];
    [header_view addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(details_label.mas_bottom).offset(20);
        make.left.equalTo(details_label.mas_left);
    }];
    
}

//跳转编辑个人信息界面
- (void)editButtonAction {
//    PartnerCircleModel *model = self.dataArray[0];
    ShowPersonalInfoViewController *personal = [[ShowPersonalInfoViewController alloc] init];
    personal.im_name = self.personalDic[@"name_"];//model.login_name_;
    [self.navigationController pushViewController:personal animated:YES];
}

//删除动态
- (void)touchDeleteButtonAction:(NSInteger)section {
    PartnerCircleModel *model = self.dataArray[section];
    NSDictionary *parma = @{@"id_":model.moments_id_};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_moments" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf showHUDWithTitle:@"删除成功"];
            [weakSelf getHttpData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//通过接口获取个人信息
- (void)getHttpDataWithPersonal {
    NSDictionary *parma = @{@"im_name_":self.phone};//[[NSUserDefaults standardUserDefaults] objectForKey:@"huanxinID"]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_user_message" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"personal information === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.personalDic = responseObject[@"data"];
            //个人信息获取成功之后   获取我的动态数据
            [weakSelf getHttpData];
//            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

/**
 添加好友 方法
 */
- (void)addFriendAction {
    __weak typeof(self) weakSelf = self;
    [[EMClient sharedClient].contactManager addContact:self.phone message:@"" completion:^(NSString *aUsername, EMError *aError) {
        if (aError) {
            [weakSelf showHUDWithTitle:@"查找并添加好友失败"];
        }else {
            [weakSelf showHUDWithTitle:@"添加好友请求发送成功"];
            //查找并添加好友成功   通知刷新好友列表
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"changedFriendList" object:nil];
//            weakSelf.AddFriendSuccess();
//            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
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
