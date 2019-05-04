//
//  SummarizeBookViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "SummarizeModel.h"
#import "AnswerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SummarizeBookViewController : BaseViewController

//获取相应总结本的数据
- (void)getHttpDataWithType:(NSString *)type;

//改变总结本的状态
- (void)changeBookType:(UIButton *)sender;

@property (nonatomic, strong) UIButton *add_button;

@property (nonatomic, strong) NSMutableArray *dataArray;

//1 === tips总结   2 === 考试总结   3 === 学习总结   4 === 训练总结
@property (nonatomic, assign) NSInteger current_type;

@end

NS_ASSUME_NONNULL_END
