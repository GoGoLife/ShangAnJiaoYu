//
//  EssayTests_HomeViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

/**
 申论训练类型

 - SMALL_ESSAY_TESTS_TYPE: 解题训练--小申论
 - BIG_ESSAY_TESTS_TYPE: 解题训练--大申论
 - ESSAY_TESTS_TYPE_BigTestTraining: 大申论通关训练
 - ESSAY_TESTS_TYPE_SmallTestTraining: 小申论通关训练
 */
typedef NS_ENUM(NSUInteger, ESSAY_TESTS_TYPE) {
    SMALL_ESSAY_TESTS_TYPE = 0,
    BIG_ESSAY_TESTS_TYPE,
    ESSAY_TESTS_TYPE_BigTestTraining,
    ESSAY_TESTS_TYPE_SmallTestTraining
};

@interface EssayTests_HomeViewController : BaseViewController

@property (nonatomic, assign) ESSAY_TESTS_TYPE type;

/** 申论通关训练ID */
@property (nonatomic, strong) NSString *TestTraining_id;

@end
