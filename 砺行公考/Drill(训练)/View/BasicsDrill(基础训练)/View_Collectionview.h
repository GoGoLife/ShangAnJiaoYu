//
//  View_Collectionview.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineTest_Category_Model.h"

@interface View_Collectionview : UIView

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, copy) void(^returnSelectedIndex)(NSIndexPath *indexPath);

- (void)setDataArray:(NSArray *)array withIndexPath:(NSIndexPath *)indexPath;

@end
