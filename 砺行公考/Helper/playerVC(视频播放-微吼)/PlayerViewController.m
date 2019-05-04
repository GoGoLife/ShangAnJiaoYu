//
//  PlayerViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/26.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PlayerViewController.h"
#import "VHallApi.h"
#import "GlobarFile.h"
#import "ChatTableViewCell.h"
#import "ChatMessageModel.h"
#import "VHRoom.h"
#import <IQKeyboardManager.h>
#import "TcpClientLib.h"
#import "VoteTableViewCell.h"

@interface PlayerViewController ()<VHallMoviePlayerDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, VHallChatDelegate, VHRoomDelegate>

@property(nonatomic,assign)id delegate;
@property(nonatomic,strong,readonly)UIView * moviePlayerView;
@property(nonatomic,assign)int timeout; //RTMP链接的超时时间 默认5秒，单位为毫秒
@property(nonatomic,assign)int reConnectTimes; //RTMP 断开后的重连次数 默认 2次 @property(nonatomic,assign)int bufferTime; //RTMP 的缓冲时间 默认 2秒 单位为秒 必须>0 值越小延时越小,卡顿增加
@property(assign,readonly)int realityBufferTime; //获取RTMP播放实际的缓冲时间+
@property(nonatomic,assign,readonly)VHPlayerState playerState;//播放器状态
//视频View的缩放比例 默认是自适应模式
@property(nonatomic,assign)VHRTMPMovieScalingMode movieScalingMode;
//当前视频观看模式 观看直播允许切换观看模式(回放没有)
@property(nonatomic,assign)VHMovieVideoPlayMode playMode;
//设置默认播放的清晰度 默认原画
@property(nonatomic,assign)VHMovieDefinition defaultDefinition;
//@brief 直播视频清晰度 （只有直播有效）
//@return 返回当前视频清晰度 如果和设置的不一致 设置无效保存原有清晰度 设置成功刷新直播，有可能设置失败，请再获取curDefinition查看 设置状态
//当前视频清晰度 观看直播允许切换清晰度(回放没有) 默认是defaultDefinition
@property(nonatomic,assign)VHMovieDefinition curDefinition;
//设置渲染视图 在VideoPlayMode:isVrVideo: 中设置 默认VHRenderModelNone 必须设置否则会 出现黑屏
@property(nonatomic,assign)VHRenderModel renderViewModel;

@property (nonatomic, strong) VHallMoviePlayer *moviePlayer;

/* 聊天界面 */
@property (nonatomic, strong) UITableView *tableview;

/** 加载一个webview */
@property (nonatomic, strong) UIWebView *webview;

/** 记录进入直播界面的开始时间 */
@property (nonatomic, strong) NSDate *startDate;

/** 记录离开直播界面的时间 */
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) VHallChat *chat;

//发表评论输入框
@property (nonatomic, strong) UIView *bottom_tool;

//评论输入框
@property (nonatomic, strong) UITextField *input_comment_textfield;

@property (nonatomic, strong) VHRoom *room;

/** 聊天消息 */
@property (nonatomic, strong) NSMutableArray *messageArray;

/** Socket */
@property (nonatomic, strong) TcpClientLib *client;

@property (nonatomic, assign) int sid;

/** 投票数据 */
@property (nonatomic, strong) NSDictionary *vote_data_dic;

/** 用于承载投票界面 */
@property (nonatomic, strong) UIView *back_view;

/** 投票选择结果 */
@property (nonatomic, strong) NSMutableArray *vote_select_array;

@end

@implementation PlayerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.startDate = [NSDate date];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    self.endDate = [NSDate date];
    
    NSTimeInterval interval = [self.endDate timeIntervalSinceDate:self.startDate];
    NSLog(@"两个时间间隔为：%f", interval);
    NSString *upload_tiem_string = [NSString stringWithFormat:@"%.0f", interval];
    //整理上传数据
    NSDictionary *parma = @{
                            @"course_id_":@"00000",
                            @"course_content_id_":@"0000",
                            @"time_length_":upload_tiem_string
                            };
    
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/save_have_class_record" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"课程埋点数据 == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"课程埋点数据上传成功！！！");
        }
    } FailureBlock:^(id error) {
        
    }];
    
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
    self.messageArray = [NSMutableArray arrayWithCapacity:1];
    self.vote_select_array = [NSMutableArray arrayWithCapacity:1];
    
    self.moviePlayer = [[VHallMoviePlayer alloc] initWithDelegate:self];
    [self.moviePlayer setRenderViewModel:VHRenderModelOrigin];
    [self.view addSubview: self.moviePlayer.moviePlayerView];
    self.moviePlayer.moviePlayerView.frame = FRAME(0, 0, SCREENBOUNDS.width, 300);
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param[@"id"] = @"612077993";//活动id
    param[@"name"]=[UIDevice currentDevice].name;
    param[@"email"]=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self.moviePlayer startPlay:param];
    
    //直播间
    self.room = [[VHRoom alloc] init];
    self.room.delegate = self;
    [self.room enterRoomWithRoomId:@"612077993"];
    
    //聊天
    self.chat = [[VHallChat alloc] initWithMoviePlayer:self.moviePlayer];
    self.chat.delegate = self;
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(300, 0, 50, 0));
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
    
    //百度统计
    NSString *class_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"class_name"] ?: @"";
    [[BaiduMobStat defaultStat] logEvent:@"GoToClass000" eventLabel:@"观看直播次数" attributes:@{@"class":class_name}];
    
    //注册接收投票内容的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVoteView:) name:@"VoteNotifacation" object:nil];
}

