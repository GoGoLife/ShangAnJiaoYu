//
//  TrainingAnalysisViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 枚举 判断是第几轮的解析

 - AnalysisType_First: 第一轮
 - AnalysisType_Second: 第二轮
 - AnalysisType_Third: 第三轮
 */
typedef NS_ENUM(NSInteger, AnalysisType) {
    AnalysisType_First = 0,
    AnalysisType_Second,
    AnalysisType_Third,
    AnalysisType_Fourth,
    AnalysisType_Fifth,
    AnalysisType_Sixth,
    AnalysisType_Seventh,
    AnalysisType_Eighth,
    AnalysisType_Nineth,
    AnalysisType_Tenth,
    AnalysisType_FiveRounds_First
};

@interface TrainingAnalysisViewController : BaseViewController

/**
 用于解析的题目ID数组
 */
@property (nonatomic, strong) NSArray *analysis_question_id_array;

@property (nonatomic, assign) AnalysisType type;

@end

NS_ASSUME_NONNULL_END
