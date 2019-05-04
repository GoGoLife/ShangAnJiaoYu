//
//  BigTrainingTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigTrainingTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface BigTrainingTableViewCell ()<UITextViewDelegate>

@end

@implementation BigTrainingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    __weak typeof(self) weakSelf = self;
    self.left_imageview = [[UIImageView alloc] init];
    self.left_imageview.image = [UIImage imageNamed:@"Training_one"];
    [self.contentView addSubview:self.left_imageview];
    [self.left_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(5);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-5);
        make.height.mas_equalTo(50.0);
        make.width.mas_equalTo(0.0);
    }];
    
    self.content_textview = [[UITextView alloc] init];
    self.content_textview.delegate = self;
    self.content_textview.backgroundColor = SetColor(246, 246, 246, 1);
    self.content_textview.font = SetFont(14);
    self.content_textview.scrollEnabled = NO;
    
    ViewRadius(self.content_textview, 8.0);
    [self.contentView addSubview:self.content_textview];
    [self.content_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(5);
        make.left.equalTo(weakSelf.left_imageview.mas_right).offset(5);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.height.mas_greaterThanOrEqualTo(50.0);
    }];
}

- (void)setIsShowLeftImage:(BOOL)isShowLeftImage {
    _isShowLeftImage = isShowLeftImage;
    if (!_isShowLeftImage) {
        //表示隐藏
        [self.left_imageview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.0);
        }];
    }else {
        //表示显示
        [self.left_imageview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40.0);
        }];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

StringHeight()
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat padding = self.isShowLeftImage ? 95 : 50;
    CGFloat all_height = [self calculateRowHeight:textView.text fontSize:14 withWidth:SCREENBOUNDS.width - padding];
    all_height = all_height < 40.0 ? 40.0 : all_height;
    //通知刷新
    if ([_delegate respondsToSelector:@selector(reloadTableviewCellTextView:withIndexPath:withContentHieght:)]) {
        [_delegate reloadTableviewCellTextView:textView withIndexPath:self.indexPath withContentHieght:all_height];
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