#pragma mark ********* 通知执行方法 **********
- (void)showVoteView:(NSNotification *)notifacation {
    NSLog(@"user info == %@", notifacation.userInfo);
    __weak typeof(self) weakSelf = self;
    //主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showVoteToWindow:notifacation.userInfo[@"data"]];
    });
}

#pragma mark *********** 展示投票的界面 **************
- (void)showVoteToWindow:(NSString *)dataString {
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];

    NSError *err;
    self.vote_data_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    
    AppDelegate *gate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.back_view = [[UIView alloc] initWithFrame:gate.window.bounds];
    self.back_view.backgroundColor = DetailTextColor;
    [gate.window addSubview:self.back_view];
    __weak typeof(self) weakSelf = self;
    UITableView *voteTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    voteTableview.backgroundColor = WhiteColor;
    voteTableview.tag = 1000;
    voteTableview.delegate = self;
    voteTableview.dataSource = self;
    [voteTableview registerClass:[VoteTableViewCell class] forCellReuseIdentifier:@"voteCell"];
    [self.back_view addSubview:voteTableview];
    [voteTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.back_view).insets(UIEdgeInsetsMake(100, 30, 200, 30));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1000) {
        return [self.vote_data_dic[@"vote_content_"] count];
    }
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1000) {
        VoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voteCell"];
        cell.content_label.text = self.vote_data_dic[@"vote_content_"][indexPath.row];
        return cell;
    }
    
    VHallChatModel *model = self.messageArray[indexPath.row];
    ChatTableViewCell *cell = [ChatTableViewCell cellWithTableView:tableView messageModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1000) {
        NSString *vote_answer_string = self.vote_data_dic[@"vote_content_"][indexPath.row];
        return [self calculateRowHeight:vote_answer_string fontSize:16 withWidth:SCREENBOUNDS.width - 40 - 20] + 20.0;
    }
    VHallChatModel *model = self.messageArray[indexPath.row];
    return [self calculateRowHeight:model.text fontSize:14 withWidth:SCREENBOUNDS.width / 2] + 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1000) {
        NSString *vote_title_string = self.vote_data_dic[@"title_"];
        return [self calculateRowHeight:vote_title_string fontSize:16 withWidth:SCREENBOUNDS.width - 40] + 70.0;
    }
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1000) {
        VoteTableViewCell *cell = (VoteTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *vote_string = self.vote_data_dic[@"vote_content_"][indexPath.row];
        if ([self.vote_select_array containsObject:vote_string]) {
            [self.vote_select_array removeObject:vote_string];
            cell.left_imageview.backgroundColor = SetColor(246, 246, 246, 1);
        }else {
            [self.vote_select_array addObject:vote_string];
            cell.left_imageview.backgroundColor = SetColor(48, 132, 252, 1);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView.tag == 1000) {
        return 60.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    if (tableView.tag == 1000) {
        UIButton *cancel_vote = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel_vote setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [header_view addSubview:cancel_vote];
        [cancel_vote mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(header_view.mas_right).offset(-20);
            make.top.equalTo(header_view.mas_top).offset(20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [cancel_vote addTarget:self action:@selector(cancel_vote_view) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *content = [[UILabel alloc] init];
        content.font = SetFont(16);
        content.textColor = DetailTextColor;
        content.numberOfLines = 0;
        content.text = self.vote_data_dic[@"title_"];
        [header_view addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(50, 20, 10, 20));
        }];
    }
    return header_view;
}

#pragma mark ********** 移除投票界面 *************
- (void)cancel_vote_view {
    [self.back_view removeFromSuperview];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    if (tableView.tag == 1000) {
        UIButton *voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        voteButton.titleLabel.font = SetFont(16);
        voteButton.backgroundColor = SetColor(48, 132, 252, 1);
        [voteButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        [voteButton setTitle:@"确认投票" forState:UIControlStateNormal];
        ViewRadius(voteButton, 20.0);
        [footer_view addSubview:voteButton];
        [voteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(20, 30, 0, 30));
        }];
        [voteButton addTarget:self action:@selector(pushVoteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return footer_view;
}

#pragma mark *********** 上传投票结果 ************
- (void)pushVoteAction {
    NSDictionary *param = @{@"vote_record_id_":self.vote_data_dic[@"vote_record_id_"],@"vote_content_":[self.vote_select_array copy]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/insert_user_vote_record" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"投票成功！！！！");
            [weakSelf.back_view removeFromSuperview];
        }else {
            NSLog(@"投票失败！！！！");
        }
    } FailureBlock:^(id error) {
        
    }];
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

#pragma mark ------- 发送消息
- (void)submitCommentContentAction {
//    @property (nonatomic, copy) NSString * join_id;         //参会id
//    @property (nonatomic, copy) NSString * account_id;      //微吼用户ID
//    @property (nonatomic, copy) NSString * user_name;       //参会时的昵称
//    @property (nonatomic, copy) NSString * avatar;          //头像url，如果没有则为空字符串
//    @property (nonatomic, copy) NSString * room;            //房间号，即活动id
//    @property (nonatomic, copy) NSString * time;            //发送时间，根据服务器时间确定
//    @property (nonatomic, copy) NSString * role;            //用户类型 host:主持人 guest：嘉宾 assistant：助手 user：观众
//    VHallChatModel *model = [[VHallChatModel alloc] init];
//    model.join_id = @"109559055";
//    model.account_id = @"18268865135";
//    model.user_name = @"aaa";
//    model.avatar = @"";
//    model.room = @"109559055";
//    model.time = @"2019-3-18";
//    model.role = @"assistant";
//    model.text = @"砺行教育";
//    [self.messageArray addObject:model];
//    [self.tableview reloadData];
    __weak typeof(self) weakSelf = self;
    [self.chat sendMsg:self.input_comment_textfield.text success:^{
        weakSelf.input_comment_textfield.text = @"";
        [weakSelf.input_comment_textfield resignFirstResponder];
    } failed:^(NSDictionary *failedData) {
        
    }];
    
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

#pragma mark -- 直播间回调
/** 进入房间回调 */
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error {
    NSLog(@"进入房间回调");
    //** 获取聊天消息 */
    [self.chat getHistoryWithType:YES success:^(NSArray *msgs) {
        NSLog(@"VH chat message === %@", msgs);
        self.messageArray = [NSMutableArray arrayWithArray:msgs];
        [self.tableview reloadData];
    } failed:^(NSDictionary *failedData) {
        NSLog(@"VH chat error === %@", failedData);
        if ([failedData[@"code"] integerValue] == 10408) {
            [self showHUDWithTitle:@"当前未直播"];
        }
    }];
}

/** 房间连接成功 */
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata {
    NSLog(@"房间连接成功");
}
/** 房间错误回调 */
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason {
    NSLog(@"房间错误回调");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------- chat delegate -----------
//收到消息
- (void)reciveChatMsg:(NSArray *)msgs {
    NSLog(@"msgs == %@", msgs);
    for (VHallChatModel *model in msgs) {
        NSLog(@"msgs content == %@\n join_id == %@", model.text, model.join_id);
        NSLog(@"msgs account id == %@", model.account_id);
        NSLog(@"msgs user name == %@", model.user_name);
        [self.messageArray addObject:model];
    }
    [self.tableview reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
    [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark ------- Socket -----------
- (void)connectSocket {
//    47.110.40.243:  9102
    NSString * ip = @"47.110.40.243";
    int port = 9102;
    
    self.client = [[TcpClientLib alloc] init];
    
    self.sid = [self.client connect:ip port:port];
    
    NSLog(@"self.sid === %d", self.sid);
    
    NSDictionary *dic = @{@"user_id_":@"2823f26449f44a88ae92ff02fe15535e",@"course_content_id_":@"7eea5a50f14142ccb8e0dd0c043fbfc4"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self.client add_event];
    
    [self.client async_receive:self.sid];
    
    [self.client async_send:self.sid data:jsonString];
}

#pragma mark - 获取这个字符串中的所有xxx的所在的index（未用到）
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText {
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    if (findText == nil && [findText isEqualToString:@""]) {
        return nil;
    }
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++) {
            if (0 == i) {//去掉这个xxx
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            //在一个range范围内查找另一个字符串的range
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0) {
                break;
            } else {
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            }
        }
        return arrayRanges;
    }
    return nil;
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
