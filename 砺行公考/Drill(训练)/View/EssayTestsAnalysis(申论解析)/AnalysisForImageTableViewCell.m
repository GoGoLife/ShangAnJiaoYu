//
//  AnalysisForImageTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "AnalysisForImageTableViewCell.h"
#import <Masonry.h>
#import "GlobarFile.h"

@implementation AnalysisForImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    self.image_view = [[UIImageView alloc] init];
//    self.image_view.backgroundColor = RandomColor;
    [self.contentView addSubview:self.image_view];
    __weak typeof(self) weakSelf = self;
    [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
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
