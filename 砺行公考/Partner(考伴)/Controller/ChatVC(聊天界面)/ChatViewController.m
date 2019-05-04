//
//  ChatViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ChatViewController.h"
#import "GroupDataSettingViewController.h"
#import "NomalGroupSettingViewController.h"
#import "PartnerViewController.h"
#import "CustomChatMessageCell.h"
#import "SendQuestionViewController.h"
#import "Send_SummarizeViewController.h"

#import "Send_TipsViewController.h"
#import "Send_ExamViewController.h"
#import "Send_StudyViewController.h"
#import "Send_DrillViewController.h"
#import "Send_DigestViewController.h"
#import "Send_SchduleViewController.h"
#import "LookQuestionDetailsViewController.h"
//摘记详情
#import "LookContentViewController.h"
#import "Chat_ScheduleInfoViewController.h"

@interface ChatViewController ()<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource, EaseChatBarMoreViewDelegate>

@end

@implementation ChatViewController

//重写自己添加的方法   完成相关操作
- (void)addtargetFunction {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//删除所有聊天记录
//    [self.conversation deleteAllMessages:nil];
    [self.chatBarMoreView removeItematIndex:1];
    [self.chatBarMoreView removeItematIndex:2];
    [self.chatBarMoreView removeItematIndex:3];
    [self.chatBarMoreView removeItematIndex:4];
    [self.chatBarMoreView removeItematIndex:5];
    [self.chatBarMoreView removeItematIndex:6];
    self.chatBarMoreView.delegate = self;
    
    [[CustomChatMessageCell appearance] setAvatarSize:40.f];
    [[CustomChatMessageCell appearance] setAvatarCornerRadius:20.0f];
    
    //新增一个功能按钮
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"send_question"] highlightedImage:[UIImage imageNamed:@"send_question"] title:@"发题"];
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"send_summarize"] highlightedImage:[UIImage imageNamed:@"send_summarize"] title:@"发总结"];
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"send_digest"] highlightedImage:[UIImage imageNamed:@"send_digest"] title:@"发摘记"];
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"send_schedule"] highlightedImage:[UIImage imageNamed:@"send_schedule"] title:@"发日程"];
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"资料设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
    self.navigationItem.rightBarButtonItem = right;
    
//    [self tableViewDidTriggerHeaderRefresh];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
}

//发送消息
- (void)sendRecommendFriend:(NSDictionary *)dataDic {
    __weak typeof(self) weakSelf = self;
    
    EMChatType current_type;
    NSString *to_id = @""; //接收方ID
    if (self.type == CHAT_TYPE_PERSONAL) {
        //表示单聊
        to_id = self.conversation.conversationId;
        current_type = EMChatTypeChat;
    }else {
        to_id = self.group.groupId;
        current_type = EMChatTypeGroupChat;
    }
    
    EMMessage *message = [EaseSDKHelper getTextMessage:@"" to:to_id messageType:current_type messageExt:dataDic];
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        NSLog(@"发送消息成功！！！");
    } completion:^(EMMessage *message, EMError *error) {
        [weakSelf addMessageToDataSource:message progress:nil];
        [weakSelf.tableView reloadData];
    }];
}

- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index {
    NSLog(@"did item index == %ld", index);
    if (index == 3) {
        //代表点击了发题功能
        NSLog(@"跳转到选择题目的界面");
        SendQuestionViewController *sendQuestion = [[SendQuestionViewController alloc] init];
        [self.navigationController pushViewController:sendQuestion animated:YES];
    }else if (index == 4) {
        //发总结
        Send_SummarizeViewController *summarize = [[Send_SummarizeViewController alloc] init];
        [self.navigationController pushViewController:summarize animated:YES];
        
    }else if (index == 5) {
        //发摘记
        Send_DigestViewController *digest = [[Send_DigestViewController alloc] init];
        [self.navigationController pushViewController:digest animated:YES];
        
    }else if (index == 6) {
        //发日程
        Send_SchduleViewController *schdule = [[Send_SchduleViewController alloc] init];
        [self.navigationController pushViewController:schdule animated:YES];
    }
}

