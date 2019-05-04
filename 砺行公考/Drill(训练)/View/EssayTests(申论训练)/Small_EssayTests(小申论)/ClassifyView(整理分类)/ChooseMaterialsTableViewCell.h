//
//  ChooseMaterialsTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMaterialsTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isHiddenRightImage;

//是否选中
@property (nonatomic, assign) BOOL isSelected;

//右侧选择
@property (nonatomic, strong) UIImageView *right_image;

//自定义的采点数据
@property (nonatomic, strong) UILabel *content_label;

//注解词
@property (nonatomic, strong) UILabel *tag_label;

@end
