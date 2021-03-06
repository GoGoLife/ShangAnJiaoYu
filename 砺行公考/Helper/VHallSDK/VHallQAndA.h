//
//  VHallQAndA.h
//  VHallSDK
//
//  Created by Ming on 16/8/23.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

@protocol VHallQADelegate <NSObject>
@optional

- (void)reciveQAMsg:(NSArray *)msgs;

@end

@interface VHallQAndA : VHallBasePlugin

@property (nonatomic, assign) id <VHallQADelegate> delegate;

/**
 *  发送提问内容
 *  成功回调成功Block
 *  失败回调失败Block
 *  		失败Block中的字典结构如下：
 * 		key:code 表示错误码
 *		value:content 表示错误信息
 */
- (void)sendMsg:(NSString *)msg success:(void(^)())success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;

/**
 * 获取问答历史记录
 * 在进入直播活动后调用
 * @param showAll               保留字段
 * @param success               成功回调成功Block 返回问答历史记录
 * @param reslutFailedCallback  失败回调失败Block
 *                              失败Block中的字典结构如下：
 *                              key:code 表示错误码
 *                              value:content 表示错误信息
 */
- (void)getQAndAHistoryWithType:(BOOL)showAll success:(void(^)(NSArray* msgs))success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;
@end
