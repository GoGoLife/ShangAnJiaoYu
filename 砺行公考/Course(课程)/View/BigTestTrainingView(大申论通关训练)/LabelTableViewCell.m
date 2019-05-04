//
//  LabelTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "LabelTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation LabelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.label = [[UILabel alloc] init];
    self.label.font = SetFont(14);
    self.label.textColor = DetailTextColor;
    [self.contentView addSubview:self.label];
    __weak typeof(self) weakSelf = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
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
