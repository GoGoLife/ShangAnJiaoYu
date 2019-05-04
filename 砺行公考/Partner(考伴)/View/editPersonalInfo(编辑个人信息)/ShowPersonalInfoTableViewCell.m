//
//  ShowPersonalInfoTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShowPersonalInfoTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation ShowPersonalInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    __weak typeof(self) weakSelf = self;
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(16);
    self.name_label.text = @"昵称";
    [self.contentView addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(16);
    self.content_label.textColor = DetailTextColor;
    self.content_label.text = @"家里附近爱丽丝";
    [self.contentView addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
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




#pragma mark ---- header cell
@implementation ShowPersonalHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initHeaderCellUI];
    }
    return self;
}

- (void)initHeaderCellUI {
    __weak typeof(self) weakSelf = self;
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(16);
    self.name_label.text = @"头像";
    [self.contentView addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    self.header_image = [[UIImageView alloc] init];
    self.header_image.backgroundColor = RandomColor;
    ViewRadius(self.header_image, 30.0);
    [self.contentView addSubview:self.header_image];
    [self.header_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
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



