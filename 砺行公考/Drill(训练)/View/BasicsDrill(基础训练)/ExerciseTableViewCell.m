//
//  ExerciseTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ExerciseTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation ExerciseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.textColor = DetailTextColor;
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    ViewBorderRadius(self.leftLabel, 15.0, 1.0, DetailTextColor);
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
//    self.contentLabel.backgroundColor = [UIColor blueColor];
    self.contentLabel.textColor = SetColor(74, 74, 74, 1);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.font = SetFont(16);
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.leftLabel.mas_right).offset(20);
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
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
