//
//  ChatViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "EaseMessageViewController.h"

typedef NS_ENUM(NSInteger, CHAT_TYPE) {
    CHAT_TYPE_PERSONAL = 0,         //单聊
    CHAT_TYPE_OFFICIAL_GROUP,       //官方群
    CHAT_TYPE_NOMAL_GROUP           //普通群
};

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : EaseMessageViewController

@property (nonatomic, assign) CHAT_TYPE type;

//群   个人   分开
@property (nonatomic, strong) EMGroup *group;

//判断是否是新建的
@property (nonatomic, assign) BOOL isNewCreat;


/**
 发送消息  自定义

 @param dataDic 相关数据  参数：type  消息类型,   message  消息内容
 */
- (void)sendRecommendFriend:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
