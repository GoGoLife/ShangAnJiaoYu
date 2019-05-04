//
//  DigestTagTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "DigestTagTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation DigestTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    __weak typeof(self) weakSelf = self;
    self.tag_label = [[UILabel alloc] init];
    self.tag_label.font = SetFont(14);
    [self.contentView addSubview:self.tag_label];
    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 20, 0, 100));
    }];
    
    self.right_imageview = [[UIImageView alloc] init];
    self.right_imageview.image = [UIImage imageNamed:@"select_no"];
    ViewRadius(self.right_imageview, 10.0);
    [self.contentView addSubview:self.right_imageview];
    [self.right_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
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
        self.right_imageview.image = [UIImage imageNamed:@"select_yes"];
    }else {
        self.right_imageview.image = [UIImage imageNamed:@"select_no"];
    }
    // Configure the view for the selected state
}

@end
