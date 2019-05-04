//
//  Drill_WriteSummarizeViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "DrillSummarizeModel.h"
#import "TipsCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface Drill_WriteSummarizeViewController : BaseViewController

@property (nonatomic, strong) DrillSummarizeModel *dataModel;

//单个训练总结的详情
@property (nonatomic, strong) NSString *Drill_details_id;

/** 题目的ID 用于删除之后再次添加 */
@property (nonatomic, strong) NSString *Drill_question_id;

@property (nonatomic, strong) UICollectionView *collectionview;

//选择的图片的Array
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UITextView *textview;

/** 是否展示选择试题的按钮 */
@property (nonatomic, assign) BOOL isShowSelectQuestion;

@end

NS_ASSUME_NONNULL_END
