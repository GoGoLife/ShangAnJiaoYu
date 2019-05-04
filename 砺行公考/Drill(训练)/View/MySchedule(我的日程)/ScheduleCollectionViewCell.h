//
//  ScheduleCollectionViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYLabel.h"

@protocol ScheduleCollectionViewCellDelegate <NSObject>

- (void)doubleGestureWithAction:(NSIndexPath *)indexPath;

@end

@interface ScheduleCollectionViewCell : UICollectionViewCell

//控制选择图片是否显示
@property (nonatomic, assign) BOOL isSecelt;

@property (nonatomic, assign) VerticalAlignment textAlignment;

@property (nonatomic, strong) MYLabel *label;

@property (nonatomic, strong) UIImageView *select_image;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<ScheduleCollectionViewCellDelegate> delegate;

/**
 添加遮罩层   表示选中
 */
- (void)addBackViewToSelf;

/**
 移除遮罩层
 */
- (void)removeBackView;

@end
