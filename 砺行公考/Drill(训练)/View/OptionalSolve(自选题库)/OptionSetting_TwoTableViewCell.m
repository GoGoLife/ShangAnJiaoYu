//
//  OptionSetting_TwoTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OptionSetting_TwoTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation OptionSetting_TwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    self.leftImage = [[UIImageView alloc] init];
//    self.leftImage.backgroundColor = WhiteColor;
    self.leftImage.image = [UIImage imageNamed:@"option-1"];
    ViewBorderRadius(self.leftImage, 5.0, 1.0, SetColor(201, 201, 201, 1));
    self.leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftImageAction)];
    [self.leftImage addGestureRecognizer:tapGes];
    [self.contentView addSubview:self.leftImage];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = SetFont(16);
    self.titleLabel.text = @"单次总题目数";
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImage.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.chooseButton.backgroundColor = RandomColor;
    [self.chooseButton setImage:[UIImage imageNamed:@"option-5"] forState:UIControlStateNormal];
    [self.chooseButton addTarget:self action:@selector(touchChooseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.chooseButton];
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.FunctionLabel = [[UILabel alloc] init];
    self.FunctionLabel.font = SetFont(16);
    self.FunctionLabel.textColor = DetailTextColor;
    self.FunctionLabel.textAlignment = NSTextAlignmentCenter;
    self.FunctionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.FunctionLabel.text = @"信息对应点法";
    ViewBorderRadius(self.FunctionLabel, 5.0, 1.0, DetailTextColor);
    [self.contentView addSubview:self.FunctionLabel];
    [self.FunctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.chooseButton.mas_left).offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(180);
    }];
}

- (void)setIsShowLeftImage:(BOOL)isShowLeftImage {
    _isShowLeftImage = isShowLeftImage;
    if (_isShowLeftImage) {
        [self.leftImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
        }];
    }else {
        [self.leftImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

- (void)setIsShowFunctionButton:(BOOL)isShowFunctionButton {
    _isShowFunctionButton = isShowFunctionButton;
    if (_isShowFunctionButton) {
//        self.leftImage.backgroundColor = [UIColor blueColor];
        self.leftImage.image = [UIImage imageNamed:@"option-2"];
        self.FunctionLabel.hidden = NO;
        self.chooseButton.hidden = NO;
    }else {
//        self.leftImage.backgroundColor = WhiteColor;
        self.leftImage.image = [UIImage imageNamed:@"option-1"];
        self.FunctionLabel.hidden = YES;
        self.chooseButton.hidden = YES;
    }
}

//左侧视图点击事件
- (void)leftImageAction {
    self.touchLeftImageBlock(self.indexPath);
}

//出现下拉框
- (void)touchChooseAction {
    if ([_delegate respondsToSelector:@selector(touchChooseButtonAndShowList:)]) {
        [_delegate touchChooseButtonAndShowList:self.indexPath];
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
