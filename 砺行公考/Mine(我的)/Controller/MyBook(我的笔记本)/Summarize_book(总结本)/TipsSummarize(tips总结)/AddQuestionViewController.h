//
//  AddQuestionViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddQuestionViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *selected_array;

/**
 判断是不是新添加的   还是本来就有 仅仅 重新添加题目
 */
@property (nonatomic, assign) BOOL isNewCreat;

@end

NS_ASSUME_NONNULL_END
