//
//  CorrectHistoryTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CorrectHistoryTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface CorrectHistoryTableViewCell ()

@end

@implementation CorrectHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViewUI];
    }
    return self;
}

StringWidth()
- (void)layoutSubviews{
    CGFloat width = [self calculateRowWidth:self.typeLabel.text withFont:12];
    [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width + 20);
    }];
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    CGFloat width = SCREENBOUNDS.width / 3;
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-width);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(1);
    }];
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.font = SetFont(12);
    self.typeLabel.textColor = WhiteColor;
    self.typeLabel.backgroundColor = ButtonColor;
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    ViewRadius(self.typeLabel, 10.0);
    self.typeLabel.text = @"大申论";
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    self.test_title = [[UILabel alloc] init];
    self.test_title.font = SetFont(12);
    self.test_title.textColor = DetailTextColor;
    self.test_title.text = @"2017年浙江省 副省级 考卷";
    [self.contentView addSubview:self.test_title];
    [self.test_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.typeLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.typeLabel.mas_centerY);
    }];
    
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(18);
    self.title_label.numberOfLines = 0;
    self.title_label.text = @"大标题哈哈哈";
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.typeLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.typeLabel.mas_left);
        make.right.equalTo(line.mas_left).offset(-10);
    }];
    
    self.date_label = [[UILabel alloc] init];
    self.date_label.font = SetFont(12);
    self.date_label.textColor = DetailTextColor;
    self.date_label.text = @"2018-1-23";
    [self.contentView addSubview:self.date_label];
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.left.equalTo(weakSelf.typeLabel.mas_left);
    }];
    
    self.user_name = [[UILabel alloc] init];
    self.user_name.font = SetFont(14);
    self.user_name.textColor = DetailTextColor;
    self.user_name.text = @"作者：穿着小红枣的眸";
    [self.contentView addSubview:self.user_name];
    [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.date_label.mas_top).offset(-10);
        make.left.equalTo(weakSelf.date_label.mas_left);
    }];
    
//    UILabel *scoreLabel = [[UILabel alloc] init];
//    scoreLabel.font = SetFont(12);
//    scoreLabel.textColor = DetailTextColor;
//    scoreLabel.numberOfLines = 0;
//    scoreLabel.text = @"预计考试得分（满分60分）";
//    [self.contentView addSubview:scoreLabel];
//    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(typeLabel.mas_top);
//        make.left.equalTo(line.mas_right).offset(10);
//        make.right.equalTo(weakSelf.contentView.mas_right).offset(-50);
//    }];
    
    self.score = [[UILabel alloc] init];
    self.score.font = SetFont(20);
    self.score.textColor = SetColor(48, 132, 252, 1);
    self.score.text = @"54";
    [self.contentView addSubview:self.score];
    [self.score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.typeLabel.mas_top);
        make.left.equalTo(line.mas_right).offset(20);
    }];
    
    self.image_view = [[UIImageView alloc] init];
//    self.imageview.backgroundColor = RandomColor;
    [self.contentView addSubview:self.image_view];
    [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.score.mas_bottom).offset(10);
        make.left.equalTo(line.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(width - 60, width - 30));
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
