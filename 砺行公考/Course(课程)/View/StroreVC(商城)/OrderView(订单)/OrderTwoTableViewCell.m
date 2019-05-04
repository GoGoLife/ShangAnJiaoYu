//
//  OrderTwoTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OrderTwoTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation OrderTwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    __weak typeof(self) weakSelf = self;
    self.image_view = [[UIImageView alloc] init];
    self.image_view.backgroundColor = RandomColor;
    ViewRadius(self.image_view, 5.0);
    [self.contentView addSubview:self.image_view];
    [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.text = @"支付宝";
    [self.contentView addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.image_view.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    self.tag_label = [[UILabel alloc] init];
    self.tag_label.font = SetFont(10);
    self.tag_label.textColor = WhiteColor;
    self.tag_label.backgroundColor = SetColor(242, 68, 89, 1);
    self.tag_label.text = @"随机减最高1000元";
    [self.contentView addSubview:self.tag_label];
    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.content_label.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    self.select_image = [[UIImageView alloc] init];
    self.select_image.image = [UIImage imageNamed:@"select_no"];
    [self.contentView addSubview:self.select_image];
    [self.select_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.select_image.image = [UIImage imageNamed:@"select_yes"];
    }else {
        self.select_image.image = [UIImage imageNamed:@"select_no"];
    }
    // Configure the view for the selected state
}

@end
