//
//  MyCourseTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCourseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UILabel *left_label;

@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, strong) UILabel *tag_label;

@property (nonatomic, strong) UIImageView *select_image;

@property (nonatomic, assign) BOOL isShowAddButton;

@end
