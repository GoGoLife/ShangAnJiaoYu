//
//  PartnerCircleCommantTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PartnerCircleCommantTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation PartnerCircleCommantTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    self.header_image = [[UIImageView alloc] init];
    self.header_image.backgroundColor = RandomColor;
    ViewRadius(self.header_image, 20.0);
    [self.contentView addSubview:self.header_image];
    __weak typeof(self) weakSelf = self;
    [self.header_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(14);
    self.name_label.textColor = SetColor(48, 132, 252, 1);
    self.name_label.text = @"Tony";
    [self.contentView addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_image.mas_top);
        make.left.equalTo(weakSelf.header_image.mas_right).offset(10);
    }];
    
    self.comment_content_label = [[UILabel alloc] init];
    self.comment_content_label.font = SetFont(14);
    self.comment_content_label.textColor = SetColor(191, 191, 191, 1);
    self.comment_content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40 - 30 - 10;
    self.comment_content_label.numberOfLines = 0;
    self.comment_content_label.text = @"评论内容评论内容评论内容评论内容评论内容";
    [self.contentView addSubview:self.comment_content_label];
    [self.comment_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.name_label.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.name_label.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
