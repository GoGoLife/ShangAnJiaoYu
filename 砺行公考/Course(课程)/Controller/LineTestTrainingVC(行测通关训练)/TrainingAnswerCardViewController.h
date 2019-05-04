//
//  TrainingAnswerCardViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 枚举  判断当前答题卡是第几轮

 - AnswerCardType_First: 第一轮
 - AnswerCardType_Second: 第二轮
 - AnswerCardType_Third: 第三轮
 */
typedef NS_ENUM(NSInteger, AnswerCardType) {
    AnswerCardType_First = 0,
    AnswerCardType_Second,
    AnswerCardType_Third,
    AnswerCardType_Fourth,
    AnswerCardType_Fifth,
    AnswerCardType_Sixth,
    AnswerCardType_Seventh,
    AnswerCardType_Eighth,
    AnswerCardType_Nineth,
    AnswerCardType_Tenth,
    AnswerCardType_FiveRounds_First
};

@interface TrainingAnswerCardViewController : BaseViewController

@property (nonatomic, strong) NSArray *answerArray;

@property (nonatomic, assign) AnswerCardType type;

@end

NS_ASSUME_NONNULL_END
