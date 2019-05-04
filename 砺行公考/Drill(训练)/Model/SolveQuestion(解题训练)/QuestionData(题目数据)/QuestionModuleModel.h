//
//  QuestionModuleModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/17.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionModuleModel : NSObject

/**
 题目模块ID
 */
@property (nonatomic, strong) NSString *moduleID;

/**
 题目模块名称
 */
@property (nonatomic, strong) NSString *moduleName;


/**
 模块说明
 */
@property (nonatomic, strong) NSString *modeuleTitle;

/**
 题目模块包含的题目数组
 */
@property (nonatomic, strong) NSArray *moduleQuestionArray;

@end

NS_ASSUME_NONNULL_END
