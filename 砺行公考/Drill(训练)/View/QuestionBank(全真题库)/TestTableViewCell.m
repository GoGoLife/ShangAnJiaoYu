//
//  TestTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "TestTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation TestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setCellUI];
    }
    return self;
}

StringWidth();
- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    //展开以后宽度为30
    self.leftImageV = [[UIImageView alloc] init];
    self.leftImageV.image = [UIImage imageNamed:@"drill_10"];
    [self.contentView addSubview:self.leftImageV];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(0, 40));
    }];
    
    self.testNameLabel = [[UILabel alloc] init];
    self.testNameLabel.font = SetFont(16);
    self.testNameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.testNameLabel];
    [self.testNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-44);
    }];
    
    self.detailsLabel = [[UILabel alloc] init];
    self.detailsLabel.font = SetFont(12);
    self.detailsLabel.textColor = DetailTextColor;
    [self.contentView addSubview:self.detailsLabel];
    [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.testNameLabel.mas_left);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
    }];
    
    self.tagLabel = [[UILabel alloc] init];
    self.tagLabel.backgroundColor = SetColor(242, 68, 89, 1);
    self.tagLabel.font = SetFont(10);
    self.tagLabel.textColor = WhiteColor;
    self.tagLabel.textAlignment = NSTextAlignmentCenter;
    ViewRadius(self.tagLabel, 10.0);
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.testNameLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.testNameLabel.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    self.tagLabel.hidden = YES;
    
    self.rightImageV = [[UIImageView alloc] init];
    self.rightImageV.image = [UIImage imageNamed:@"select_no"];
    ViewRadius(self.rightImageV, 10.0);
    [self.contentView addSubview:self.rightImageV];
    [self.rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //如果标签内容为空   就不显示标签
    if ([self.tagLabel.text isEqualToString:@""]) {
        return;
    }
    CGFloat tag_width = [self calculateRowWidth:self.tagLabel.text withFont:10];
    [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(tag_width + 20);
    }];
}

- (void)setIsShowLeftImage:(BOOL)isShowLeftImage {
    _isShowLeftImage = isShowLeftImage;
    if (_isShowLeftImage) {
        [self.leftImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
        }];
    }
}

- (void)setIsShowChoose:(BOOL)isShowChoose {
    _isShowChoose = isShowChoose;
    self.rightImageV.hidden = !_isShowChoose;
}

- (void)setIsSelected:(BOOL)isSelected {
//    NSLog(@"isChoose === %d", self.isShowChoose);
    if (self.isShowChoose) {
        if (isSelected) {
            self.rightImageV.image = [UIImage imageNamed:@"select_yes"];
        }else {
            self.rightImageV.image = [UIImage imageNamed:@"select_no"];
        }
    }else {
//        self.rightImageV.hidden = YES;
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
