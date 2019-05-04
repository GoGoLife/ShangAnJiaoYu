//
//  SpecializedTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SpecializedTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface SpecializedTableViewCell ()<UITextViewDelegate>

@end

@implementation SpecializedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"材料";
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
    }];
    
    UIButton *look_default_answer = [UIButton buttonWithType:UIButtonTypeCustom];
    look_default_answer.titleLabel.font = SetFont(14);
    [look_default_answer setTitleColor:ButtonColor forState:UIControlStateNormal];
    [look_default_answer setTitle:@"参考答案" forState:UIControlStateNormal];
    [self.contentView addSubview:look_default_answer];
    [look_default_answer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
    }];
    [look_default_answer addTarget:self action:@selector(lookDefaultAnswerAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(16);
    self.content_label.textColor = SetColor(74, 74, 74, 1);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.content_label.numberOfLines = 0;
    self.content_label.text = @" 90后创业具有明显的优势：该题使用信息对应点法。当地好的好。觉得客户会发，生厉害呐上班看见撒谎的好看了，撒娇哭了就离。开价值连城状况会笑口常开着谁的风景哦速开价值连城状况会笑口常开着谁的风景哦速";
    [self.contentView addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(look_default_answer.mas_right);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(14);
    label1.textColor = DetailTextColor;
    label1.text = @"提取总括概述";
    [self.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.content_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.content_label.mas_left);
    }];
    
    self.answer_textview = [[UITextView alloc] init];
    self.answer_textview.font = SetFont(16);
    self.answer_textview.textColor = SetColor(74, 74, 74, 1);
    self.answer_textview.text = @"请填写总括";
    self.answer_textview.delegate = self;
    [self.contentView addSubview:self.answer_textview];
    [self.answer_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(10);
        make.left.equalTo(label1.mas_left);
        make.right.equalTo(weakSelf.content_label.mas_right);
        make.height.mas_equalTo(60);
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

/**
 参考答案   方法
 */
- (void)lookDefaultAnswerAction {
    if ([_delegate respondsToSelector:@selector(returnCellIndexPath:)]) {
        [_delegate returnCellIndexPath:self.indexPath];
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
