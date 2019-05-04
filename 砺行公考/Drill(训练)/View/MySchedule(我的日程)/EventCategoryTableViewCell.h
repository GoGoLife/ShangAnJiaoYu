//
//  EventCategoryTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/28.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EventCategory_Cell_Height 50

@interface EventCategoryTableViewCell : UITableViewCell

//删除按钮
@property (nonatomic, strong) UIButton *delete_button;

//承载颜色的label
@property (nonatomic, strong) UILabel *color_label;

//标签描述label
@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, assign) BOOL isShowDeleteButton;

@end
