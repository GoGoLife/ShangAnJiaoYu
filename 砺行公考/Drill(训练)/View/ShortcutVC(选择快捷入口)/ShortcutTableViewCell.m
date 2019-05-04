//
//  ShortcutTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/28.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShortcutTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation ShortcutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    self.left_imageview = [[UIImageView alloc] init];
    [self.contentView addSubview:self.left_imageview];
    __weak typeof(self) weakSelf = self;
    [self.left_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(50);
    }];
    
    self.right_imageview = [[UIImageView alloc] init];
    self.right_imageview.image = [UIImage imageNamed:@"add_button"];
    [self.contentView addSubview:self.right_imageview];
    [self.right_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(18);
    [self.contentView addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.left_imageview.mas_right).offset(10);
        make.right.equalTo(weakSelf.right_imageview.mas_left).offset(-10);
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
