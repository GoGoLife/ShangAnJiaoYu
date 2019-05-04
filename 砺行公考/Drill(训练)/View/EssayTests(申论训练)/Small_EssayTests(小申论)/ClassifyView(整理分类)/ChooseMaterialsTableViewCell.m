//
//  ChooseMaterialsTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ChooseMaterialsTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation ChooseMaterialsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    self.right_image = [[UIImageView alloc] init];
    self.right_image.image = [UIImage imageNamed:@"select_no"];
    ViewRadius(self.right_image, 10.0);
    [self.contentView addSubview:self.right_image];
    [self.right_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
//    self.tag_label = [[UILabel alloc] init];
//    self.tag_label.font = SetFont(12);
//    self.tag_label.textColor = RandomColor;
//    self.tag_label.textAlignment = NSTextAlignmentCenter;
//    ViewBorderRadius(self.tag_label, 10.0, 1.0, RandomColor);
//    self.tag_label.text = @"注解词";
//    [self.contentView addSubview:self.tag_label];
//    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
//        make.right.equalTo(weakSelf.right_image.mas_left).offset(-10);
//        make.width.mas_equalTo(90);
//        make.height.mas_equalTo(20);
//    }];
//    self.tag_label.hidden = YES;
    
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.numberOfLines = 0;
    [self.contentView addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
    }];
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        self.right_image.image = [UIImage imageNamed:@"select_yes"];
    }else {
        self.right_image.image = [UIImage imageNamed:@"select_no"];
    }
}

- (void)setIsHiddenRightImage:(BOOL)isHiddenRightImage {
    if (isHiddenRightImage) {
        self.right_image.hidden = YES;
        [self.right_image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }else {
        self.right_image.hidden = NO;
        [self.right_image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
        }];
    }
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
