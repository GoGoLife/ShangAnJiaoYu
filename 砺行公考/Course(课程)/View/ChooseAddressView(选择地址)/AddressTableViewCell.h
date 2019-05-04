//
//  AddressTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ADDRESS_CELL_HEIGHT 80

@interface AddressTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *name_label;

@property (nonatomic, strong) UILabel *address_label;

//是否是默认地址
@property (nonatomic, strong) UILabel *default_label;

@end

NS_ASSUME_NONNULL_END
