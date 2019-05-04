//
//  FiveRoundsFirstTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "FiveRoundsFirstTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation FiveRoundsFirstTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    __weak typeof(self) weakSelf = self;
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(16);
    self.title_label.text = @"阅读指导课";
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
    }];
    
    self.details_label = [[UILabel alloc] init];
    self.details_label.font = SetFont(14);
    self.details_label.textColor = DetailTextColor;
    self.details_label.numberOfLines = 0;
    self.details_label.text = @"信息对应点法可广泛运用于言语理解与表达的各类题目当中，找到信息对应点可快速进行选";
    [self.contentView addSubview:self.details_label];
    [self.details_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.title_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
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
