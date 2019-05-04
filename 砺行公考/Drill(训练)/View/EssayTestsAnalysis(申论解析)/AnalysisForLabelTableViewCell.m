//
//  AnalysisForLabelTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "AnalysisForLabelTableViewCell.h"
#import <Masonry.h>
#import "GlobarFile.h"

@implementation AnalysisForLabelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(16);
    self.content_label.textColor = SetColor(74, 74, 74, 1);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.content_label.numberOfLines = 0;
    self.content_label.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.content_label];
    __weak typeof(self) weakSelf = self;
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(10, 20, 10, 20));
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
