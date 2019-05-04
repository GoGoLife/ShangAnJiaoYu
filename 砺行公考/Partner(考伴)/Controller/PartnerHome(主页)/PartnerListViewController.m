//
//  PartnerListViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PartnerListViewController.h"
#import "PartnerListTableViewCell.h"
#import <Hyphenate/Hyphenate.h>
#import "ChatViewController.h"

//发起群聊
#import "StartGroupChatViewController.h"

//添加朋友
#import "AddFriendViewController.h"

@interface PartnerListViewController ()<UITableViewDelegate, UITableViewDataSource, EMGroupManagerDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIView *back_view;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *all_group_array;

@property (nonatomic, strong) NSMutableArray *publicGroupArray;

@end

@implementation PartnerListViewController


/**
 区分我加入的群组是官方群  还是非官方群

 @param allGroupArray 所有的群组
 */
- (void)getPublicGroup:(NSArray *)allGroupArray {
    [self.publicGroupArray removeAllObjects];
    //这个接口返回的是后台录入的官方群信息
    NSDictionary *parma = @{@"page_number":@"1",
                            @"page_size":@"200"};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_hx_group" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *public_group_id in responseObject[@"data"][@"rows"]) {
                EMGroup *public_group = [EMGroup groupWithId:[NSString stringWithFormat:@"%ld", [public_group_id[@"id_"] integerValue]]];
                if (public_group) {
                    [weakSelf.publicGroupArray addObject:public_group];
                    [weakSelf.dataArray replaceObjectAtIndex:0 withObject:weakSelf.publicGroupArray];
                }
            }
            
            NSMutableArray *tem_mutaleArray = [NSMutableArray arrayWithArray:allGroupArray];
            for (EMGroup *group in allGroupArray) {
                NSString *group_id = group.groupId;
                for (EMGroup *publicGroup in weakSelf.publicGroupArray) {
                    NSString *public_group_id = publicGroup.groupId;
                    if ([group_id isEqualToString:public_group_id]) {
                        [tem_mutaleArray removeObject:group];
                    }
                }
            }
            weakSelf.all_group_array = [tem_mutaleArray copy];
            [weakSelf.dataArray replaceObjectAtIndex:2 withObject:weakSelf.all_group_array];
            
            //从服务器获取所有好友
            NSLog(@"current name == %@", [EMClient sharedClient].currentUsername);
            [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
                NSLog(@"friend list == %@", aList);
                if (aList) {
                    [weakSelf.dataArray replaceObjectAtIndex:1 withObject:aList];
                    [weakSelf.tableview reloadData];
                    [weakSelf.tableview.mj_header endRefreshing];
                }else {
                    [self showHUDWithTitle:@"好友列表为空"];
                    [weakSelf.tableview reloadData];
                    [weakSelf.tableview.mj_header endRefreshing];
                }
            }];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//整理数据
