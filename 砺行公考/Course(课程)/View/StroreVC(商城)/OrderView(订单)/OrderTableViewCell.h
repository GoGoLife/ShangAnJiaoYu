//
//  OrderTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ORDER_CELL_HEIGHT 110

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *image_view;

@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, strong) UILabel *category_label;

@property (nonatomic, strong) UILabel *price_label;

@property (nonatomic, strong) UILabel *pay_peoples_label;

@property (nonatomic, strong) UILabel *number_label;

@property (nonatomic, assign) BOOL isShowSelectButton;

@property (nonatomic, strong) UIImageView *left_image;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
