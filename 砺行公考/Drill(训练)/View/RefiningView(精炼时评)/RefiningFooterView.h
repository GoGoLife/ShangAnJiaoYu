//
//  RefiningFooterView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefiningModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RefiningFooterViewDelegate <NSObject>

- (void)touchPraiseButtonAction:(UIButton *)button withSection:(NSInteger)section;

@end

@interface RefiningFooterView : UIView

//构造方法
+ (instancetype)creatFooterViewWithModel:(RefiningModel *)model Frame:(CGRect)frame;

@property (nonatomic, assign) NSInteger section;

/** 老师点评 */
@property (nonatomic, strong) UILabel *teacher_review_label;

/** 分享 */
@property (nonatomic, strong) UIButton *share_button;

/** 点赞 */
@property (nonatomic, strong) UIButton *praise_button;

@property (nonatomic, weak) id<RefiningFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
