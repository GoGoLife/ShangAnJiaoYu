//
//  AnalysisTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//
//
//
//              解析CELL

#import <UIKit/UIKit.h>
#import "StarsView.h"

#define ANALYSIS_FIRST_CELL_HEIGHT 110
#define ANALYSIS_SECOND_CELL_HEIGHT 200

@protocol AnalysisTableViewCellDelegate <NSObject>


/** 点击精解挑刺按钮 */
- (void)touchFineSolutionAction;

/** 点击保存到总结本  （tips总结）*/
- (void)touchSaveToSummarizeBook;

@end

@interface AnalysisTableViewCell : UITableViewCell

//点击查看精解按钮    并通知cell进行二次布局  刷新tableview
@property (nonatomic, copy) void(^touchAnslysisAction)(void);

/** 添加错因标签成功  回调  通知刷新数据 */
@property (nonatomic, copy) void(^AddErrorTagSuccessAction)(void);

@property (nonatomic, strong) NSString *question_id;

/** 判断是否开始二次布局 */
@property (nonatomic, assign) BOOL isStartSecondLayout;

/** 砺行方法label */
@property (nonatomic, strong) UILabel *analysis_function_label;

@property (nonatomic, strong) NSString *analysis_function_string;

/** 答案解析文本 */
@property (nonatomic, strong) NSString *analysisString;

/** 答案解析 */
@property (nonatomic, strong) UILabel *analysisLabel;

/** 错因标签数据 */
@property (nonatomic, strong) NSArray *errorTagArry;

/** 分数 */
@property (nonatomic, assign) CGFloat stars_score;

/** 星级难度展示 */
@property (nonatomic, strong) StarsView *stars_view;

/** 正确答案 */
@property (nonatomic, strong) NSString *correct_answer_string;

@property (nonatomic, weak) id<AnalysisTableViewCellDelegate> delegate;

@end
