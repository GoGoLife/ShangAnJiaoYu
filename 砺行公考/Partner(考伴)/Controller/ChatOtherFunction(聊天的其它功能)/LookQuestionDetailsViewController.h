//
//  LookQuestionDetailsViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/8.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LookQuestionDetailsViewController : BaseViewController

/** 题目ID */
@property (nonatomic, strong) NSString *question_id;

/** 用于判断是否可以进行做题 */
@property (nonatomic, assign) BOOL isCanDo;

@end


//自带的Model
@interface LookDetailsModel : NSObject

@property (nonatomic, strong) NSString *question_content;

@property (nonatomic, strong) NSArray *answer_content;

@property (nonatomic, assign) CGFloat question_content_height;

@end

NS_ASSUME_NONNULL_END
