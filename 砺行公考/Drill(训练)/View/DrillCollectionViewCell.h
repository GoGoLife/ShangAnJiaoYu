//
//  DrillCollectionViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrillCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *delete_imageview;

@property (nonatomic, assign) BOOL isShowDeleteButton;

@end
