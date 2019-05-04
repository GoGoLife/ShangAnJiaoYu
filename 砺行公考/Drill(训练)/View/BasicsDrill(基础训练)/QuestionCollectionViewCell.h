//
//  QuestionCollectionViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/5.
//  Copyright © 2019 钟文斌. All rights reserved.
//
/*
 ******************   重写的做题cell *********************
 
 */

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QuestionCollectionViewCellDelegate <NSObject>

- (void)returnSelectAnswerArray:(NSArray *)result AndIndexPath:(NSIndexPath *)indexPath;

@end

@interface QuestionCollectionViewCell : UICollectionViewCell

//- (void)initCellUI;

+ (instancetype)creatQuestionCollectionViewCell:(UICollectionView *)collectionview Identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath withModel:(QuestionModel *)model;

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) QuestionModel *model;

@property (nonatomic, strong) NSString *question_index;

@property (nonatomic, strong) NSString *question_all_numbers;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<QuestionCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
