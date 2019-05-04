//
//  ChainReactionView.h
//  LianDong
//
//  Created by 薛林 on 16/9/17.
//  Copyright © 2016年 xuelin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ANSWER_RESULT_HEIGHT (([UIScreen mainScreen].bounds.size.width - 180) / 5 * 4 + 80 + 44)

@protocol ChainReactionViewDelegate  <NSObject>

- (void)returnCollectionviewDidSelectIndexPath:(NSIndexPath *)indexPath;

@end

@interface ChainReactionView : UIView

@property (nonatomic, assign) BOOL isShowYESAndNO;

@property (nonatomic, strong) NSArray *data_array;

- (instancetype)initWithFrame:(CGRect)frame withNameArray:(NSArray *)nameArray;

/**
 *  创建需要联动数组
 */
@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, weak) id<ChainReactionViewDelegate> delegate;

@end
