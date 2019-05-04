//
//  MineCollectionViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *left_image_name;

@property (nonatomic, strong) NSString *right_image_name;

@property (nonatomic, strong) UITextField *content_textfield;

@end

NS_ASSUME_NONNULL_END
