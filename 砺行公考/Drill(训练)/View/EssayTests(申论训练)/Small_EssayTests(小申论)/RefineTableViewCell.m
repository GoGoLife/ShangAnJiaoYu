//
//  RefineTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "RefineTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation RefineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatViewUI];
    }
    return self;
}

- (void)creatViewUI {
    __weak typeof(self) weakSelf = self;
    self.top_text_label = [[UILabel alloc] init];
    self.top_text_label.font = SetFont(14);
    self.top_text_label.numberOfLines = 0;
    self.top_text_label.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(self.top_text_label, 8.0);
    [self.contentView addSubview:self.top_text_label];
    [self.top_text_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
    }];
    
    self.bottom_text_view = [[UITextView alloc] init];
    self.bottom_text_view.backgroundColor = SetColor(246, 246, 246, 1);
    self.bottom_text_view.font = SetFont(14);
    self.bottom_text_view.textColor = DetailTextColor;
    ViewRadius(self.bottom_text_view, 8.0);
    [self.contentView addSubview:self.bottom_text_view];
    [self.bottom_text_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top_text_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.top_text_label.mas_left).offset(30);
        make.right.equalTo(weakSelf.top_text_label.mas_right);
        make.height.mas_equalTo(50);
    }];
}

StringHeight()
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = [self calculateRowHeight:self.top_text_label.text fontSize:14 withWidth:SCREENBOUNDS.width - 40] + 20;
    [self.top_text_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
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
