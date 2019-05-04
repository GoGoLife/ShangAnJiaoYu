//
//  StartGroupChatViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "StartGroupChatViewController.h"
#import "PartnerListTableViewCell.h"
#import <Hyphenate/Hyphenate.h>
#import "ChatViewController.h"

@interface StartGroupChatViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray *selected_array;

@end

@implementation StartGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selected_array = [NSMutableArray arrayWithCapacity:1];
    
    self.title = @"考伴列表";
    
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction)];
    self.navigationItem.rightBarButtonItem = right;
    
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
        make.right.equalTo(weakSelf.view.mas_right).offset(-5);
        make.height.mas_equalTo(52);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[PartnerListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(search.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    //从环信服务器获取所有好友
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            weakSelf.dataArray = aList;
            [weakSelf.tableview reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isCanSelect = YES;
    cell.header_image.image = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    cell.top_label.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerListTableViewCell *cell = (PartnerListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *string = self.dataArray[indexPath.row];
    if ([self.selected_array containsObject:string]) {
        cell.left_image.image = [UIImage imageNamed:@"select_no"];
        [self.tableview reloadData];
        [self.selected_array removeObject:self.dataArray[indexPath.row]];
    }else {
        cell.left_image.image = [UIImage imageNamed:@"select_yes"];
        [self.tableview reloadData];
        [self.selected_array addObject:string];
        
    }
}

//确认
- (void)confirmAction {
    __weak typeof(self) weakSelf = self;
    EMGroupOptions *options = [[EMGroupOptions alloc] init];
    options.style = EMGroupStylePrivateMemberCanInvite;
    options.maxUsersCount = 2000;
    options.IsInviteNeedConfirm = NO;
    [[EMClient sharedClient].groupManager createGroupWithSubject:@"" description:@"" invitees:[self.selected_array copy] message:@"" setting:options completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            //表示创建成功
            ChatViewController *chat = [[ChatViewController alloc] initWithConversationChatter:aGroup.groupId conversationType:EMConversationTypeGroupChat];
            chat.type = CHAT_TYPE_NOMAL_GROUP;
            chat.group = aGroup;
            chat.isNewCreat = YES;
            [weakSelf.navigationController pushViewController:chat animated:YES];
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