//选中用户头像
- (void)messageViewController:(EaseMessageViewController *)viewController didSelectAvatarMessageModel:(id<IMessageModel>)messageModel {
    NSLog(@"messsage model === %@", messageModel);
}

//选中消息回调方法
- (BOOL)messageViewController:(EaseMessageViewController *)viewController didSelectMessageModel:(id<IMessageModel>)messageModel {
    NSLog(@"ext == %@", messageModel.message.ext);
    NSDictionary *extDic = messageModel.message.ext;
    if ([extDic[@"type"] isEqualToString:@"行测"]) {
        NSLog(@"跳转到题目解析界面");
        LookQuestionDetailsViewController *look = [[LookQuestionDetailsViewController alloc] init];
        look.question_id = extDic[@"id"];
        look.isCanDo = YES;
        [self.navigationController pushViewController:look animated:YES];
        return YES;
    }else if ([extDic[@"type"] isEqualToString:@"tips"]) {
        NSLog(@"跳转tips详情界面");
        Send_TipsViewController *tips = [[Send_TipsViewController alloc] init];
        tips.tips_id = messageModel.message.ext[@"id"];
        [self.navigationController pushViewController:tips animated:YES];
        return YES;
    }else if ([extDic[@"type"] isEqualToString:@"exam"]) {
        NSLog(@"跳转exam详情界面");
        Send_ExamViewController *exam = [[Send_ExamViewController alloc] init];
        exam.exam_id = messageModel.message.ext[@"id"];
        [self.navigationController pushViewController:exam animated:YES];
        return YES;
    }else if ([extDic[@"type"] isEqualToString:@"study"]) {
        NSLog(@"跳转study详情界面");
        Send_StudyViewController *study = [[Send_StudyViewController alloc] init];
        study.study_id = messageModel.message.ext[@"id"];
        [self.navigationController pushViewController:study animated:YES];
        return YES;
    }else if ([extDic[@"type"] isEqualToString:@"drill"]) {
        NSLog(@"跳转drill详情界面");
        Send_DrillViewController *drill = [[Send_DrillViewController alloc] init];
        drill.isShowSelectQuestion = NO;
        drill.Drill_details_id = messageModel.message.ext[@"id"];
        drill.Drill_question_id = messageModel.message.ext[@"question_id"];
        [self.navigationController pushViewController:drill animated:YES];
        return YES;
    }else if ([extDic[@"type"] isEqualToString:@"摘记"]) {
        NSLog(@"摘记");
        [self pushDigestDetailsView:extDic[@"id"]];
    }else if ([extDic[@"type"] isEqualToString:@"日程"]) {
        NSLog(@"日程");
        Chat_ScheduleInfoViewController *schedule = [[Chat_ScheduleInfoViewController alloc] init];
        if (messageModel.isSender) {
            schedule.schedule_array = extDic[@"dataDic"];
        }else {
            schedule.schedule_array = [self returnFormatterScheduleData:extDic[@"message_attr_is_date_content"]];
        }
        
        [self.navigationController pushViewController:schedule animated:YES];
    }
    return NO;
}

- (NSArray *)returnFormatterScheduleData:(NSString *)scheduleString {
    //数据格式
//    NSDictionary *dic = @{@"time":time,@"content":content,@"color_r":color_r,@"color_g":color_g,@"color_b":color_b,@"indexpath":indexpath,@"tag_index":tag_index,@"course_ids":course_ids};
    NSData *data = [scheduleString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    NSLog(@"array == %@", array);
    NSMutableArray *return_array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in array) {
        //将时间转成数组
        NSArray *time_array = [dic[@"key"] componentsSeparatedByString:@":"];
        NSInteger left = [time_array[0] integerValue] * 2;
        if ([time_array[1] isEqualToString:@"30"]) {
            left += 1;
        }
        
        NSDictionary *return_dic = @{@"time":dic[@"key"],
                                     @"content":dic[@"name"],
                                     @"color_r":@"70",
                                     @"color_g":@"156",
                                     @"color_b":@"247",
                                     @"indexpath":[NSString stringWithFormat:@"0-%ld", left],
                                     @"tag_index":@"999",
                                     @"course_ids":@"1-12-3"};
        [return_array addObject:return_dic];
    }
    return [return_array copy];
}

