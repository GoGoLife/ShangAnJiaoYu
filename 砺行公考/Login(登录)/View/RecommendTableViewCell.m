//
//  RecommendTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/2.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "RecommendTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation RecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.contentView.backgroundColor = [UIColor lightGrayColor];
//        ViewRadius(self.contentView, 5.0);
        [self setUI];
    }
    return self;
}

- (void)setUI {
    __weak typeof(self)  weakSelf = self;
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    ViewRadius(backgroundView, 5.0);
    [self.contentView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.font = SetFont(28);
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.text = @"言语理解20条必备守则";
    [backgroundView addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView.mas_top).offset(30);
        make.left.equalTo(backgroundView.mas_left).offset(20);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.font = SetFont(16);
    self.detailLabel.text = @"一句话介绍你还是打了福建省的甲方那边";
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.topLabel.mas_left);
    }];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.backgroundColor = [UIColor whiteColor];
    [self.addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.addButton.titleLabel.font = SetFont(14);
    [self.addButton setTitle:@"加入课程" forState:UIControlStateNormal];
    ViewRadius(self.addButton, 15.0);
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(-20);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-30);
        make.size.mas_equalTo(CGSizeMake(80, 30));
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
