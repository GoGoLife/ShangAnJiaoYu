//
//  TestTrainingFirstModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/18.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestTrainingFirstModel : NSObject

@property (nonatomic, strong) NSString *question_id;

/** 题目题干 */
@property (nonatomic, strong) NSString *question_title;

/** 题目要求 */
@property (nonatomic, strong) NSArray *question_require;

@property (nonatomic, strong) NSString *finish_require_string;

/** 题目数据高度 （题干 + 要求） */
@property (nonatomic, assign) CGFloat question_content_height;

/** 审题判断的题干 */
@property (nonatomic, strong) NSString *judge_title;

/** 选项 */
@property (nonatomic, strong) NSArray *judge_option_list;

/** 解析 */
@property (nonatomic, strong) NSString *judge_parsing;

/** 解析的高度 */
@property (nonatomic, assign) CGFloat judge_parsing_height;

@end

NS_ASSUME_NONNULL_END
