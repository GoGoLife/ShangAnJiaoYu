//
//  SolveFunctionTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SolveFunctionTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation SolveFunctionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = SetColor(238, 238, 238, 1);
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    UIView *back_view = [[UIView alloc] init];
    ViewRadius(back_view, 8.0);
    back_view.backgroundColor = WhiteColor;
    [self.contentView addSubview:back_view];
    __weak typeof(self) weakSelf = self;
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = SetFont(20);
    self.titleLabel.text = @"信息对应点法";
    [back_view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    self.rightImageV = [[UIImageView alloc] init];
//    self.rightImageV.backgroundColor = RandomColor;
    self.rightImageV.image = [UIImage imageNamed:@"right"];
    [back_view addSubview:self.rightImageV];
    [self.rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.centerY.mas_equalTo(weakSelf.titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 20));
    }];
    
    self.degreeLabel = [[UILabel alloc] init];
    self.degreeLabel.font = SetFont(10);
    self.degreeLabel.textColor = DetailTextColor;
//    self.degreeLabel.text = @"掌握程度参考: 70%";
    [back_view addSubview:self.degreeLabel];
    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.titleLabel.mas_left);
    }];
    
    self.slider = [[UISlider alloc] init];
    self.slider.backgroundColor = SetColor(246, 246, 246, 1);
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 100;
    [self.slider setValue:70 animated:YES];
    self.slider.thumbTintColor = [UIColor clearColor];
    [back_view addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.degreeLabel.mas_bottom).offset(10);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.height.mas_equalTo(6);
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
