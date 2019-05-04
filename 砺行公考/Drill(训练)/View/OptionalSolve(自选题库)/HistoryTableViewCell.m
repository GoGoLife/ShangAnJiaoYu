//
//  HistoryTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation HistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.backgroundColor = SetColor(246, 246, 246, 1);
    self.leftLabel.font = SetFont(14);
    self.leftLabel.textColor = SetColor(48, 132, 252, 1);
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    ViewRadius(self.leftLabel, 5.0);
    self.leftLabel.text = @"15题";
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.font = SetFont(16);
    self.topLabel.text = @"今天10：06";
    [self.contentView addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.leftLabel.mas_right).offset(10);
    }];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.font = SetFont(12);
    self.bottomLabel.textColor = DetailTextColor;
    self.bottomLabel.text = @"言5 · 数3 · 判7 · 常10 · 资20";
    [self.contentView addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.leftLabel.mas_right).offset(10);
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
