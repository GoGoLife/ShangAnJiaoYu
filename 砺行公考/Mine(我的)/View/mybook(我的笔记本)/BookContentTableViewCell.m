//
//  BookContentTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BookContentTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface BookContentTableViewCell ()

@property (nonatomic, strong) UIView *back_view;

@end

@implementation BookContentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = SetColor(246, 246, 246, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.back_view = [[UIView alloc] init];
    self.back_view.backgroundColor = WhiteColor;
    [self.contentView addSubview:self.back_view];
    __weak typeof(self) weakSelf = self;
    [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(12);
    self.title_label.textColor = DetailTextColor;
    self.title_label.text = @"2017年浙江省地市级卷·27题";
    [self.back_view addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.back_view.mas_top).offset(5);
        make.left.equalTo(weakSelf.back_view.mas_left).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    self.content_lable = [[UILabel alloc] init];
    self.content_lable.font = SetFont(14);
    self.content_lable.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.content_lable.numberOfLines = 3;
    self.content_lable.lineBreakMode = NSLineBreakByTruncatingTail;
    self.content_lable.text = @"吸睛拍，看见啊手机壳吧，就开始不出，就把上半场明年本命，年把你们先吃吧美女主播没能变成美，女帮忙在巴西每年出版怎出版怎出版怎出版怎出版怎";
    [self.back_view addSubview:self.content_lable];
    [self.content_lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.title_label.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.back_view.mas_left).offset(15);
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-15);
    }];
    
    self.date_label = [[UILabel alloc] init];
    self.date_label.font = SetFont(12);
    self.date_label.textColor = DetailTextColor;
    self.date_label.text = @"2018-12-5";
    [self.back_view addSubview:self.date_label];
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.content_lable.mas_bottom).offset(10);
        make.bottom.equalTo(weakSelf.back_view.mas_bottom).offset(-10);
        make.left.equalTo(weakSelf.content_lable.mas_left);
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-85);
    }];
    
    self.starLevel_view = [[StarsView alloc] initWithStarSize:CGSizeMake(15, 15) space:10 numberOfStar:3];
    self.starLevel_view.hidden = YES;
    self.starLevel_view.selectable = NO;
    self.starLevel_view.score = 2.0;
    [self.back_view addSubview:self.starLevel_view];
    [self.starLevel_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-15);
        make.bottom.equalTo(weakSelf.back_view.mas_bottom).offset(-10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
    }];
    
    self.select_image = [[UIImageView alloc] init];
    self.select_image.image = [UIImage imageNamed:@"select_no"];
    self.select_image.hidden = YES;
    ViewRadius(self.select_image, 10.0);
    [self.back_view addSubview:self.select_image];
    [self.select_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setIsCanSelect:(BOOL)isCanSelect {
    _isCanSelect = isCanSelect;
    __weak typeof(self) weakSelf = self;
    if (_isCanSelect) {
        self.select_image.hidden = NO;
        self.content_lable.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40 - 30;
        [self.content_lable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.back_view.mas_right).offset(-45);
        }];
    }else {
        self.select_image.hidden = YES;
        self.content_lable.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
        [self.content_lable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.back_view.mas_right).offset(-15);
        }];
    }
}

- (void)setIsHiddenTitle:(BOOL)isHiddenTitle {
    _isHiddenTitle = isHiddenTitle;
    if (_isHiddenTitle) {
        [self.title_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else {
        [self.title_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
    }
}

- (void)setIsHiddenStarlevel:(BOOL)isHiddenStarlevel {
    _isHiddenStarlevel = isHiddenStarlevel;
    if (_isHiddenStarlevel) {
        self.starLevel_view.hidden = YES;
    }else {
        self.starLevel_view.hidden = NO;
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