/**
 根据传入时间（HH:mm）往后延续半小时  并返回
 
 @param customTime 传入时间参数
 @return 返回半小时之后的时间
 */
- (NSString *)afterTimeWithCustomTIme:(NSString *)customTime {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"HH:mm"];
    NSDate *date = [formater dateFromString:customTime];
    NSTimeInterval interval = 30 * 60;
    NSDate *after_time = [NSDate dateWithTimeInterval:interval sinceDate:date];
    NSString *after_string = [formater stringFromDate:after_time];
    return after_string;
}

#pragma mark - EaseMessageViewControllerDataSource
//自定义cell
- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel {
    if (!messageModel.message.ext) {
        return nil;
    }
    //行测,tips,exam,study,drill,摘记,日程
    if (messageModel.bodyType == EMMessageBodyTypeText && ([messageModel.message.ext[@"type"] isEqualToString:@"行测"]
            || [messageModel.message.ext[@"type"] isEqualToString:@"tips"]
            || [messageModel.message.ext[@"type"] isEqualToString:@"exam"]
            || [messageModel.message.ext[@"type"] isEqualToString:@"study"]
            || [messageModel.message.ext[@"type"] isEqualToString:@"drill"]
            || [messageModel.message.ext[@"type"] isEqualToString:@"摘记"]
            || [messageModel.message.ext[@"type"] isEqualToString:@"日程"])) {
        NSString *identifier = [CustomChatMessageCell cellIdentifierWithModel:messageModel];
        CustomChatMessageCell *cell = (CustomChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[CustomChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier model:messageModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = messageModel;
        return cell;
    }
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth {
    NSDictionary *ext = messageModel.message.ext;
    if (ext != nil) {
        if (messageModel.bodyType == EMMessageBodyTypeText && ([messageModel.message.ext[@"type"] isEqualToString:@"行测"]
                                                               || [messageModel.message.ext[@"type"] isEqualToString:@"tips"]
                                                               || [messageModel.message.ext[@"type"] isEqualToString:@"exam"]
                                                               || [messageModel.message.ext[@"type"] isEqualToString:@"study"]
                                                               || [messageModel.message.ext[@"type"] isEqualToString:@"drill"]
                                                               || [messageModel.message.ext[@"type"] isEqualToString:@"摘记"]
                                                               || [messageModel.message.ext[@"type"] isEqualToString:@"日程"])) {
            return [CustomChatMessageCell cellHeightWithModel:messageModel];
        }
    }
    return 0.0;
}

//- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message
//{
//    id<IMessageModel> model = nil;
//    model = [[EaseMessageModel alloc] initWithMessage:message];
//
//    if (model.isSender) {//自己发送
//
//        model.message.ext = @{@"avatar":[[NSUserDefaults standardUserDefaults] objectForKey:@"headimgurl"],@"nickname":[[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"]};
//        //头像
//        model.avatarURLPath = [[NSUserDefaults standardUserDefaults] objectForKey:@"headimgurl"];
//        //昵称
//        model.nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
//        //头像占位图
//        model.avatarImage = [UIImage imageNamed:@"date"];
//
//    }else{//对方发送
//        //头像占位图
//        model.avatarImage = [UIImage imageNamed:@"date"];
//        //头像
//        model.avatarURLPath = message.ext[@"avatar"];
//        //昵称
//        model.nickname =  message.ext[@"nickname"];
//
//    }
//
//
//    return model;
//}

- (void)settingAction {
    NSLog(@"11111111111111111");
    NSLog(@"111  ==== %u", self.conversation.type);
    if (self.conversation.type == EMConversationTypeGroupChat) {
        switch (self.type) {
            case CHAT_TYPE_OFFICIAL_GROUP:
            {
                //官方群设置
                GroupDataSettingViewController *setting = [[GroupDataSettingViewController alloc] init];
                setting.group_id = self.group.groupId;
                __weak typeof(self) weakSelf = self;
                //清空聊天记录
                setting.touchRemoveAllMessageHistory = ^{
                    EMError *error = nil;
                    [weakSelf.conversation deleteAllMessages:&error];
                    [weakSelf.messsagesSource removeAllObjects];
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.tableView reloadData];
                };
                //删除并退出群
                setting.touchExitGroup = ^{
                    __weak typeof(self) weakSelf = self;
                    if (self.group.permissionType == EMGroupPermissionTypeOwner) {
                        [[EMClient sharedClient].groupManager destroyGroup:self.group.groupId finishCompletion:^(EMError *aError) {
                            if (aError) {
                                [weakSelf showHint:@"销毁失败"];
                            }else {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                    }else {
                        [[EMClient sharedClient].groupManager leaveGroup:self.group.groupId completion:^(EMError *aError) {
                            if (aError) {
                                [weakSelf showHint:@"退出失败"];
                            }else {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                    }
                };
                [self.navigationController pushViewController:setting animated:YES];
            }
                break;
            case CHAT_TYPE_NOMAL_GROUP:
            {
                NSLog(@"nomal  nomal nomal");
                //普通群设置
                NomalGroupSettingViewController *nomal = [[NomalGroupSettingViewController alloc] init];
                nomal.group_id = self.group.groupId;
                __weak typeof(self) weakSelf = self;
                //清空聊天记录
                nomal.touchRemoveAllMessageHistory = ^{
                    EMError *error = nil;
                    [weakSelf.conversation deleteAllMessages:&error];
                    [weakSelf.messsagesSource removeAllObjects];
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.tableView reloadData];
                };
                //删除并退出群
                nomal.touchExitGroup = ^{
                    __weak typeof(self) weakSelf = self;
                    if (self.group.permissionType == EMGroupPermissionTypeOwner) {
                        [[EMClient sharedClient].groupManager destroyGroup:self.group.groupId finishCompletion:^(EMError *aError) {
                            if (aError) {
                                [weakSelf showHint:@"销毁失败"];
                            }else {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                    }else {
                        [[EMClient sharedClient].groupManager leaveGroup:self.group.groupId completion:^(EMError *aError) {
                            if (aError) {
                                [weakSelf showHint:@"退出失败"];
                            }else {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                    }
                };
                [self.navigationController pushViewController:nomal animated:YES];
            }
                break;
            case CHAT_TYPE_PERSONAL:
            {
                //单聊
            }
                break;
                
            default:
                NSLog(@"unknow unknow");
                break;
        }
    }
}

- (void)backAction {
    if (self.isNewCreat) {
        //新建的聊天界面
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[PartnerViewController class]]) {
                PartnerViewController *VC =(PartnerViewController *)controller;
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//跳转到摘记详情
- (void)pushDigestDetailsView:(NSString *)digest_id {
    LookContentViewController *content = [[LookContentViewController alloc] init];
    content.digest_id = digest_id;
    [self.navigationController pushViewController:content animated:YES];
//    __weak typeof(self) weakSelf = self;
//    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_abstract_detail" Dic:@{@"id_":digest_id} SuccessBlock:^(id responseObject) {
//        if ([responseObject[@"state"] integerValue] == 1) {
//            LookContentViewController *content = [[LookContentViewController alloc] init];
//            content.contentDic = responseObject[@"data"];
//            [weakSelf.navigationController pushViewController:content animated:YES];
//        }else {
//            [weakSelf showHint:@"网络请求失败"];
//        }
//    } FailureBlock:^(id error) {
//        [weakSelf showHint:@"网络请求失败"];
//    }];
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
