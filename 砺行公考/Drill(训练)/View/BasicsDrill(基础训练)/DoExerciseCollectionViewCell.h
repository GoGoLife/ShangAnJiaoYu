//
//  DoExerciseCollectionViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReturnSelectResultDelegate <NSObject>

- (void)returnSelectResult:(NSArray *)result withIndexPath:(NSIndexPath *)indexPath;

@end

@interface DoExerciseCollectionViewCell : UICollectionViewCell

//是否单选
@property (nonatomic, assign) BOOL isRadio;

@property (nonatomic, weak) id<ReturnSelectResultDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

//单选   //  多选
@property (nonatomic, strong) UILabel *label;

//总共有多少题
@property (nonatomic, assign) NSInteger question_num;

//第几题
@property (nonatomic, strong) UILabel *numberLabel;

//题目
@property (nonatomic, strong) UILabel *titleLabel;

//下一题
@property (nonatomic, strong) UIButton *next;

//答案数组
@property (nonatomic, strong) NSArray *answer_array;

//用户选择的答案数组
@property (nonatomic, strong) NSArray *select_answer_array;

@end
