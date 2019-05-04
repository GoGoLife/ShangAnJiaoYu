//
//  OptionTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//
//
//                  选项CELL

#import <UIKit/UIKit.h>

//题目解析    答案Cell  高度
#define OPTION_CELL_HEIGHT 50

@interface OptionTableViewCell : UITableViewCell

//A   B    C    D
@property (nonatomic, strong) UILabel *leftLabel;

//答案
@property (nonatomic, strong) UILabel *contentLabel;

//提醒标签
@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) NSString *tagString;

@end
