//
//  ChatMessageModel.h
//  weihouDemo
//
//  Created by 钟文斌 on 2019/2/14.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 消息类型
 */
typedef NS_OPTIONS(NSUInteger, MessageType) {
    MessageTypeText=1,
    MessageTypeVoice,
    MessageTypeImage
};


/*
 消息发送方
 */
typedef NS_OPTIONS(NSUInteger, MessageSenderType) {
    MessageSenderTypeMe=1,
    MessageSenderTypeOther
};



/*
 消息发送状态
 */

typedef NS_OPTIONS(NSUInteger, MessageSentStatus) {
    MessageSentStatusSended=1,//送达
    MessageSentStatusUnSended, //未发送
    MessageSentStatusSending, //正在发送
};

/*
 消息接收状态
 */

typedef NS_OPTIONS(NSUInteger, MessageReadStatus) {
    MessageReadStatusRead=1,//消息已读
    MessageReadStatusUnRead //消息未读
};


/*
 
 只有当消息送达的时候，才会出现 接收状态，
 消息已读 和未读 仅仅针对自己
 
 
 未送达显示红色，
 发送中显示菊花
 送达状态彼此互斥
 
 
 
 */

@interface ChatMessageModel : NSObject

@property (nonatomic, assign) MessageType         messageType;
@property (nonatomic, assign) MessageSenderType   messageSenderType;
@property (nonatomic, assign) MessageSentStatus   messageSentStatus;
@property (nonatomic, assign) MessageReadStatus   messageReadStatus;

/**
 名称字符串
 */
@property (nonatomic, strong) NSString *name_string;

/**
 内容字符串
 */
@property (nonatomic, strong) NSString *content_string;

- (CGFloat)returnCellHeight;
- (CGFloat)returnStringWidth;
- (NSMutableAttributedString *)returnFinishShowMessage;

@end

NS_ASSUME_NONNULL_END
