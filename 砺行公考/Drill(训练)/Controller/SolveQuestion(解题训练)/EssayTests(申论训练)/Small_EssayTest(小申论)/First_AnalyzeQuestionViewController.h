//
//  First_ AnalyzeQuestionViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface First_AnalyzeQuestionViewController : BaseViewController

@property (nonatomic, strong) NSArray *small_tests_id_array;

//判断当前是第几题
@property (nonatomic, assign) NSInteger question_index;

//是否显示题目的解析
@property (nonatomic, assign) BOOL isShowAnalysis;

- (void)getCurrentQuestionData:(NSInteger)index;

/**
 获取小申论的题干 要求 解析 多个选择题
 全部数据
 */
- (void)getHttpData;

@end
