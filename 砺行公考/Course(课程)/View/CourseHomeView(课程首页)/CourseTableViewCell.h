//
//  CourseTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Course_Cell_height 80

@interface CourseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *left_view;

@property (nonatomic, strong) UILabel *title_label;

@property (nonatomic, strong) UILabel *detail_label;

@property (nonatomic, strong) UILabel *tag_label;

@property (nonatomic, strong) UIButton *touchButton;

@end
