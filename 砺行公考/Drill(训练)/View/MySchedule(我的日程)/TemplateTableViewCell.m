//
//  TemplateTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/26.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TemplateTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation TemplateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.left_label = [[UILabel alloc] init];
    self.left_label.textAlignment = NSTextAlignmentCenter;
    self.left_label.font = SetFont(14);
    ViewBorderRadius(self.left_label, 0.0, 1.0, SetColor(233, 233, 233, 1));
    [self.contentView addSubview:self.left_label];
    __weak typeof(self) weakSelf = self;
    CGFloat width = (SCREENBOUNDS.width - 40) / 3;
    [self.left_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.width.mas_equalTo(width);
    }];
    
    self.right_label = [[UILabel alloc] init];
    self.right_label.textAlignment = NSTextAlignmentCenter;
    self.right_label.font = SetFont(14);
    ViewBorderRadius(self.right_label, 0.0, 1.0, SetColor(233, 233, 233, 1));
    [self.contentView addSubview:self.right_label];
    [self.right_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.left.equalTo(weakSelf.left_label.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.width.mas_equalTo(width * 2);
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
