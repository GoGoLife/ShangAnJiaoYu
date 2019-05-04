//
//  OrderTwoTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ORDER_TWO_CELL_HEIGHT 50

@interface OrderTwoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *image_view;

@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, strong) UILabel *tag_label;

@property (nonatomic, strong) UIImageView *select_image;

@end

NS_ASSUME_NONNULL_END
