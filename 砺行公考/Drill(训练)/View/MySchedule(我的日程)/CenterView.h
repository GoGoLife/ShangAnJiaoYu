//
//  CenterView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CenterViewDelegate<NSObject>

@required
- (void)returnStratIndexPath:(NSIndexPath *)startIndexPath EndIndexPath:(NSIndexPath *)endIndexPath WithIndexAtModelArray:(NSArray *)modelArray current_date_array:(NSArray *)array;


/**
 执行了删除数据操作

 @param current_date_array 传入当前日期数组
 */
- (void)executeDeleteOperation:(NSArray *)current_date_array;

@end

@interface CenterView : UIView

@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, copy) void(^setContentOffset)(CGPoint offset, NSString *month);

@property (nonatomic, weak) id<CenterViewDelegate> delegate;

//是否进行二次刷新    绑定时间的item   显示不同的颜色
@property (nonatomic, assign) BOOL isSecondReadload;

/**
 当前日期
 */
@property (nonatomic, strong) NSArray *current_date_array;

/**
 表示当前所选择的时间
 */
@property (nonatomic, strong) NSMutableArray *select_times_array;

/**
 整理所有数据
 */
- (void)formatterAllData:(NSString *)year_string;

@end
