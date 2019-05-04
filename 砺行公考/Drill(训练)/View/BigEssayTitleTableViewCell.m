//
//  BigEssayTitleTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigEssayTitleTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation BigEssayTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    __weak typeof(self) weakSelf = self;
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(14);
    self.title_label.text = @"标题";
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    self.image_view = [[UIImageView alloc] init];
    self.image_view.image = [UIImage imageNamed:@"select_no"];
    ViewRadius(self.image_view, 10.0);
    [self.contentView addSubview:self.image_view];
    [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
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
    // Configure the view for the selected state
    if (selected) {
        self.image_view.image = [UIImage imageNamed:@"select_yes"];
    }else {
        self.image_view.image = [UIImage imageNamed:@"select_no"];
    }
}

@end
