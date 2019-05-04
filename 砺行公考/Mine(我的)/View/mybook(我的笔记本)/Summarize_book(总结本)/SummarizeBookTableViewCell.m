//
//  SummarizeBookTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SummarizeBookTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface SummarizeBookTableViewCell ()

@property (nonatomic, strong) UIView *back_view;

@end

@implementation SummarizeBookTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = SetColor(246, 246, 246, 1);
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.back_view = [[UIView alloc] init];
    self.back_view.backgroundColor = WhiteColor;
    ViewRadius(self.back_view, 5.0);
    [self.contentView addSubview:self.back_view];
    __weak typeof(self) weakSelf = self;
    [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(5, 20, 5, 20));
    }];
    
    self.top_label = [[UILabel alloc] init];
    self.top_label.font = SetFont(10);
    self.top_label.textColor = SetColor(49, 49, 49, 1);
    self.top_label.text = @"Tips总结 · 浙江省2017年 副省级 A卷 27题 及 更多3题";
    [self.back_view addSubview:self.top_label];
    [self.top_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.back_view.mas_top).offset(10);
        make.left.equalTo(weakSelf.back_view.mas_left).offset(10);
    }];
    
    self.content_label = [[UILabel alloc] init];
//    self.content_label.backgroundColor = [UIColor redColor];
    self.content_label.font = SetFont(14);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 34;
    self.content_label.numberOfLines = 3;
    self.content_label.lineBreakMode = NSLineBreakByTruncatingTail;
    self.content_label.text = @"27、在通往目标的历程中遭遇挫折并不可怕，可怕的是因挫折而产可怕的是因挫折而产可怕的是因挫折而产可怕的是因挫折而产可怕的是因挫折而产可怕的是因挫折而产可怕的是因挫折而产可怕的是因挫折而产可怕的是因挫折而产生的对自己能力的_________。";
    [self.back_view addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top_label.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.top_label.mas_left);
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-10);
    }];
    
    CGFloat answer_width = (SCREENBOUNDS.width - 40 - 20 - 15) / 4;
    self.answer_label_A = [[UILabel alloc] init];
    self.answer_label_A.font = SetFont(14);
    self.answer_label_A.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.answer_label_A.text = @"A：答案AAAAAAAA";
    [self.back_view addSubview:self.answer_label_A];
    [self.answer_label_A mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.content_label.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.content_label.mas_left);
        make.width.mas_equalTo(answer_width);
    }];
    
    self.answer_label_B = [[UILabel alloc] init];
    self.answer_label_B.font = SetFont(14);
    self.answer_label_B.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.answer_label_B.text = @"B：答案BBBBBBBB";
    [self.back_view addSubview:self.answer_label_B];
    [self.answer_label_B mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.answer_label_A.mas_top).offset(0);
        make.left.equalTo(weakSelf.answer_label_A.mas_right).offset(5);
        make.width.mas_equalTo(answer_width);
    }];
    
    self.answer_label_C = [[UILabel alloc] init];
    self.answer_label_C.font = SetFont(14);
    self.answer_label_C.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.answer_label_C.text = @"C：答案CCCCCCCCCC";
    [self.back_view addSubview:self.answer_label_C];
    [self.answer_label_C mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.answer_label_A.mas_top).offset(0);
        make.left.equalTo(weakSelf.answer_label_B.mas_right).offset(5);
        make.width.mas_equalTo(answer_width);
    }];
    
    self.answer_label_D = [[UILabel alloc] init];
    self.answer_label_D.font = SetFont(14);
    self.answer_label_D.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.answer_label_D.text = @"D：答案DDDDDDDDDDDDD";
    [self.back_view addSubview:self.answer_label_D];
    [self.answer_label_D mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.answer_label_A.mas_top).offset(0);
        make.left.equalTo(weakSelf.answer_label_C.mas_right).offset(5);
        make.width.mas_equalTo(answer_width);
    }];
    
    self.summarize_label = [[UILabel alloc] init];
    self.summarize_label.font = SetFont(14);
    self.summarize_label.lineBreakMode = NSLineBreakByTruncatingTail;
    self.summarize_label.text = @"这些题目我在做的时候，因为没有看清楚前后前后前后前后前后前后前后";
    [self.back_view addSubview:self.summarize_label];
    [self.summarize_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.answer_label_A.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.back_view.mas_left).offset(15);
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-15);
    }];
    
    self.date_label = [[UILabel alloc] init];
    self.date_label.font = SetFont(10);
    self.date_label.textColor = DetailTextColor;
    self.date_label.text = @"2018/12/3";
    [self.back_view addSubview:self.date_label];
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-15);
        make.bottom.equalTo(weakSelf.back_view.mas_bottom).offset(-10);
    }];
    
    self.select_image = [[UIImageView alloc] init];
    self.select_image.image = [UIImage imageNamed:@"select_no"];
    self.select_image.hidden = YES;
    ViewRadius(self.select_image, 10.0);
    [self.contentView addSubview:self.select_image];
    [self.select_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setIsSupportSelect:(BOOL)isSupportSelect {
    _isSupportSelect = isSupportSelect;
    __weak typeof(self) weakSelf = self;
    if (_isSupportSelect) {
        [self.back_view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-40);
        }];
        self.select_image.hidden = NO;
    } else {
        [self.back_view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        }];
        self.select_image.hidden = YES;
    }
}

- (void)setIsHiddenSummarizeLabel:(BOOL)isHiddenSummarizeLabel {
    _isHiddenSummarizeLabel  = isHiddenSummarizeLabel;
    if (_isHiddenSummarizeLabel) {
        self.summarize_label.hidden = YES;
        self.date_label.hidden = YES;
    }else {
        self.summarize_label.hidden = NO;
        self.date_label.hidden = NO;
    }
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
