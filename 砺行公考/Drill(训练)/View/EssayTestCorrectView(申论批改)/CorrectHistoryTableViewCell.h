//
//  CorrectHistoryTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CorrectHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *test_title;

@property (nonatomic, strong) UILabel *title_label;

@property (nonatomic, strong) UILabel *date_label;

@property (nonatomic, strong) UILabel *user_name;

@property (nonatomic, strong) UILabel *score;

@property (nonatomic, strong) UIImageView *image_view;

@end

NS_ASSUME_NONNULL_END
