//
//  CommentTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(back_view, 8.0);
    [self.contentView addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(5, 70, 5, 20));
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 20 - 40 - 10 - 20 - 20;
    self.content_label.numberOfLines = 0;
    self.content_label.textColor = DetailTextColor;
    [back_view addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(10, 10, 10, 10));
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
