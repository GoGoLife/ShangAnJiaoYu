//
//  OptionalSettingTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OptionalSettingTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation OptionalSettingTableViewCell

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
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.addButton.backgroundColor = RandomColor;
    [self.addButton setImage:[UIImage imageNamed:@"option-4"] forState:UIControlStateNormal];
    ViewRadius(self.addButton, 12.0);
    [self.addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = SetFont(18);
    self.numberLabel.textColor = DetailTextColor;
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    ViewBorderRadius(self.numberLabel, 5.0, 1.0, DetailTextColor);
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.addButton.mas_left).offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 34));
    }];
    
    self.lessButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.lessButton.backgroundColor = RandomColor;
    [self.lessButton setImage:[UIImage imageNamed:@"option-3"] forState:UIControlStateNormal];
    ViewRadius(self.lessButton, 12.0);
    [self.lessButton addTarget:self action:@selector(lessButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.lessButton];
    [self.lessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.numberLabel.mas_left).offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.equalTo(weakSelf.addButton);
    }];
}

//是否显示  操作按钮    NO === 不显示    YES === 显示
- (void)setIsShowOperateButton:(BOOL)isShowOperateButton {
    _isShowOperateButton = isShowOperateButton;
    if (_isShowOperateButton) {
//        self.leftImage.backgroundColor = [UIColor blueColor];
        self.leftImage.image = [UIImage imageNamed:@"option-2"];
        self.lessButton.hidden = NO;
        self.numberLabel.hidden = NO;
        self.addButton.hidden = NO;
    }else {
//        self.leftImage.backgroundColor = [UIColor whiteColor];
        self.leftImage.image = [UIImage imageNamed:@"option-1"];
        self.lessButton.hidden = YES;
        self.numberLabel.hidden = YES;
        self.addButton.hidden = YES;
    }
}

//左侧视图点击事件 action
- (void)leftImageAction {
    self.touchLeftImageBlock(self.indexPath);
}

//加 action
- (void)addButtonAction {
//    self.touchAddButtonBlock(self.indexPath);
    if ([_delegate respondsToSelector:@selector(touchAddbuttonAction:)]) {
        [_delegate touchAddbuttonAction:self.indexPath];
    }
}

//减 action
- (void)lessButtonAction {
//    self.touchLessButtonBlock(self.indexPath);
    if ([_delegate respondsToSelector:@selector(touchLessbuttonAction:)]) {
        [_delegate touchLessbuttonAction:self.indexPath];
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
