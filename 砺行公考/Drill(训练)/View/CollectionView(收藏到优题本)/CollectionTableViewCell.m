//
//  CollectionTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation CollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    self.leftImageV = [[UIImageView alloc] init];
    ViewRadius(self.leftImageV, 5.0);
    self.leftImageV.backgroundColor = RandomColor;
    [self.contentView addSubview:self.leftImageV];
    __weak typeof(self) weakSelf = self;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.font = SetFont(16);
    self.topLabel.text = @"申论好词好句";
    [self.contentView addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(25);
    }];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.font = SetFont(12);
    self.bottomLabel.textColor = DetailTextColor;
    self.bottomLabel.text = @"已收录213条";
    [self.contentView addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.left.equalTo(weakSelf.topLabel.mas_left);
        make.right.equalTo(weakSelf.topLabel.mas_right);
        make.height.equalTo(weakSelf.topLabel.mas_height);
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
