//
//  TrainingSecondDoQuestionViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DoQuestionRounds) {
    DoQuestionRounds_FIRST = 0,
    DoQuestionRounds_SECOND,
    DoQuestionRounds_THIRD
};

@interface TrainingSecondDoQuestionViewController : BaseViewController

@property (nonatomic, strong) NSString *training_id;

/** 训练的轮数 */
@property (nonatomic, assign) DoQuestionRounds rounds;

@end

NS_ASSUME_NONNULL_END
