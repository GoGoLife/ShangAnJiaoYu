//
//  SolveFunctionTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SolveFunctionTableViewCell : UITableViewCell

//标题
@property (nonatomic, strong) UILabel *titleLabel;

//向右箭头
@property (nonatomic, strong) UIImageView *rightImageV;

//掌握程度参考
@property (nonatomic, strong) UILabel *degreeLabel;

//掌握程度图示
@property (nonatomic, strong) UISlider *slider;

@end
