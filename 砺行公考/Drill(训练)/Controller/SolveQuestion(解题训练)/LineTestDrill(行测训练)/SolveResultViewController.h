//
//  SolveResultViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface SolveResultViewController : BaseViewController

//当前试卷的ID
@property (nonatomic, strong) NSString *information_id;

//答题卡数据      上方的题目分组数据
@property (nonatomic, strong) NSArray *nameArray;

//答题卡显示的对错数据
@property (nonatomic, strong) NSArray *result_array;

//是否展示正确错误答案
@property (nonatomic, assign) BOOL isShowCorrectAnswer;


/**
 做题类型
 1 ==== 第一次做错
 2 ==== 第二次做错
 3 ==== 多次做错
 4 ==== 作对
 */
@property (nonatomic, assign) NSInteger DoExerciseType;

@end
