//
//  StartViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

/**
 获取到的题目列表的类型
 
 - EXERCISE_TYPE_BASICS:
 QuestionType_Basics -------------     基础能力训练
 QuestionType_Function -------------   方法训练
 QuestionType_Bank -------------       全真
 */
typedef NS_ENUM(NSInteger, QuestionType) {
    QuestionType_Basics = 0,
    QuestionType_Function,
    QuestionType_Bank
};

@interface StartViewController : BaseViewController

//当前试卷的ID
@property (nonatomic, strong) NSString *information_id;

//题目类型   区分该进入什么类型的试卷
@property (nonatomic, assign) QuestionType type;

@end
