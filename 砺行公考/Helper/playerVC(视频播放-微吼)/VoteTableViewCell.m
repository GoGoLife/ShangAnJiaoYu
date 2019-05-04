//
//  VoteTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/20.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "VoteTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation VoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.left_imageview = [[UIImageView alloc] init];
    self.left_imageview.backgroundColor = SetColor(246, 246, 246, 1);
    ViewBorderRadius(self.left_imageview, 5.0, 1.0, DetailTextColor);
    [self.contentView addSubview:self.left_imageview];
    __weak typeof(self) weakSelf = self;
    [self.left_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40 - 20;
    self.content_label.numberOfLines = 0;
    [self.contentView addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.left_imageview.mas_right).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
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
