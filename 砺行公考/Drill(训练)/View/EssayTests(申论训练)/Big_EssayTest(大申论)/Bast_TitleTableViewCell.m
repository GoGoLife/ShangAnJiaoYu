//
//  Bast_TitleTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/21.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Bast_TitleTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation Bast_TitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.font = SetFont(16);
    self.topLabel.textColor = ButtonColor;
    [self.contentView addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
    }];
    
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(16);
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.topLabel.mas_left);
    }];
    
    self.details_label = [[UILabel alloc] init];
    self.details_label.font = SetFont(14);
    self.details_label.numberOfLines = 0;
    [self.contentView addSubview:self.details_label];
    [self.details_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.title_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.title_label.mas_left);
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
