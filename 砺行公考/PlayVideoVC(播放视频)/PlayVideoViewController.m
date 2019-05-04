//
//  PlayVideoViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/28.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PlayVideoViewController.h"
#import <SJVideoPlayer.h>
#import "ChatTableViewCell.h"
#import "ChatMessageModel.h"
#import "TcpClientLib.h"


@interface PlayVideoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SJVideoPlayer *player;

/* 聊天界面 */
@property (nonatomic, strong) UITableView *tableview;

//发表评论输入框
@property (nonatomic, strong) UIView *bottom_tool;

//评论输入框
@property (nonatomic, strong) UITextField *input_comment_textfield;

@property (nonatomic, strong) NSMutableArray *chatHistoryMessageArray;


/** Socket */
@property (nonatomic, strong) TcpClientLib *client;

@property (nonatomic, assign) int sid;


@end

@implementation PlayVideoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[self GetImageWithColor:[UIColor clearColor] andHeight:64.0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //断开连接
//    [self.client disconnect:self.sid];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self connectSocket];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chatHistoryMessageArray = [NSMutableArray arrayWithCapacity:1];
    
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.view = view;
    self.player = [SJVideoPlayer player];
    self.player.view.frame = FRAME(0, 0, SCREENBOUNDS.width, 200);
    [self.view addSubview:self.player.view];
    self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.video_path]];
    self.player.autoPlay = NO;
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.player.view.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-50);
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
    
    //添加输入框和表情按钮
    [self setToolBarContent:self.bottom_tool];
    
    //注册按钮通知
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    /* 增加监听（当键盘退出时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //注册接收投票内容的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVoteView:) name:@"VoteNotifacation" object:nil];
}

#pragma mark ********* 通知执行方法 **********
- (void)showVoteView:(NSNotification *)notifacation {
    NSLog(@"user info == %@", notifacation.userInfo);
    if ([notifacation.userInfo[@"data"] isEqualToString:@""] || !notifacation.userInfo[@"data"]) {
        return;
    }
    
    NSString *userInfoString = notifacation.userInfo[@"data"];
    NSData *data = [userInfoString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    __weak typeof(self) weakSelf = self;
    //主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        VHallChatModel *model = [[VHallChatModel alloc] init];
        model.user_name = dataDic[@"name_"];
        model.text = dataDic[@"content_"];
        [weakSelf.chatHistoryMessageArray addObject:model];
        weakSelf.input_comment_textfield.text = @"";
        [weakSelf.input_comment_textfield resignFirstResponder];
        [weakSelf.tableview reloadData];
        [weakSelf.tableview scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

#pragma mark --- uitableview delegate  datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatHistoryMessageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VHallChatModel *model = self.chatHistoryMessageArray[indexPath.row];
    ChatTableViewCell *cell = [ChatTableViewCell cellWithTableView:tableView messageModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

#pragma mark ---- 评论视图
- (void)setToolBarContent:(UIView *)tool {
    //评论按钮
    UIButton *comment_button = [UIButton buttonWithType:UIButtonTypeCustom];
    comment_button.titleLabel.font = SetFont(14);
    [comment_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [comment_button setTitle:@"发送" forState:UIControlStateNormal];
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
    
    ViewRadius(self.input_comment_textfield, 17.0);
    [tool addSubview:self.input_comment_textfield];
    [self.input_comment_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tool.mas_top).offset(8);
        make.left.equalTo(tool.mas_left).offset(20);
        make.bottom.equalTo(tool.mas_bottom).offset(-8);
        make.right.equalTo(comment_button.mas_left).offset(-10);
    }];
}

/**
 发送消息
 */
- (void)submitCommentContentAction {
    if ([self.input_comment_textfield.text isEqualToString:@""]) {
        [self showHUDWithTitle:@"聊天信息不能为空"];
        return;
    }
    
//    NSDictionary *dic = @{@"ip_":@"127.0.0.2",
//                          @"room_id_":@"110",
//                          @"name_":[[NSUserDefaults standardUserDefaults] objectForKey:@"account"],
//                          @"content_":self.input_comment_textfield.text,
//                          @"type_":@"2",
//                          @"identity_":@"2",
//                          @"personnel_id_":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
//                          };
//
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//
//    [self.client async_send:self.sid data:jsonString];
    
}

/** 键盘弹出 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [aNotification userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [value CGRectValue].size.height;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
        [weakSelf.bottom_tool mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(-height);
        }];
    }];
}

/** 键盘退出 */
- (void)keyboardWillHide:(NSNotification *)aNotification  {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.bottom_tool mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(0);
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------- Socket -----------
- (void)connectSocket {
    //    47.110.40.243:  9102
    NSString * ip = @"192.168.0.192";
    int port = 9102;
    
    self.client = [[TcpClientLib alloc] init];
    
    self.sid = [self.client connect:ip port:port];
    
    NSLog(@"self.sid === %d", self.sid);
    
//    {'ip_':'127.0.0.2', 'room_id_': '110', 'name_': 'wencong_user', 'content_': 'wencong_content_user', 'type_': '2', 'identity': '2', 'employee_id_': 'ae0060a9b496432d8592180365bd984a'}
    
//    NSDictionary *dic = @{@"ip_":@"127.0.0.2",
//                          @"room_id_":@"110",
//                          @"name_":@"wencong_user",
//                          @"content_":@"wencong_content_user",
//                          @"type_":@"2",
//                          @"identity_":@"2",
//                          @"personnel_id_":@"ae0060a9b496432d8592180365bd990a",
//                          };
//
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self.client add_event];
    
    [self.client async_receive:self.sid];
    
//    [self.client async_send:self.sid data:jsonString];
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
