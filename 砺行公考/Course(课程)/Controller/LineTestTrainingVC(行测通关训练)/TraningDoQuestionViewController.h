//
//  TraningDoQuestionViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/10.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 做题类型

 - DoQuestionType_Training_Home: 通关训练
 - DoQuestionType_FiveRounds_First: 五轮   第一轮
 */
typedef NS_ENUM(NSInteger, DoQuestionType) {
    DoQuestionType_Training_First = 0,
    DoQuestionType_Training_Second,
    DoQuestionType_Training_Third,
    DoQuestionType_Training_Fourth,
    DoQuestionType_Training_Fifth,
    DoQuestionType_Training_Sixth,
    DoQuestionType_Training_Seventh,
    DoQuestionType_Training_Eighth,
    DoQuestionType_Training_Nineth,
    DoQuestionType_Training_Tenth,
    DoQuestionType_FiveRounds_First
};

@interface TraningDoQuestionViewController : BaseViewController

/** 试卷ID */
@property (nonatomic, strong) NSString *training_id;

@property (nonatomic, assign) DoQuestionType doType;

/**
 是否显示播放器
 */
@property (nonatomic, assign) BOOL isShowPlayer;

- (void)getDataWithExamWithOrder:(NSInteger)order;

@end

NS_ASSUME_NONNULL_END
