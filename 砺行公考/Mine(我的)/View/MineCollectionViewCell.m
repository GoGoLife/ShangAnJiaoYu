//
//  MineCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "MineCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface MineCollectionViewCell ()

@property (nonatomic, strong) UIImageView *left_image;

@end

@implementation MineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    self.content_textfield = [[UITextField alloc] initWithFrame:FRAME(20, 0, SCREENBOUNDS.width - 40, 56)];
    self.content_textfield.enabled = NO;
    self.content_textfield.font = SetFont(16);
    [self.content_textfield editingRectForBounds:CGRectMake(10, 0, self.content_textfield.bounds.size.width, 56)];
    
    self.left_image = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 22, 22)];
    self.content_textfield.leftView = self.left_image;
    self.content_textfield.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *right_image = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 10, 14)];
    [right_image setImage:[UIImage imageNamed:@"right"]];
    self.content_textfield.rightView = right_image;
    self.content_textfield.rightViewMode = UITextFieldViewModeAlways;
    
    [self.contentView addSubview:self.content_textfield];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self.content_textfield addSubview:line];
    __weak typeof(self) weakSelf = self;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.content_textfield.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
}

- (void)setLeft_image_name:(NSString *)left_image_name {
    _left_image_name = left_image_name;
    self.left_image.image = [UIImage imageNamed:_left_image_name];
}

@end
