//
//  input_SumUpTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "input_SumUpTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation input_SumUpTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.input_field = [[UITextView alloc] init];
    ViewRadius(self.input_field, 8.0);
    self.input_field.backgroundColor = SetColor(246, 246, 246, 1);
    self.input_field.font = SetFont(14);
    self.input_field.textColor = DetailTextColor;
    self.input_field.text = @"在此输入总括句";
    [self.contentView addSubview:self.input_field];
    __weak typeof(self) weakSelf = self;
    [self.input_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 20, 10, 20));
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
