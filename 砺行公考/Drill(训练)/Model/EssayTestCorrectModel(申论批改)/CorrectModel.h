//
//  CorrectModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/24.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CorrectModel : NSObject

/**
 试卷title
 */
@property (nonatomic, strong) NSString *test_string;

/**
 题目title
 */
@property (nonatomic, strong) NSString *question_string;

/**
 题目高度
 */
@property (nonatomic, assign) CGFloat question_height;

/**
 作者
 */
@property (nonatomic, strong) NSString *user_name_string;

/**
 等级
 */
@property (nonatomic, strong) NSString *level_string;

/**
 批改标题
 */
@property (nonatomic, strong) NSString *correct_title;

/**
 原文本
 */
@property (nonatomic, strong) NSString *text_string;

/**
 批注数组
 */
@property (nonatomic, strong) NSArray *correct_array;

/**
 保存了点击字符的字符串  用于后续识别点击
 */
@property (nonatomic, strong) NSArray *replace_array;

/**
 最终的文本高度
 */
@property (nonatomic, assign) CGFloat finish_text_height;

@end

NS_ASSUME_NONNULL_END
