//
//  SystemAnswerTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SystemAnswerTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation SystemAnswerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    __weak typeof(self) weakSelf = self;
    self.back_view = [[UIView alloc] init];
    self.back_view.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(self.back_view, 8.0);
    [self.contentView addSubview:self.back_view];
    [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    
    self.top_label = [[UILabel alloc] init];
    self.top_label.font = SetFont(14);
    self.top_label.textColor = ButtonColor;
//    self.top_label.text = @"【引言段1】";
    [self.back_view addSubview:self.top_label];
    [self.top_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.back_view.mas_top).offset(10);
        make.left.equalTo(weakSelf.back_view.mas_left).offset(20);
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.textColor = SetColor(74, 74, 74, 1);
    self.content_label.numberOfLines = 0;
    [self.back_view addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.back_view.mas_left).offset(20);
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.back_view.mas_bottom).offset(-20);
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
