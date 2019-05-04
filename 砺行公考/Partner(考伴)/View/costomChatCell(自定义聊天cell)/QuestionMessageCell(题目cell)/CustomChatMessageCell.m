//
//  CustomChatMessageCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/20.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CustomChatMessageCell.h"
#import <UIImageView+WebCache.h>

static const CGFloat kCellHeight = 116.0f;

@implementation CustomChatMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.hasRead.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UILabel *)type_label {
    if (!_type_label) {
        CGFloat magin = [UIScreen mainScreen].bounds.size.width / 3;
        _type_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, magin * 2 - 55 - 30, 20)];
        _type_label.font = [UIFont systemFontOfSize:16.0];
    }
    return _type_label;
}

- (UILabel *)text_label {
    if (!_text_label) {
        CGFloat magin = [UIScreen mainScreen].bounds.size.width / 3;
        _text_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, magin * 2 - 55 - 30, 60)];
        _text_label.lineBreakMode = NSLineBreakByTruncatingTail;
        _text_label.font = [UIFont systemFontOfSize:14.0];
        _text_label.textColor = [UIColor grayColor];
        _text_label.numberOfLines = 3;
    }
    return _text_label;
}

#pragma mark --- 方法重写
+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model {
    return [NSString stringWithFormat:@"%@+%@", @"CustomMessageIdentifier", model.messageId];;
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model {
    return kCellHeight;
}

//判断是否是自定义气泡
- (BOOL)isCustomBubbleView:(id)model {
    return YES;
}

- (void)setCustomModel:(id<IMessageModel>)model{
    UIImage *image = model.image;
    if (!image) {
        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
    } else {
        _bubbleView.imageView.image = image;
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
}

- (void)setCustomBubbleView:(id<IMessageModel>)model {
    [self.bubbleView.backgroundImageView addSubview:self.type_label];
    self.type_label.text = model.message.ext[@"type"];
    
    [self.bubbleView.backgroundImageView addSubview:self.text_label];
    self.text_label.text = model.message.ext[@"message"];
    _bubbleView.imageView.backgroundColor = [UIColor whiteColor];
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)mode {
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;

    CGFloat bubbleViewHeight = 100;// 气泡背景图高度
    CGFloat nameLabelHeight = 15;// 昵称label的高度

    if (mode.isSender) {
        _bubbleView.frame =
        CGRectMake([UIScreen mainScreen].bounds.size.width - 273.5, nameLabelHeight, 213, bubbleViewHeight);
    }else{
        _bubbleView.frame = CGRectMake(55, nameLabelHeight, 213, bubbleViewHeight);
    }
}

//- (void)setModel:(id<IMessageModel>)model {
//    [super setModel:model];
//    NSDictionary *dict = model.message.ext;
//    self.bubbleView.type_label.text = dict[@"type"];
//    self.bubbleView.text_label.text = dict[@"message"];
//    _hasRead.hidden = YES;//名片消息不显示已读
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
