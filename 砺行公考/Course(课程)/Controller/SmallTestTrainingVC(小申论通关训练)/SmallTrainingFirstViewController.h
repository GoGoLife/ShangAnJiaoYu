//
//  SmallTrainingFirstViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallTrainingFirstViewController : BaseViewController

/**
 试卷下的申论题目数量（非小题）
 */
@property (nonatomic, assign) NSInteger topic_count;

/** 试卷ID */
@property (nonatomic, strong) NSString *exam_id;

/** 当前题目index */
@property (nonatomic, assign) NSInteger current_question;

- (void)getDataWithOrder:(NSString *)order;

- (void)getCurrentQuestionData:(NSInteger)index withDataArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
