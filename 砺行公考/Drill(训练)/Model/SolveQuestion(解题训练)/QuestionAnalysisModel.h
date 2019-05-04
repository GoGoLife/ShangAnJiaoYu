//
//  QuestionAnalysisModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CommentModel.h"
#import "GlobarFile.h"
#import "ErrorTagModel.h"

@interface QuestionAnalysisModel : NSObject


/** 题号 */
@property (nonatomic, strong) NSString *questionNumber;

/** 单选  多选 */
@property (nonatomic, strong) NSString *question_choice_type_;

/** 题目 */
@property (nonatomic, strong) NSString *questionString;

/** 题目高度 */
@property (nonatomic, assign) CGFloat questionStringHeight;

/** 题目图片数组 */
@property (nonatomic, strong) NSArray *question_image_array;

@property (nonatomic, assign) CGFloat questionStringAndImageHeight;

/** 选项数组 */
@property (nonatomic, strong) NSArray *answerArray;

/** 评论数组 */
@property (nonatomic, strong) NSArray<CommentModel *> *commentModelArray;

/** 解析方法 */
@property (nonatomic, strong) NSArray *analysis_function_array;

/** 星级难度 */
@property (nonatomic, strong) NSString *starLevel_stirng;

/** 答案解析String */
@property (nonatomic, strong) NSString *answerAnalysisString;

/** 答案解析String高度 */
@property (nonatomic, assign) CGFloat answerAnalysisString_height;

/** 错因标签  字符串 */
@property (nonatomic, strong) NSString *error_label_list;

/** 正确答案数组 */
@property (nonatomic, strong) NSArray *correct_answer_array;

#pragma mark ---- 自定义数据   经过处理的数据
/** 错因标签数组 */
@property (nonatomic, strong) NSArray<ErrorTagModel *> *errorTagArray;

/** 最终的方法解析数据 */
@property (nonatomic, strong) NSString *finish_function_string;

/** 最终的方法解析的高度 */
@property (nonatomic, assign) CGFloat finish_function_height;


@end
