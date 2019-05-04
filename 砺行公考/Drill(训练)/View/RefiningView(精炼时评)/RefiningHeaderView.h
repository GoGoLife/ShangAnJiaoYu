//
//  RefiningHeaderView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefiningModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RefiningHeaderViewDelegate <NSObject>

- (void)returnCurrentTouchIndex:(NSInteger)section;

@end

@interface RefiningHeaderView : UIView

//构造方法
+ (instancetype)creatHeaderViewWithModel:(RefiningModel *)model Frame:(CGRect)frame;

@property (nonatomic, assign) NSInteger section;

/** 讲师推荐 */
@property (nonatomic, strong) UITextField *recommend_field;

/** 头像 */
@property (nonatomic, strong) UIImageView *header_imageview;

/** 名称 */
@property (nonatomic, strong) UILabel *name_label;

/** 时间 */
@property (nonatomic, strong) UILabel *time_label;

/** 内容 */
@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, weak) id<RefiningHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
