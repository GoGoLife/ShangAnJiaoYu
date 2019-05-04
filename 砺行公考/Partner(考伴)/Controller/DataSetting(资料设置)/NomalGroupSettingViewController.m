//
//  NomalGroupSettingViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/15.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "NomalGroupSettingViewController.h"
#import "ShowPersonalInfoTableViewCell.h"
#import "DrillCollectionViewCell.h"
#import <Hyphenate/Hyphenate.h>
#import "ChangeGroupAnnouncementViewController.h"
#import "ShowChatGroupInfoCell.h"
#import "GroupNumbersModel.h"

@interface NomalGroupSettingViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *group_member_array;

//群组名称
@property (nonatomic, strong) NSString *group_name;

//群公告
@property (nonatomic, strong) NSString *group_announcement;

@end

@implementation NomalGroupSettingViewController

- (void)getDataWithGroup {
    NSLog(@"group  id === %@", self.group_id);
    [self.group_member_array removeAllObjects];
    __weak typeof(self) weakSelf = self;
    //获取群组详情,包含群组ID,群组名称，群组描述，群组基本属性，群组Owner, 群组管理员
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:self.group_id completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            weakSelf.group_name = aGroup.subject;
            weakSelf.group_announcement = aGroup.announcement;
            
            GroupNumbersModel *model = [[GroupNumbersModel alloc] init];
            model.name = aGroup.owner;
            model.type = @"群主";
            [weakSelf.group_member_array addObject:model];
            
            //整理管理员
            for (NSString *admin in aGroup.adminList) {
                GroupNumbersModel *adminModel = [[GroupNumbersModel alloc] init];
                adminModel.name = admin;
                adminModel.type = @"管理员";
                [weakSelf.group_member_array addObject:adminModel];
            }
            
            //整理群成员
            for (NSString *member in aGroup.memberList) {
                GroupNumbersModel *memberModel = [[GroupNumbersModel alloc] init];
                memberModel.name = member;
                memberModel.type = @"";
                [weakSelf.group_member_array addObject:memberModel];
            }
            
            [weakSelf.tableview reloadData];
            
            NSLog(@"owner == %@", aGroup.owner);
            
            NSLog(@"admin == %@", aGroup.adminList);
            
            NSLog(@"numbers == %@", aGroup.memberList);
        }
    }];
}

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
    
    [self getDataWithGroup];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.name_label.text = @[@"群聊名字", @"管理员"][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.content_label.text = self.group_name;
    }
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
    layout.itemSize = CGSizeMake(itemWidth, itemWidth + 40);
    
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

#pragma mark ---- collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.group_member_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupNumbersModel *model = self.group_member_array[indexPath.row];
    ShowChatGroupInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.image_view.image = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    cell.name_label.text = model.name;
    cell.type_label.text = model.type;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self showHUDWithTitle:@"群主"];
        return;
    }
    __block BOOL isAdmin = NO;
    GroupNumbersModel *model = self.group_member_array[indexPath.row];
    if ([model.type isEqualToString:@"管理员"]) {
        isAdmin = YES;
    }else {
        isAdmin = NO;
    }
    NSString *string = isAdmin ? @"取消管理员" : @"设为管理员";
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"" message:@"提示" preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isAdmin) {
            [[EMClient sharedClient].groupManager removeAdmin:model.name fromGroup:self.group_id completion:^(EMGroup *aGroup, EMError *aError) {
                NSLog(@"设置管理员  EMGroup === %@", aGroup);
                NSLog(@"error ==== %@", aError);
                if (aError) {
                    [weakSelf showHUDWithTitle:@"需要管理员权限"];
                }else {
                    [weakSelf showHUDWithTitle:@"取消成功"];
                    //重新获取数据  并刷新
                    [weakSelf getDataWithGroup];
                }
            }];
        }else {
            [[EMClient sharedClient].groupManager addAdmin:model.name toGroup:self.group_id completion:^(EMGroup *aGroup, EMError *aError) {
                NSLog(@"设置管理员  EMGroup === %@", aGroup);
                NSLog(@"error ==== %@", aError);
                if (aError) {
                    [weakSelf showHUDWithTitle:@"需要管理员权限"];
                }else {
                    [weakSelf showHUDWithTitle:@"设置成功"];
                    //重新获取数据  并刷新
                    [weakSelf getDataWithGroup];
                }
            }];
        }
    }]];
    
    [sheet addAction:[UIAlertAction actionWithTitle:@"移除成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[EMClient sharedClient].groupManager removeMembers:@[model.name] fromGroup:self.group_id completion:^(EMGroup *aGroup, EMError *aError) {
            if (aError) {
                [weakSelf showHUDWithTitle:@"需要管理员权限"];
            }else {
                //重新获取数据  并刷新
                [weakSelf getDataWithGroup];
            }
        }];
    }]];
    
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:sheet animated:YES completion:nil];
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
