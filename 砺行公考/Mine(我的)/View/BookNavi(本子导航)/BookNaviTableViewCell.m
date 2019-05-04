//
//  BookNaviTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BookNaviTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation BookNaviTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.textColor = DetailTextColor;
    self.content_label.textAlignment = NSTextAlignmentCenter;
    self.content_label.numberOfLines = 0;
    [self.contentView addSubview:self.content_label];
    __weak typeof(self) weakSelf = self;
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.content_label.textColor = SetColor(48, 132, 252, 1);
    }else {
        self.content_label.textColor = DetailTextColor;
    }
    // Configure the view for the selected state
}

@end
