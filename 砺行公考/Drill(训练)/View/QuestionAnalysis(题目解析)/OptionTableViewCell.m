//
//  OptionTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OptionTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation OptionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.font = SetFont(16);
    self.leftLabel.textColor = DetailTextColor;
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    ViewBorderRadius(self.leftLabel, 15.0, 1.0, DetailTextColor);
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = SetFont(14);
    self.contentLabel.textColor = DetailTextColor;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.leftLabel.mas_right).offset(20);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-120);
    }];
    
    self.tagLabel = [[UILabel alloc] init];
    self.tagLabel.backgroundColor = [UIColor redColor];
    self.tagLabel.textAlignment = NSTextAlignmentCenter;
    self.tagLabel.font = SetFont(12);
    self.tagLabel.textColor = WhiteColor;
    ViewRadius(self.tagLabel, 10.0);
    [self.contentView addSubview:self.tagLabel];
    CGFloat width = [self calculateRowWidth:self.tagLabel.text withFont:12];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(width);
    }];
}
StringWidth();

- (void)setTagString:(NSString *)tagString {
    _tagString = tagString;
    self.tagLabel.text = _tagString;
    CGFloat width = [self calculateRowWidth:_tagString withFont:12];
    __weak typeof(self) weakSelf = self;
    [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentLabel.mas_right).offset(10);
        make.width.mas_equalTo(width + 20);
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
