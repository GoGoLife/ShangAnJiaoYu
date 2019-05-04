//
//  DetailsHeaderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DetailsHeaderView.h"
#import "VideoCollectionViewCell.h"
#import "TipsCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface DetailsHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionview;

@end

@implementation DetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
//        [self initViewUI];
    }
    return self;
}

- (void)setCollectionview_data_array:(NSArray *)collectionview_data_array {
    _collectionview_data_array = collectionview_data_array;
    [self initViewUI];
}

StringWidth()
- (void)initViewUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.itemSize = CGSizeMake(SCREENBOUNDS.width, 370);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.pagingEnabled = YES;
    /// 设置此属性为yes 不满一屏幕 也能滚动
    self.collectionview.alwaysBounceHorizontal = YES;
    self.collectionview.showsHorizontalScrollIndicator = NO;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"videoCell"];
    [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
    [self addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(370);
    }];
    
    UILabel *content_label = [[UILabel alloc] init];
    content_label.font = SetFont(14);
    content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    content_label.numberOfLines = 0;
    content_label.text = self.title_string;//@" 言语理解速成20课：砺行教育全app所有权限全部享受，最划算的砺行人回报套餐";
    [self addSubview:content_label];
    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionview.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
    
//    UILabel *tag_label = [[UILabel alloc] init];
//    tag_label.font = SetFont(12);
//    tag_label.textColor = SetColor(255, 85, 0, 1);
//    tag_label.text = @"超级VIP班级";
//    ViewBorderRadius(tag_label, 0.0, 1.0, SetColor(255, 85, 0, 1));
//    [self addSubview:tag_label];
//    [tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(content_label.mas_bottom).offset(10);
//        make.left.equalTo(content_label.mas_left);
//    }];
    CGFloat offset_width = 0.0;
    for (NSInteger index = 0; index < self.tag_array.count; index++) {
        UILabel *tag_label = [[UILabel alloc] init];
        tag_label.textAlignment = NSTextAlignmentCenter;
        tag_label.font = SetFont(10);
        tag_label.textColor = SetColor(255, 85, 0, 1);
        ViewBorderRadius(tag_label, 2.0, 1.0, SetColor(255, 85, 0, 1));
        tag_label.text = self.tag_array[index];
        [self addSubview:tag_label];
        CGFloat width = [self calculateRowWidth:self.tag_array[index] withFont:10];
        [tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content_label.mas_bottom).offset(10);
            make.left.equalTo(content_label.mas_left).offset(offset_width);
            make.width.mas_equalTo(width + 5);
        }];
        offset_width = offset_width + [self calculateRowWidth:self.tag_array[index] withFont:10] + 5 + 10;
    }
    
    UILabel *price_label = [[UILabel alloc] init];
    price_label.font = SetFont(22);
    price_label.textColor = SetColor(242, 68, 89, 1);
    price_label.text = self.price_string;//@"￥135";
    [self addSubview:price_label];
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content_label.mas_bottom).offset(40);
        make.left.equalTo(content_label.mas_left);
    }];
    
    UILabel *number_label = [[UILabel alloc] init];
    number_label.font = SetFont(12);
    number_label.textColor = DetailTextColor;
    number_label.text = self.pay_numbers_string;//@"23242人付款";
    [self addSubview:number_label];
    [number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(price_label.mas_right).offset(10);
        make.centerY.equalTo(price_label.mas_centerY);
    }];
    
    UILabel *date_label = [[UILabel alloc] init];
    date_label.font = SetFont(12);
    date_label.textColor = DetailTextColor;
    date_label.text = self.date_string;//@"授课时间：2017.10.01～2018.12.30（779+课时）";
    [self addSubview:date_label];
    [date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price_label.mas_bottom).offset(10);
        make.left.equalTo(price_label.mas_left);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *firstObject = self.collectionview_data_array.firstObject;
    if ([firstObject isEqualToString:@""]) {
        //没有视频   去掉第一个视频元素
        return self.collectionview_data_array.count - 1;
    }
    return self.collectionview_data_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *firstObject = self.collectionview_data_array.firstObject;
    if ([firstObject isEqualToString:@""]) {
        TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        NSString *url_string = self.collectionview_data_array[indexPath.row + 1];
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:url_string] placeholderImage:[UIImage imageNamed:@"date"]];
        return cell;
    }else {
        if (indexPath.row == 0) {
            VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
            cell.video_url_string = self.collectionview_data_array[indexPath.row];
            return cell;
        }
        TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        NSString *url_string = self.collectionview_data_array[indexPath.row];
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:url_string] placeholderImage:[UIImage imageNamed:@"date"]];
        return cell;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
