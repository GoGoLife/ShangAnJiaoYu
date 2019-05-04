//
//  ConversationListViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ConversationListViewController.h"
#import "GlobarFile.h"
#import <EaseConvertToCommonEmoticonsHelper.h>
#import "ChatViewController.h"

/**<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource>*/

@interface ConversationListViewController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource>

@end

@implementation ConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = FRAME(0, 150, self.view.bounds.size.width, self.view.bounds.size.height - 150);
    
    self.delegate = self;
    self.dataSource = self;
    
    [self tableViewDidTriggerHeaderRefresh];
    self.showRefreshHeader = YES;
}

- (NSAttributedString*)conversationListViewController:(EaseConversationListViewController*)conversationListViewController latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel {
    NSString *latestMessageTitle =@"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if(lastMessage) {
        EMMessageBody*messageBody = lastMessage.body;
        switch(messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            }break;
            case EMMessageBodyTypeText:{
                //表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:((EMTextMessageBody*)messageBody).text];
                latestMessageTitle = didReceiveText;
                if([lastMessage.ext objectForKey:@"em_is_big_expression"]) {
                    latestMessageTitle =@"[动画表情]";
                }
            }
                break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle =@"[音频]";
            }
                break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            }
                break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            }
                break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            }
                break;
            default: {
            }break;
        }
    }
    NSMutableAttributedString*attStr = [[NSMutableAttributedString alloc]initWithString:latestMessageTitle];
    return attStr;
}

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel {
    NSLog(@"11111111111111");
    ChatViewController *chat = [[ChatViewController alloc] initWithConversationChatter:conversationModel.conversation.conversationId conversationType:conversationModel.conversation.type];
    [self.navigationController pushViewController:chat animated:YES];
}

//- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController modelForConversation:(EMConversation *)conversation {
//    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
//    if (model.conversation.type == EMConversationTypeChat) {
//        NSDictionary *dic = conversation.lastReceivedMessage.ext;
//        if(dic[@"nickname"] == nil || dic[@"avatar"] == nil){
//            //头像占位图
//            model.avatarImage = [UIImage imageNamed:@"date"];
//        }else{
//
//            model.title = dic[@"nickname"];
//            model.avatarURLPath = dic[@"avatar"];
//            //头像占位图
//            model.avatarImage = [UIImage imageNamed:@"date"];
//        }
//    } else if (model.conversation.type == EMConversationTypeGroupChat) {
//        NSString *imageName = @"groupPublicHeader";
//        if (![conversation.ext objectForKey:@"subject"])
//        {
//            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
//            for (EMGroup *group in groupArray) {
//                if ([group.groupId isEqualToString:conversation.conversationId]) {
//                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
//                    [ext setObject:group.subject forKey:@"subject"];
//                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
//                    conversation.ext = ext;
//                    break;
//                }
//            }
//        }
//        NSDictionary *ext = conversation.ext;
//        model.title = [ext objectForKey:@"subject"];
//        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
//        model.avatarImage = [UIImage imageNamed:imageName];
//
//        //头像占位图
//        model.avatarImage = [UIImage imageNamed:@"date"];
//    }
//    return model;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
