//
//  OrderPreferentialTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/26.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "OrderPreferentialTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation OrderPreferentialTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = WhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.left_label = [[UILabel alloc] init];
    self.left_label.font = SetFont(14);
    self.left_label.text = @"优惠券";
    [self.contentView addSubview:self.left_label];
    __weak typeof(self) weakSelf = self;
    [self.left_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    self.right_content_label = [[UILabel alloc] init];
    self.right_content_label.font = SetFont(14);
    self.right_content_label.textColor = SetColor(242, 68, 89, 1);
    self.right_content_label.text = @"- ￥200.00";
    [self.contentView addSubview:self.right_content_label];
    [self.right_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
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
