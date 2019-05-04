//
//  PartnerCircleViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PartnerCircleViewController.h"
#import "PartnerCircelHeaderView.h"
#import "PartnerCircleCommantTableViewCell.h"
#import "PublishDynamicViewController.h"

//数据model
#import "PartnerCircleModel.h"
#import "PartnerCommentModel.h"
#import <UIImageView+WebCache.h>

@interface PartnerCircleViewController ()<UITableViewDelegate, UITableViewDataSource, PartnerCircleHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

//编写评论
@property (nonatomic, strong) UIView *bottom_tool;

@property (nonatomic, strong) UITextField *input_comment_textfield;

//保存点击的是哪个section  以保证回复的评论的正确性
@property (nonatomic, assign) NSInteger comment_section;

@property (nonatomic, assign) NSInteger comment_row;

@property (nonatomic, assign) NSInteger page;

@end

@implementation PartnerCircleViewController

- (void)getHttpData:(NSInteger)page {
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *parma = @{
                            @"page_number":[NSString stringWithFormat:@"%ld", page],
                            @"page_size":@"20",
                            @"my_moments":@"0"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_moments" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"response == %@ page == %ld", responseObject, page);
        if ([responseObject[@"state"] integerValue] == 1) {
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
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableview.mj_header endRefreshing];
            if ([responseObject[@"data"] count] < 20) {
                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableview.mj_footer endRefreshing];
            }
            
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];
}

