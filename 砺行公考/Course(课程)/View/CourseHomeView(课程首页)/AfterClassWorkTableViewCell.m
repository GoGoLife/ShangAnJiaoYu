//
//  AfterClassWorkTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AfterClassWorkTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation AfterClassWorkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = SetColor(246, 246, 246, 1);
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = WhiteColor;
    [self.contentView addSubview:back_view];
    __weak typeof(self) weakSelf = self;
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(5, 20, 5, 20));
    }];
    
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(14);
    self.title_label.text = @"长效班-数量关系-牛吃草问题精讲";
    [back_view addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back_view.mas_left).offset(10);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
    
    self.tag_label = [[UILabel alloc] init];
    self.tag_label.font = SetFont(10);
    self.tag_label.textColor = SetColor(230, 37, 43, 1);
    self.tag_label.text = @"推荐优先";
    [back_view addSubview:self.tag_label];
    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.title_label.mas_right).offset(10);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
    
    self.select_image = [[UIImageView alloc] init];
    self.select_image.hidden = YES;
    self.select_image.image = [UIImage imageNamed:@"select_no"];
    ViewRadius(self.select_image, 7.0);
    [back_view addSubview:self.select_image];
    [self.select_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-10);
        make.centerY.equalTo(back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 14));
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
