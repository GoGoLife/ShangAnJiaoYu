//
//  CustomChatMessageCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/20.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "EaseBaseMessageCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface CustomChatMessageCell : EaseBaseMessageCell

@property (nonatomic, strong) UILabel *type_label;

@property (nonatomic, strong) UILabel *text_label;

@end

NS_ASSUME_NONNULL_END
