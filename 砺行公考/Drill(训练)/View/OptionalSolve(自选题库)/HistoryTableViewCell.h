//
//  HistoryTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HISTORY_CELL_HEIGHT 60

@interface HistoryTableViewCell : UITableViewCell

//训练的题数
@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@end
