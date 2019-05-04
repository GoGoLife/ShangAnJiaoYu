//
//  CommentHeaderView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/25.
//  Copyright © 2018 钟文斌. All rights reserved.
//


//header高度 == 文本高度 + 60

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentHeaderView : UIView

@property (nonatomic, strong) UIImageView *header_imageview;

@property (nonatomic, strong) UILabel *name_label;

@property (nonatomic, strong) UILabel *tag_label;

@property (nonatomic, strong) UILabel *date_label;

@property (nonatomic, strong) UILabel *content_label;

@end

NS_ASSUME_NONNULL_END
