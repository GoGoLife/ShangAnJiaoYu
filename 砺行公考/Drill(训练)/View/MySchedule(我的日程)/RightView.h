//
//  RightView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RightViewDelegate<NSObject>
/**
 点击item传递的数据    方便确定点击的具体操作

 @param indexPath item所在的indexPath
 @param count 显示的数据的长度
 @param tag_string item显示的文本
 @param color_r item ---- R
 @param color_g item ---- G
 @param color_b item ---- B
 */
- (void)touchRightViewCellAction:(NSIndexPath *)indexPath
                       DataCount:(NSInteger)count
                      TagContent:(NSString *)tag_string
                         Color_R:(NSString *)color_r
                         Color_G:(NSString *)color_g
                         Color_B:(NSString *)color_b;

@end

@interface RightView : UIView

@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, weak) id<RightViewDelegate> delegate;

//从数据库加载数据
- (void)getDataFromDBDatabase;

@end
