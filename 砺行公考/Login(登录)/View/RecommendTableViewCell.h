//
//  RecommendTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/2.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RECOMMEND_CELL_HEIGHT 300

@interface RecommendTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIButton *addButton;

@end
