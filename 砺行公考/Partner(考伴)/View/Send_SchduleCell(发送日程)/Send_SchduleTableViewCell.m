//
//  Send_SchduleTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/5.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "Send_SchduleTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation Send_SchduleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    CGFloat width = (SCREENBOUNDS.width - 40) / 3;
    self.left_label = [[UILabel alloc] init];
    self.left_label.font = SetFont(14);
    self.left_label.textAlignment = NSTextAlignmentCenter;
    ViewBorderRadius(self.left_label, 0.0, 1.0, SetColor(233, 233, 233, 1));
    [self.contentView addSubview:self.left_label];
    __weak typeof(self) weakSelf = self;
    [self.left_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.width.mas_equalTo(width);
    }];
    
    self.right_label = [[UILabel alloc] init];
    self.right_label.font = SetFont(14);
    self.right_label.textAlignment = NSTextAlignmentCenter;
    ViewBorderRadius(self.right_label, 0.0, 1.0, SetColor(233, 233, 233, 1));
    [self.contentView addSubview:self.right_label];
    [self.right_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.left_label.mas_top);
        make.left.equalTo(weakSelf.left_label.mas_right);
        make.bottom.equalTo(weakSelf.left_label.mas_bottom);
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
