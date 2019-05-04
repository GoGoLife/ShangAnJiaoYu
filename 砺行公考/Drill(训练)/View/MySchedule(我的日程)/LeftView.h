//
//  LeftView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftView : UIView

@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, copy) void(^setContentOffset)(CGPoint offset);

@end
