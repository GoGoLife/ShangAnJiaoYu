//
//  Course_TwoTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Course_TwoTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation Course_TwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)layoutSubviews {
    [self setTagContent];
}

- (void)creatCellUI {
    __weak typeof(self) weakSelf = self;
    self.left_view = [[UIImageView alloc] init];
    self.left_view.image = [UIImage imageNamed:@"no_image"];
    ViewRadius(self.left_view, 8.0);
    [self.contentView addSubview:self.left_view];
    [self.left_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = SetFont(14);
    self.title_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 20 * 2 - 126 - 10;
    self.title_label.numberOfLines = 2;
    //后面部分以。。。形式显示
    self.title_label.lineBreakMode = NSLineBreakByTruncatingTail;
    self.title_label.text = @"长效班会员：砺行教育内全app所有权限全部享受，最划算最划算最划算最划算";
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.left_view.mas_top).offset(0);
        make.left.equalTo(weakSelf.left_view.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
    }];
    
//    self.tag_label = [[UILabel alloc] init];
//    self.tag_label.font = SetFont(10);
//    self.tag_label.textColor = SetColor(255, 85, 0, 1);
//    ViewBorderRadius(self.tag_label, 2.0, 1.0, SetColor(255, 85, 0, 1));
//    self.tag_label.text = @"超级VIP班级";
//    [self.contentView addSubview:self.tag_label];
//    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.title_label.mas_bottom).offset(10);
//        make.left.equalTo(weakSelf.title_label.mas_left);
//    }];
    [self setTagContent];
    
    self.price_label = [[UILabel alloc] init];
    self.price_label.font = SetFont(16);
    self.price_label.textColor = SetColor(242, 68, 89, 1);
    self.price_label.text = @"￥135";
    [self.contentView addSubview:self.price_label];
    [self.price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.title_label.mas_bottom).offset(35);
        make.left.equalTo(weakSelf.title_label.mas_left);
    }];
    
    self.number_label = [[UILabel alloc] init];
    self.number_label.font = SetFont(10);
    self.number_label.textColor = DetailTextColor;
    self.number_label.text = @"1234人付款";
    [self.contentView addSubview:self.number_label];
    [self.number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.price_label.mas_bottom);
        make.left.equalTo(weakSelf.price_label.mas_right).offset(10);
    }];
    
    self.good_label = [[UILabel alloc] init];
    self.good_label.font = SetFont(10);
    self.good_label.textColor = DetailTextColor;
    self.good_label.text = @"100%好评率";
    [self.contentView addSubview:self.good_label];
    [self.good_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.price_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.price_label.mas_left);
    }];
    
    self.remark_label = [[UILabel alloc] init];
    self.remark_label.font = SetFont(10);
    self.remark_label.text = @"3天试听权益>";
    [self.contentView addSubview:self.remark_label];
    [self.remark_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.good_label.mas_top);
        make.left.equalTo(weakSelf.good_label.mas_right).offset(10);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
}

StringWidth()
- (void)setTagContent {
    __weak typeof(self) weakSelf = self;
    CGFloat offset_width = 0.0;
    for (NSInteger index = 0; index < self.tag_array.count; index++) {
        self.tag_label = [[UILabel alloc] init];
        self.tag_label.textAlignment = NSTextAlignmentCenter;
        self.tag_label.font = SetFont(10);
        self.tag_label.textColor = SetColor(255, 85, 0, 1);
        ViewBorderRadius(self.tag_label, 2.0, 1.0, SetColor(255, 85, 0, 1));
        self.tag_label.text = self.tag_array[index];
        [self.contentView addSubview:self.tag_label];
        CGFloat width = [self calculateRowWidth:self.tag_array[index] withFont:10];
        [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.title_label.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.title_label.mas_left).offset(offset_width);
            make.width.mas_equalTo(width + 5);
        }];
        offset_width = offset_width + [self calculateRowWidth:self.tag_array[index] withFont:10] + 5 + 10;
    }
}
//- (void)setTag_array:(NSArray *)tag_array {
//    _tag_array = tag_array;
//    __weak typeof(self) weakSelf = self;
//    CGFloat offset_width = 0.0;
//    for (NSInteger index = 0; index < _tag_array.count; index++) {
//        self.tag_label = [[UILabel alloc] init];
//        self.tag_label.textAlignment = NSTextAlignmentCenter;
//        self.tag_label.font = SetFont(10);
//        self.tag_label.textColor = SetColor(255, 85, 0, 1);
//        ViewBorderRadius(self.tag_label, 2.0, 1.0, SetColor(255, 85, 0, 1));
//        self.tag_label.text = _tag_array[index];
//        [self.contentView addSubview:self.tag_label];
//        CGFloat width = [self calculateRowWidth:_tag_array[index] withFont:10];
//        [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.title_label.mas_bottom).offset(10);
//            make.left.equalTo(weakSelf.title_label.mas_left).offset(offset_width);
//            make.width.mas_equalTo(width + 5);
//        }];
//        offset_width = offset_width + [self calculateRowWidth:_tag_array[index] withFont:10] + 5 + 10;
//    }
//}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
