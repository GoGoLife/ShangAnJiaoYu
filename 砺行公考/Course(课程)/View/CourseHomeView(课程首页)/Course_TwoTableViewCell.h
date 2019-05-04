//
//  Course_TwoTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Course_Two_Cell_Height 130

@interface Course_TwoTableViewCell : UITableViewCell

//左侧image
@property (nonatomic, strong) UIImageView *left_view;

//title
@property (nonatomic, strong) UILabel *title_label;

//标签
@property (nonatomic, strong) UILabel *tag_label;

//价格
@property (nonatomic, strong) UILabel *price_label;

//购买人数
@property (nonatomic, strong) UILabel *number_label;

//好评
@property (nonatomic, strong) UILabel *good_label;

//其它说明
@property (nonatomic, strong) UILabel *remark_label;

@property (nonatomic, strong) NSArray *tag_array;

@end
