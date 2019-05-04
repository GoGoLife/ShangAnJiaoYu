//
//  AddressTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation AddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = WhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(14);
    self.name_label.text = @"陈璐  13736179920";
    [self.contentView addSubview:self.name_label];
    __weak typeof(self) weakSelf = self;
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
    }];
    
    self.default_label = [[UILabel alloc] init];
    self.default_label.textAlignment = NSTextAlignmentCenter;
    self.default_label.font = SetFont(10);
    self.default_label.textColor = SetColor(242, 68, 89, 1);
    ViewBorderRadius(self.default_label, 5.0, 1.0, SetColor(242, 68, 89, 1));
    self.default_label.text = @"默认";
    [self.contentView addSubview:self.default_label];
    [self.default_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.name_label.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.name_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28, 14));
    }];
    
    self.address_label = [[UILabel alloc] init];
    self.address_label.font = SetFont(10);
    self.address_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.address_label.numberOfLines = 0;
    self.address_label.text = @"浙江省宁波市鄞州区梅墟街道江南景苑北区一幢一单元704";
    [self.contentView addSubview:self.address_label];
    [self.address_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.name_label.mas_bottom).offset(10);
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
