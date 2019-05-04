//
//  TraningDoQuestionModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/10.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 题干数据
 */
@interface TraningDoQuestionModel : NSObject

/** 题目类型 */
@property (nonatomic, strong) NSString *question_type;

/** 题干 */
@property (nonatomic, strong) NSString *question_content;

/** 题干高度 */
@property (nonatomic, assign) CGFloat question_content_height;

@end



@interface TraningAnswerModel : NSObject

@property (nonatomic, strong) NSString *answer_content;

@end

NS_ASSUME_NONNULL_END
