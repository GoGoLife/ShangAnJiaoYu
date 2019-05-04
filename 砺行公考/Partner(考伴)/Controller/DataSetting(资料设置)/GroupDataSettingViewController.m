//
//  GroupDataSettingViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "GroupDataSettingViewController.h"
#import "ShowPersonalInfoTableViewCell.h"
#import "DrillCollectionViewCell.h"
#import <Hyphenate/Hyphenate.h>
#import "ChangeGroupAnnouncementViewController.h"
#import "ShowChatGroupInfoCell.h"

@interface GroupDataSettingViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *group_member_array;

//群组名称
@property (nonatomic, strong) NSString *group_name;

//群公告
@property (nonatomic, strong) NSString *group_announcement;

@end

@implementation GroupDataSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
    self.group_member_array = [NSMutableArray arrayWithCapacity:1];
    self.group_announcement = @"";
    
    [self setBack];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowPersonalInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //获取群组详情,包含群组ID,群组名称，群组描述，群组基本属性，群组Owner, 群组管理员
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:self.group_id completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            weakSelf.group_name = aGroup.subject;
            weakSelf.group_announcement = aGroup.announcement;
            [weakSelf.group_member_array addObject:aGroup.owner];
            [[EMClient sharedClient].groupManager getGroupMemberListFromServerWithId:self.group_id cursor:nil pageSize:200 completion:^(EMCursorResult *aResult, EMError *aError) {
                for (NSString *string in aResult.list) {
                    [weakSelf.group_member_array addObject:string];
                }
                NSLog(@"群组成员list === %@", weakSelf.group_member_array);
                [weakSelf.tableview reloadData];
            }];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.name_label.text = @"群聊名字";
    cell.content_label.text = self.group_name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return INFO_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self firstHeaderViewHeightWithGroupNumbers:self.group_member_array.count];
    }else if (section == 1) {
        CGFloat announcement_height = [self calculateRowHeight:self.group_announcement fontSize:14 withWidth:SCREENBOUNDS.width - 40];
        return 110.0 + announcement_height;
    }else if (section == 2) {
        return 240.0;
    }else if (section == 3) {
        return 140.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    if (section == 0) {
        [self setFirstHeaderView:header_view];
        return header_view;
    }else if (section == 1) {
        [self setSecondHeaderViewContent:header_view];
        return header_view;
    }else if (section == 2) {
        [self setThreeHeaderViewContent:header_view];
        return header_view;
    }else if (section == 3) {
        header_view.backgroundColor = SetColor(246, 246, 246, 1);
        [self setFourHeaderViewContent:header_view];
        return header_view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = SetColor(246, 246, 246, 1);
    return footer_view;
}

- (void)setFirstHeaderView:(UIView *)header_view {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 20.0;
    layout.minimumInteritemSpacing = 20.0;
    CGFloat itemWidth = (SCREENBOUNDS.width - 20 * 6) / 5;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth + 40.0);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[ShowChatGroupInfoCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [header_view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.group_member_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShowChatGroupInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.image_view.image = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    cell.name_label.text = self.group_member_array[indexPath.row];
    cell.type_label.text = @"admin";
    return cell;
}

- (void)setSecondHeaderViewContent:(UIView *)header_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"消息免打扰";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    UISwitch *switch_button = [[UISwitch alloc] init];
    switch_button.on = NO;
    [header_view addSubview:switch_button];
    [switch_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];

    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];

    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(16);
    label1.text = @"群公告";
    [header_view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(line.mas_left);
    }];

    UILabel *right_label = [[UILabel alloc] init];
    right_label.font = SetFont(16);
    right_label.textColor = DetailTextColor;
    right_label.textAlignment = NSTextAlignmentRight;
    right_label.text = @"设置 / 修改";
    [header_view addSubview:right_label];
    [right_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(label1.mas_right);
        make.right.equalTo(line.mas_right);
        make.height.mas_equalTo(40);
    }];
    right_label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushChangeAnnouncementView)];
    [right_label addGestureRecognizer:tap];
    
    if (!self.group_announcement || ![self.group_announcement isEqualToString:@""]) {
        right_label.hidden = YES;
    }

    UILabel *content_label = [[UILabel alloc] init];
    content_label.font = SetFont(14);
    content_label.textColor = DetailTextColor;
    content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    content_label.numberOfLines = 0;
    content_label.text = self.group_announcement;
    [header_view addSubview:content_label];
    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(right_label.mas_bottom);
        make.left.equalTo(line.mas_left);
        make.bottom.equalTo(header_view.mas_bottom).offset(-10);
        make.right.equalTo(line.mas_right);
    }];
}


