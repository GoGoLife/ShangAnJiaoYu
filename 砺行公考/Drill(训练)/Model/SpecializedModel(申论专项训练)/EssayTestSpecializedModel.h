//
//  EssayTestSpecializedModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/17.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EssayTestSpecializedModel : NSObject

/**
 专项训练ID
 */
@property (nonatomic, strong) NSString *specialized_id;

/**
 专项训练文本数组
 */
@property (nonatomic, strong) NSArray *specialized_content_list;

/**
 专项训练解析数组
 */
@property (nonatomic, strong) NSArray *specialized_parsing_list;

/**
 专项训练内容图片数组
 */
@property (nonatomic, strong) NSArray *specialized_content_file_list;

/**
 专项训练解析图片数组
 */
@property (nonatomic, strong) NSArray *specialized_parsing_file_list;

/**
 最终的内容文本
 */
@property (nonatomic, strong) NSString *finish_content;

/**
 最终的解析文本
 */
@property (nonatomic, strong) NSString *finish_prasing;

/**
 最终的文本高度
 */
@property (nonatomic, assign) CGFloat finish_content_height;

/**
 最终的解析高度
 */
@property (nonatomic, assign) CGFloat finish_prasing_height;

/**
 用户的答案
 */
@property (nonatomic, strong) NSString *user_answer;


@end

NS_ASSUME_NONNULL_END
