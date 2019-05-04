//
//  IntroduceViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 介绍类型

 - IntroduceType_BigEssayTraining: 大申论通关
 - IntroduceType_SmallEssayTraining: 小申论通关
 - IntroduceType_BigEssayTests: 大申论解题训练
 - IntroduceType_SmallEssayTests: 小申论解题训练
 */
typedef NS_ENUM(NSInteger, IntroduceType) {
    IntroduceType_BigEssayTraining = 0,
    IntroduceType_SmallEssayTraining,
    IntroduceType_BigEssayTests,
    IntroduceType_SmallEssayTests
};

@interface IntroduceViewController : BaseViewController

@property (nonatomic, strong) NSString *training_id;

@property (nonatomic, assign) IntroduceType introduceType;

/**
 小申论数量 （只有小申论能用到）
 */
@property (nonatomic, assign) NSInteger smallEssay_topic_count;

@end

NS_ASSUME_NONNULL_END
