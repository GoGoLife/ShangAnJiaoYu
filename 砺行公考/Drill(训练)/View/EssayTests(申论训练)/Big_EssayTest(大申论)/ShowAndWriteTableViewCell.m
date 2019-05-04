//
//  ShowAndWriteTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShowAndWriteTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation ShowAndWriteTableViewCell

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
    
    self.textview = [[UITextView alloc] init];
    self.textview.font = SetFont(14);
    self.textview.backgroundColor = SetColor(246, 246, 246, 1);
    [self.back_view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.back_view).insets(UIEdgeInsetsMake(10, 10, 10, 10));
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
