//
//  DigestBookViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "BookModel.h"
#import "BookCollectionViewCell.h"
#import "DigestContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DigestBookViewController : BaseViewController

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 判断是否显示添加或修改Cell
 */
@property (nonatomic, assign) BOOL isShowAddOrChangeCell;

@end

NS_ASSUME_NONNULL_END
