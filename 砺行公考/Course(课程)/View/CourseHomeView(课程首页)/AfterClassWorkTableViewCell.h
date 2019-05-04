//
//  AfterClassWorkTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AfterClassWorkTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *title_label;

@property (nonatomic, strong) UILabel *tag_label;

@property (nonatomic, strong) UIImageView *select_image;

@property (nonatomic, assign) BOOL isShowAddButton;

@end
