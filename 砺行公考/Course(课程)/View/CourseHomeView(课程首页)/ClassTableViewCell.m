//
//  ClassTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ClassTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation ClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    __weak typeof(self) weakSelf = self;
    self.back_view = [[UIView alloc] init];
    [self.contentView addSubview:self.back_view];
    [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(5, 20, 5, 20));
    }];
    
    self.top_label = [[UILabel alloc] init];
    self.top_label.font = SetFont(22);
    self.top_label.textColor = WhiteColor;
    self.top_label.text = @"一线多途综合班";
    [self.back_view addSubview:self.top_label];
    [self.top_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.back_view.mas_top).offset(30.0);
        make.centerX.equalTo(weakSelf.back_view.mas_centerX);
    }];
    
    self.bottom_label = [[UILabel alloc] init];
    self.bottom_label.font = SetFont(14);
    self.bottom_label.textColor = WhiteColor;
    self.bottom_label.text = @"相当的不错哈哈哈";
    [self.back_view addSubview:self.bottom_label];
    [self.bottom_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top_label.mas_bottom).offset(10.0);
        make.centerX.equalTo(weakSelf.back_view.mas_centerX);
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
