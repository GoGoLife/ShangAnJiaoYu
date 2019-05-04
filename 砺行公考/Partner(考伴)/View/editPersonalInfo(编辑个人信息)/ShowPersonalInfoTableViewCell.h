//
//  ShowPersonalInfoTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

//头像cell高度
#define HEADER_CELL_HEIGHT 80

//信息cell高度
#define INFO_CELL_HEIGHT 50

NS_ASSUME_NONNULL_BEGIN

@interface ShowPersonalInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *name_label;

@property (nonatomic, strong) UILabel *content_label;

@end


@interface ShowPersonalHeaderTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *image_url;

@property (nonatomic, strong) UILabel *name_label;

@property (nonatomic, strong) UIImageView *header_image;

@end

NS_ASSUME_NONNULL_END