- (void)formatData {
    [self.dataArray removeAllObjects];
    //官方群
    [self.dataArray addObject:@[]];
    //好友
    [self.dataArray addObject:@[]];
    //我的群
    [self.dataArray addObject:@[]];
    
    //获取所有我加入群组
    NSArray *group_array = [[EMClient sharedClient].groupManager getJoinedGroups];
//    NSLog(@"group_array === %@", group_array);
    //分离官方和非官方群
    [self getPublicGroup:group_array];
    
    //黑名单
//    [self.dataArray addObject:@[@"1111", @"2222"]];
//    NSLog(@"dataArray == %@", self.dataArray);
//    [self.tableview reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.publicGroupArray = [NSMutableArray arrayWithCapacity:1];
    
    self.view.frame = FRAME(0, 150, self.view.bounds.size.width, self.view.bounds.size.height - 150);//[[UIView alloc] initWithFrame:];
    __weak typeof(self) weakSelf = self;
    UISearchBar *search = [[UISearchBar alloc] init];
    search.tintColor = [UIColor whiteColor];
    search.barTintColor = [UIColor whiteColor];
    UIImage *backImage = [self GetImageWithColor:[UIColor whiteColor] andHeight:32.0];
    search.backgroundImage = backImage;
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    searchTextField = [[[search.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = SetColor(246, 246, 246, 1);
    search.placeholder = @"输入关键词...";
    [self.view addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(5);
        make.left.equalTo(weakSelf.view.mas_left).offset(5);
        make.right.equalTo(weakSelf.view.mas_right).offset(-60);
        make.height.mas_equalTo(52);
    }];
    
    UIButton *more_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [more_button setImage:[UIImage imageNamed:@"partner_1"] forState:UIControlStateNormal];
    [more_button addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:more_button];
    [more_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.centerY.equalTo(search.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[PartnerListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(52, 0, 0, 0));
    }];
    
    //群组delegate
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    
    //注册通知  好友列表发生变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFriendListData) name:@"changedFriendList" object:nil];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf formatData];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (void)reloadFriendListData {
//    NSLog(@"成功接收到通知");
    [self formatData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        //官方群
        cell.header_image.image = [UIImage imageNamed:@"group_1"];
        cell.top_label.text = @"砺行长效班";
    }else if(indexPath.section == 1) {
        //好友
        cell.header_image.image = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
        cell.top_label.text = self.dataArray[indexPath.section][indexPath.row];
    }else if(indexPath.section == 2) {
        //群
        EMGroup *group = self.dataArray[indexPath.section][indexPath.row];
        cell.header_image.image = [UIImage imageNamed:@"group"];
        if (group.subject && group.subject.length > 0) {
            cell.top_label.text = group.subject;
        } else {
            cell.top_label.text = group.groupId;
        }
    }
//    else {
//        //黑名单
//        cell.header_image.image = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//        cell.top_label.text = self.dataArray[indexPath.section][indexPath.row];
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    for (UIView *vv in header_view.subviews) {
        [vv removeFromSuperview];
    }
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(14);
    title_label.textColor = DetailTextColor;
    title_label.text = @[@"官方群：", @"我的考伴", @"考伴群"][section];
    [header_view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //官方群   公开群
        EMGroup *public_group = self.dataArray[indexPath.section][indexPath.row];
        ChatViewController *group = [[ChatViewController alloc] initWithConversationChatter:public_group.groupId conversationType:EMConversationTypeGroupChat];
        group.group = public_group;
        group.type = CHAT_TYPE_OFFICIAL_GROUP;
        [self.navigationController pushViewController:group animated:YES];
    }else if (indexPath.section == 1) {
        //单聊
        NSString *chat_name = self.dataArray[indexPath.section][indexPath.row];
        ChatViewController *chat = [[ChatViewController alloc] initWithConversationChatter:chat_name conversationType:EMConversationTypeChat];
        chat.type = CHAT_TYPE_PERSONAL;
        [self.navigationController pushViewController:chat animated:YES];
    }else if (indexPath.section == 2) {
        //普通群
        EMGroup *group = self.dataArray[indexPath.section][indexPath.row];
        ChatViewController *chat_group = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
        chat_group.group = group;
        chat_group.type = CHAT_TYPE_NOMAL_GROUP;
        [self.navigationController pushViewController:chat_group animated:YES];
    }
}

//更多操作    发起群聊   添加好友
- (void)moreAction {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.back_view = [[UIView alloc] initWithFrame:app.window.bounds];
    self.back_view.backgroundColor = WhiteColor;
    [app.window addSubview:self.back_view];
    [self setBack_view_content:self.back_view];
}

- (void)setBack_view_content:(UIView *)back_view {
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(removeViewAction) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-30);
        make.top.equalTo(back_view.mas_top).offset(130);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    UIButton *push_group_chat = [UIButton buttonWithType:UIButtonTypeCustom];
    push_group_chat.titleLabel.font = SetFont(12);
    [push_group_chat setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
    [push_group_chat setImage:[UIImage imageNamed:@"startGroup"] forState:UIControlStateNormal];
    [push_group_chat setTitle:@"发起群聊" forState:UIControlStateNormal];
    [self initButton:push_group_chat];
    [push_group_chat addTarget:self action:@selector(push_group_chat_action) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:push_group_chat];
    CGFloat width = SCREENBOUNDS.width / 2;
    [push_group_chat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cancel.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(width, 90));
    }];
    
    UIButton *add_friend = [UIButton buttonWithType:UIButtonTypeCustom];
    add_friend.titleLabel.font = SetFont(12);
    [add_friend setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
    [add_friend setImage:[UIImage imageNamed:@"addFriend"] forState:UIControlStateNormal];
    [add_friend setTitle:@"添加朋友" forState:UIControlStateNormal];
    [self initButton:add_friend];
    [add_friend addTarget:self action:@selector(add_friend_action) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:add_friend];
    [add_friend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cancel.mas_bottom).offset(20);
        make.left.equalTo(push_group_chat.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(width, 90));
    }];
}

//删除视图
- (void)removeViewAction {
    [self.back_view removeFromSuperview];
}

//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    float  spacing = 15;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height) - 5, -50, 0.0 - 5, - titleSize.width - 5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(50, - 20 * 5 + 8, - (totalHeight - titleSize.height), 0);
}

//跳转发起群聊
- (void)push_group_chat_action {
    [self.back_view removeFromSuperview];
    StartGroupChatViewController *group = [[StartGroupChatViewController alloc] init];
    [self.navigationController pushViewController:group animated:YES];
}

//添加朋友
- (void)add_friend_action {
    [self.back_view removeFromSuperview];
    AddFriendViewController *friend = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:friend animated:YES];
}

//群组delegate  相关回调
/**
 群组发生变化时的回调
 */
- (void)groupListDidUpdate:(NSArray *)aGroupList {
    [self getPublicGroup:aGroupList];
}
@end
