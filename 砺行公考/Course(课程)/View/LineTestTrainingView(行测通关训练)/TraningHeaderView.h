//
//  TraningHeaderView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/10.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TraningDoQuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TraningHeaderView : UICollectionReusableView

+ (instancetype)creatTraningHeaderView:(UICollectionView *)collectionview Identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath withModel:(TraningDoQuestionModel *)model;

@end

NS_ASSUME_NONNULL_END
