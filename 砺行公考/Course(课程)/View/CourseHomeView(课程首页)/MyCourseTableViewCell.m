//
//  MyCourseTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "MyCourseTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface MyCourseTableViewCell()

@end

@implementation MyCourseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = WhiteColor;
    [self.contentView addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    self.left_label = [[UILabel alloc] init];
    self.left_label.backgroundColor = RandomColor;
    ViewRadius(self.left_label, 5.0);
    [back_view addSubview:self.left_label];
    [self.left_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back_view.mas_left).offset(13);
        make.centerY.equalTo(back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(12);
    [back_view addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.left_label.mas_right).offset(10);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
    
    self.tag_label = [[UILabel alloc] init];
    self.tag_label.font = SetFont(8);
    self.tag_label.textColor = ButtonColor;
//    self.tag_label.text = @"推荐学习";
    [back_view addSubview:self.tag_label];
    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.content_label.mas_right).offset(10);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
    
    self.select_image = [[UIImageView alloc] init];
    self.select_image.hidden = YES;
    self.select_image.image = [UIImage imageNamed:@"select_no"];
    ViewRadius(self.select_image, 10.0);
    [self.contentView addSubview:self.select_image];
    [self.select_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-10);
        make.centerY.equalTo(back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setIsShowAddButton:(BOOL)isShowAddButton {
    _isShowAddButton = isShowAddButton;
    if (_isShowAddButton) {
        self.select_image.hidden = NO;
    }else {
        self.select_image.hidden = YES;
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
