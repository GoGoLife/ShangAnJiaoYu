//
//  SummarizeBookTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CELL_TYPE) {
    CELL_TYPE_TIPS = 0,         //tips总结本
    CELL_TYPE_EXAM,             //考试总结
    CELL_TYPE_STUDY,            //学习总结
    CELL_TYPE_DRILL             //训练总结
};

NS_ASSUME_NONNULL_BEGIN

@interface SummarizeBookTableViewCell : UITableViewCell

//总结类型  及   出处
@property (nonatomic, strong) UILabel *top_label;

//收录的题目内容
@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, strong) UILabel *answer_label_A;

@property (nonatomic, strong) UILabel *answer_label_B;

@property (nonatomic, strong) UILabel *answer_label_C;

@property (nonatomic, strong) UILabel *answer_label_D;

//总结内容
@property (nonatomic, strong) UILabel *summarize_label;

@property (nonatomic, strong) UILabel *date_label;

//是否支持选择  YES == 可选择   NO === 不可选择
@property (nonatomic, assign) BOOL isSupportSelect;

@property (nonatomic, strong) UIImageView *select_image;

//是否隐藏总结Label   以及   时间Label
@property (nonatomic, assign) BOOL isHiddenSummarizeLabel;

@end

NS_ASSUME_NONNULL_END
