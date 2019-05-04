//
//  Shopping_CommentTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Shopping_CommentTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "TipsCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface Shopping_CommentTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation Shopping_CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellUI];
    }
    return self;
}

- (void)initCellUI {
    __weak typeof(self) weakSelf = self;
    self.header_image = [[UIImageView alloc] init];
    self.header_image.backgroundColor = RandomColor;
    ViewRadius(self.header_image, 12.0);
    [self.contentView addSubview:self.header_image];
    [self.header_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(14);
    self.name_label.text = @"V***MM";
    [self.contentView addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.header_image.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.header_image.mas_centerY);
    }];
    
    self.tag_label = [[UILabel alloc] init];
    self.tag_label.textAlignment = NSTextAlignmentCenter;
    self.tag_label.font = SetFont(10);
    self.tag_label.textColor = ButtonColor;
    ViewBorderRadius(self.tag_label, 10.0, 1.0, ButtonColor);
    self.tag_label.text = @"言语大宗师";
    [self.contentView addSubview:self.tag_label];
    [self.tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.name_label.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.header_image.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    self.grade_label = [[UILabel alloc] init];
    self.grade_label.font = SetFont(14);
    self.grade_label.textColor = SetColor(242, 68, 89, 1);
    self.grade_label.text = @"LV 24";
    [self.contentView addSubview:self.grade_label];
    [self.grade_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.tag_label.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.header_image.mas_centerY);
    }];
    
    self.category_label = [[UILabel alloc] init];
    self.category_label.font = SetFont(12);
    self.category_label.textColor = DetailTextColor;
    self.category_label.text = @"分类：纯网络班学员";
    [self.contentView addSubview:self.category_label];
    [self.category_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_image.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.header_image.mas_left);
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(12);
    self.content_label.textColor = DetailTextColor;
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.content_label.numberOfLines = 0;
    self.content_label.text = @"收到啦！打开简直惊呆啦～听了课后完全太牛逼了，直接过哈哈哈哈哈哈哈哈哈哈哈哈哈";
    [self.contentView addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.category_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.category_label.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    CGFloat itemWidth = (SCREENBOUNDS.width - 40 - 10 * 2) / 3;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.contentView addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.content_label.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.right.equalTo(weakSelf.contentView.mas_right);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"date"]];
    return cell;
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
