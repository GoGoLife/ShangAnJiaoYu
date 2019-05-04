//
//  BookContentTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookContentTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *title_label;

@property (nonatomic, strong) UILabel *content_lable;

@property (nonatomic, strong) UILabel *date_label;

//星级评价
@property (nonatomic, strong) StarsView *starLevel_view;

@property (nonatomic, strong) UIImageView *select_image;

//是否隐藏title
@property (nonatomic, assign) BOOL isHiddenTitle;

//是否隐藏星级评价
@property (nonatomic, assign) BOOL isHiddenStarlevel;

//是否可以选择  用于判断是否显示选择imageview
@property (nonatomic, assign) BOOL isCanSelect;

@end

NS_ASSUME_NONNULL_END
