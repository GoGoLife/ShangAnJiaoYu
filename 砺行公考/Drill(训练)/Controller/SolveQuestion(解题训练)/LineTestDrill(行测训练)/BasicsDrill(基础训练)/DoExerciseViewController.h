//
//  DoExerciseViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

/**
 获取到的题目列表的类型

 - EXERCISE_TYPE_BASICS:
 EXERCISE_TYPE_BASICS -------------   基础能力训练
 EXERCISE_TYPE_FUNCTION -------------   方法训练
 EXERCISE_TYPE_BANK -------------   全真
 */
typedef NS_ENUM(NSInteger, EXERCISE_TYPE) {
    EXERCISE_TYPE_BASICS = 0,           //基础能力训练做题
    EXERCISE_TYPE_FUNCTION,             //解题方法训练做题
    EXERCISE_TYPE_BANK,                 //全真题库做题
    EXERCISE_TYPE_OPTIONAL,             //自选设置做题
    EXERCISE_TYPE_ERRORBOOK_ONE,        //错题本做题(一次)
    EXERCISE_TYPE_ERRORBOOK_TWO,        //错题本做题(二次)
    EXERCISE_TYPE_ERRORBOOK_MORE,       //错题本做题(多次)
    EXERCISE_TYPE_ERRORBOOK_UNKNOW      //未知
};

@interface DoExerciseViewController : BaseViewController

//当前试卷的ID
@property (nonatomic, strong) NSString *information_id;

//根据省级ID  获取省级下面的市级试卷列表
@property (nonatomic, strong) NSString *area_id;

@property (nonatomic, assign) EXERCISE_TYPE type;

@property (nonatomic, strong) NSDictionary *question_data;

@end
