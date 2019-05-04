//
//  ChatTableViewCell.h
//  weihouDemo
//
//  Created by 钟文斌 on 2019/2/14.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHallMsgModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(VHallChatModel *)model;

@property (nonatomic,strong) VHallChatModel* messageModel;

/**
 显示内容Label
 */
@property (nonatomic, strong) UILabel *content_label;

@end

NS_ASSUME_NONNULL_END
