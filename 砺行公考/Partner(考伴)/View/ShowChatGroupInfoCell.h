//
//  ShowChatGroupInfoCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowChatGroupInfoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *image_view;

@property (nonatomic, strong) UILabel *name_label;

@property (nonatomic, strong) UILabel *type_label;

@property (nonatomic, strong) UIButton *delete_button;

@end

NS_ASSUME_NONNULL_END
