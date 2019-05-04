//
//  QuestionModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QuestionMaterialsModel.h"
#import "AnswerModel.h"

@interface QuestionModel : NSObject

/** 题目ID */
@property (nonatomic, strong) NSString *question_id;

/** 每一题的index */
@property (nonatomic, strong) NSString *question_index;

/** 总数量 */
@property (nonatomic, strong) NSString *question_all_numbers;

/** 区分  单选  多选 */
@property (nonatomic, strong) NSString *question_type;

/** 题目所属模块类型 */
@property (nonatomic, strong) NSString *question_model_type;

/** 问题题干 */
@property (nonatomic, strong) NSString *question_content;

/** 下划线数组集合 */
@property (nonatomic, strong) NSArray *underlineTextList;

/** 题干所包含的图片数据 */
@property (nonatomic, strong) NSArray *question_picture_array;

/** 材料分析题的材料 */
@property (nonatomic, strong) NSArray *question_materials_array;

/** 答案选项数组 */
@property (nonatomic, strong) NSArray *answer_array;

/** 总题数 */
@property (nonatomic, assign) NSInteger question_sum;

/** 选择的答案数组 */
@property (nonatomic, strong) NSArray *select_array;

/** 用户选择的答案数组 */
@property (nonatomic, strong) NSArray *user_selected_answer_array;


/*
 后面去掉
 */
//正确答案
@property (nonatomic, strong) NSArray *correctAnswer;

//选择的答案数组
@property (nonatomic, strong) NSArray *select_answer_array;

//题目文本的高度
@property (nonatomic, assign) CGFloat question_content_height;

//承载题目的collectionview高度
@property (nonatomic, assign) CGFloat question_collectionview_height;

@end