- (void)setThreeHeaderViewContent:(UIView *)header_view {
    UIImageView *header_image = [[UIImageView alloc] init];
    header_image.backgroundColor = RandomColor;
    ViewRadius(header_image, 25.0);
    [header_view addSubview:header_image];
    [header_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    UIButton *add_friend_button = [UIButton buttonWithType:UIButtonTypeCustom];
    add_friend_button.titleLabel.font = SetFont(14);
    add_friend_button.backgroundColor = ButtonColor;
    [add_friend_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [add_friend_button setTitle:@"申请好友" forState:UIControlStateNormal];
    ViewRadius(add_friend_button, 15.0);
    [header_view addSubview:add_friend_button];
    [add_friend_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.centerY.equalTo(header_image.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    // 聊天
    UIButton *chat_button = [UIButton buttonWithType:UIButtonTypeCustom];
    chat_button.backgroundColor = RandomColor;
    ViewRadius(chat_button, 15.0);
    [header_view addSubview:chat_button];
    [chat_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(add_friend_button.mas_left).offset(-20);
        make.centerY.mas_equalTo(header_image.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *name_label = [[UILabel alloc] init];
    name_label.font = SetFont(16);
    name_label.text = @"班主任 凌霄哥哥";
    [header_view addSubview:name_label];
    [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_image.mas_bottom).offset(10);
        make.left.equalTo(header_image.mas_left);
    }];
    
    UILabel *personalMessage_label = [[UILabel alloc] init];
    personalMessage_label.font = SetFont(12);
    personalMessage_label.textColor = DetailTextColor;
    personalMessage_label.text = @"“大概是世界上最聪明的班主任小哥哥啦～“";
    [header_view addSubview:personalMessage_label];
    [personalMessage_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name_label.mas_bottom).offset(5);
        make.left.equalTo(name_label.mas_left);
    }];
    
    UILabel *details_label = [[UILabel alloc]init];
    details_label.font = SetFont(14);
    details_label.textColor = DetailTextColor;
    details_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    details_label.numberOfLines = 0;
    details_label.text = @"简介：凌霄哥哥毕业于浙江大学法学系，与2014年成功进入公务员队伍，在2014年的国家公务员考试中，取得了145.63的高分，实力非常强劲，尤其擅长数量关系和判断推理。";
    [header_view addSubview:details_label];
    [details_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personalMessage_label.mas_bottom).offset(20);
        make.left.equalTo(personalMessage_label.mas_left);
        make.bottom.equalTo(header_view.mas_bottom).offset(-10);
        make.right.equalTo(header_view.mas_right).offset(-20);
    }];
}

//删除聊天记录  退群
- (void)setFourHeaderViewContent:(UIView *)header_view {
    UIButton *delete_chat_history = [UIButton buttonWithType:UIButtonTypeCustom];
    delete_chat_history.titleLabel.font = SetFont(16);
    delete_chat_history.backgroundColor = WhiteColor;
    [delete_chat_history setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [delete_chat_history setTitle:@"清空聊天记录" forState:UIControlStateNormal];
    [delete_chat_history addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [header_view addSubview:delete_chat_history];
    [delete_chat_history mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top);
        make.left.equalTo(header_view.mas_left);
        make.right.equalTo(header_view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *exit_button = [UIButton buttonWithType:UIButtonTypeCustom];
    exit_button.titleLabel.font = SetFont(18);
    exit_button.backgroundColor = SetColor(242, 68, 89, 1);
    [exit_button setTitle:@"删除并退出" forState:UIControlStateNormal];
    ViewRadius(exit_button, 25.0);
    [exit_button addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [header_view addSubview:exit_button];
    [exit_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(delete_chat_history.mas_bottom).offset(20);
        make.left.equalTo(header_view.mas_left).offset(40);
        make.right.equalTo(header_view.mas_right).offset(-40);
        make.height.mas_equalTo(50);
    }];
}


//根据群聊人数   确定firstHeaderView的高度
- (CGFloat)firstHeaderViewHeightWithGroupNumbers:(NSInteger)count {
    NSInteger otherLine = count % 5 > 0 ? 1 : 0;
    NSInteger line = count / 5 + otherLine;
    CGFloat itemHeight = (SCREENBOUNDS.width - 20 * 6) / 5 + 25;
    CGFloat height = line * itemHeight + 40 + (line - 1) * 20;
    return height;
}

//跳转到修改群公告页面
- (void)pushChangeAnnouncementView {
    ChangeGroupAnnouncementViewController *change = [[ChangeGroupAnnouncementViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    change.returnAnnouncementContent = ^(NSString * _Nonnull content) {
        weakSelf.group_announcement = content;
        [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        //更新群公告信息
        __weak typeof(self) weakSelf = self;
        [[EMClient sharedClient].groupManager updateGroupAnnouncementWithId:self.group_id announcement:content completion:^(EMGroup *aGroup, EMError *aError) {
            if (aError) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"群公告仅限群主修改" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [alert addAction:action1];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }else {
                [weakSelf showHUDWithTitle:@"群公告修改成功"];
            }
        }];
    };
    [self.navigationController pushViewController:change animated:YES];
}

//清空聊天记录
- (void)deleteAction {
    [self.navigationController popViewControllerAnimated:YES];
    self.touchRemoveAllMessageHistory();
}

//删除并退出
- (void)exitAction {
    [self.navigationController popViewControllerAnimated:YES];
    self.touchExitGroup();
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
