//
//  RefiningTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefiningModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefiningTableViewCell : UITableViewCell

+ (instancetype)creatRefiningCell:(UITableView *)tableview withModel:(RefiningSonModel *)model;

@end

NS_ASSUME_NONNULL_END
