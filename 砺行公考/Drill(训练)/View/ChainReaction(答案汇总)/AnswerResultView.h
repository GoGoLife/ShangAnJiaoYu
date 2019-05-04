//
//  AnswerResultView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChainReactionView.h"

@interface AnswerResultView : UIView

- (instancetype)initWithFrame:(CGRect)frame withCordArray:(NSArray *)array;

@property (nonatomic, strong) ChainReactionView *reactionView;

//答案数据   数组 
@property (nonatomic, strong) NSArray *data_array;

//外部调用点击  保存并退出  按钮执行操作
@property (nonatomic, copy) void(^touchSaveActionBlock)(void);

//外部调用点击  交卷并查看结果  按钮执行操作
@property (nonatomic, copy) void(^touchSubmitActionBlock)(void);

@end