- (void)setToolBarContent:(UIView *)tool {
    //评论按钮
    UIButton *comment_button = [UIButton buttonWithType:UIButtonTypeCustom];
    comment_button.titleLabel.font = SetFont(14);
    [comment_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [comment_button setTitle:@"评论" forState:UIControlStateNormal];
    [comment_button addTarget:self action:@selector(submitCommentContentAction) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:comment_button];
    [comment_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tool.mas_right).offset(-10);
        make.centerY.equalTo(tool.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    //评论输入框
    self.input_comment_textfield = [[UITextField alloc] init];
    self.input_comment_textfield.backgroundColor = WhiteColor;
    
    self.input_comment_textfield.leftViewMode = UITextFieldViewModeAlways;
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 10, 10)];
    self.input_comment_textfield.leftView = left_label;
    
    self.input_comment_textfield.placeholder = @"写评论";
    ViewRadius(self.input_comment_textfield, 17.0);
    [tool addSubview:self.input_comment_textfield];
    [self.input_comment_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tool.mas_top).offset(8);
        make.left.equalTo(tool.mas_left).offset(20);
        make.bottom.equalTo(tool.mas_bottom).offset(-8);
        make.right.equalTo(comment_button.mas_left).offset(-10);
    }];
    
    //注册按钮通知
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    /* 增加监听（当键盘退出时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.comment_section = -1;
    self.comment_row = -1;
    self.page = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    
    self.view.frame = FRAME(0, 150, self.view.bounds.size.width, self.view.bounds.size.height - 150);
    self.view.backgroundColor = [UIColor redColor];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.estimatedRowHeight = 0;
    self.tableview.estimatedSectionHeaderHeight = 0;
    self.tableview.estimatedSectionFooterHeight = 0;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[PartnerCircleCommantTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIButton *publish_button = [[UIButton alloc] init];
//    publish_button.backgroundColor = ButtonColor;
    [publish_button setImage:[UIImage imageNamed:@"circle_1"] forState:UIControlStateNormal];
    ViewRadius(publish_button, 30);
    [publish_button addTarget:self action:@selector(publishDynamicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publish_button];
    [publish_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.bottom_tool = [[UIView alloc] init];
    self.bottom_tool.backgroundColor = SetColor(238, 238, 238, 1);
    [self.view addSubview:self.bottom_tool];
    [self.bottom_tool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    self.bottom_tool.hidden = YES;
    
    [self setToolBarContent:self.bottom_tool];
    
//    [self getHttpData:1];
    
    //下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getHttpData:1];
    }];
    [self.tableview.mj_header beginRefreshing];
    
    //上拉加载
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getHttpData:weakSelf.page];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PartnerCircleModel *model = self.dataArray[section];
    return model.comment_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerCircleModel *model = self.dataArray[indexPath.section];
    PartnerCommentModel *commentModel = model.comment_array[indexPath.row];
    PartnerCircleCommantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.header_image sd_setImageWithURL:[NSURL URLWithString:commentModel.picture_] placeholderImage:[UIImage imageNamed:@"date"]];
    cell.name_label.text = commentModel.name_;
    cell.comment_content_label.text = commentModel.finish_content;
    return cell;
}

//编写子评论相关
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerCircleModel *model = self.dataArray[indexPath.section];
    PartnerCommentModel *commentModel = model.comment_array[indexPath.row];
    self.input_comment_textfield.text = [NSString stringWithFormat:@"回复%@:", commentModel.name_];
    [self.input_comment_textfield becomeFirstResponder];
    self.bottom_tool.hidden = NO;
    self.comment_section = indexPath.section;
    self.comment_row = indexPath.row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerCircleModel *model = self.dataArray[indexPath.section];
    PartnerCommentModel *commentModel = model.comment_array[indexPath.row];
    return commentModel.comment_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    PartnerCircleModel *model = self.dataArray[section];
    return model.infomation_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PartnerCircleModel *model = self.dataArray[section];
    PartnerCircelHeaderView *header_view = [[PartnerCircelHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, model.infomation_height)];
    header_view.delegate = self;
    header_view.section = section;
    header_view.isShowDeleteButton = NO;
    [header_view layoutIfNeeded];
    [header_view.header_image sd_setImageWithURL:[NSURL URLWithString:model.picture_] placeholderImage:[UIImage imageNamed:@"date"]];
    header_view.name_label.text = model.user_name_;
    header_view.date_label.text = model.create_time_;
    header_view.content_label.text = model.content_;
    header_view.collection_data_array = model.moment_picture_url_array;
    header_view.user_like_status = model.user_like_status;
    header_view.spotPraise_label.text = model.praise_number_string;
    header_view.comment_label.text = model.comment_number_string;
    header_view.content_height = model.content_height + 10.0;
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = SetColor(246, 246, 246, 1);
    return footer_view;
}

//发布新动态
- (void)publishDynamicAction {
    PublishDynamicViewController *publich = [[PublishDynamicViewController alloc] init];
    [self.navigationController pushViewController:publich animated:YES];
}

//点赞
- (void)touchPraiseButtonAction:(NSInteger)section PraiseLabel:(UILabel *)praise_label {
    [self showHUD];
    PartnerCircleModel *model = self.dataArray[section];
    NSString *action = @"";
    if (model.user_like_status == 0) {
        action = @"add";
    }else {
        action = @"remove";
    }
    NSDictionary *param = @{@"moments_id_":model.moments_id_,@"action":action};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/comment_like" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"praise responseObject == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
//            [weakSelf showHUDWithTitle:@"点赞成功"];
            [weakSelf getHttpData:1];
            [weakSelf hidden];
        }else {
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
}

//发布父评论   评论框的相关操作
- (void)touchPublishComment:(NSInteger)section {
    [self.input_comment_textfield becomeFirstResponder];
    self.comment_section = section;
}

//提交父评论内容
- (void)submitCommentContentAction {
    PartnerCircleModel *model = self.dataArray[self.comment_section];
    NSString *parent_id = @"";
    NSString *content = self.input_comment_textfield.text;
    if (self.comment_row >= 0) {
        PartnerCommentModel *commentModel = model.comment_array[self.comment_row];
        parent_id = commentModel.id_;
        NSArray *content_array = [content componentsSeparatedByString:@":"];
        content = [content_array lastObject];
    }
    NSDictionary *parma = @{
                            @"contingency_id_":model.moments_id_,
                            @"content_":content,
                            @"parent_id_":parent_id,
                            @"sort_":@"4"
                            };
    NSLog(@"parma == %@", parma);
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_comment" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"发布评论  考伴 === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf showHUDWithTitle:@"发布成功"];
            [weakSelf.input_comment_textfield resignFirstResponder];
            weakSelf.bottom_tool.hidden = YES;
            [weakSelf getHttpData:weakSelf.page];
        }
    } FailureBlock:^(id error) {

    }];
}

//tableview 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.bottom_tool.hidden = YES;
    [self.input_comment_textfield resignFirstResponder];
}

//键盘出现    实现方法
/**
 *  键盘弹出
 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    self.bottom_tool.hidden = NO;
}

/**
 *  键盘退出
 */
- (void)keyboardWillHide:(NSNotification *)aNotification  {
    self.bottom_tool.hidden = YES;
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
