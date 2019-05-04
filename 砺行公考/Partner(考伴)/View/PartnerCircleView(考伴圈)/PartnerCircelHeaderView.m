//
//  PartnerCircelHeaderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PartnerCircelHeaderView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "TipsCollectionViewCell.h"
#import "DigestView.h"
#import "AppDelegate.h"
#import "CreatBookView.h"

@interface PartnerCircelHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TextViewMenuDelegate>

@property (nonatomic, strong) DigestView *digest;

@property (nonatomic, strong) CreatBookView *creat_book;


@end

@implementation PartnerCircelHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self creatHeaderViewUI];
    }
    return self;
}

- (void)setContent_height:(CGFloat)content_height {
    _content_height = content_height;
    [self.content_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(content_height);
    }];
}

- (void)creatHeaderViewUI {
    __weak typeof(self) weakSelf = self;
    
    self.header_image = [[UIImageView alloc] init];
    self.header_image.backgroundColor = RandomColor;
    ViewRadius(self.header_image, 20.0);
    [self addSubview:self.header_image];
    [self.header_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.name_label = [[UILabel alloc] init];
    self.name_label.font = SetFont(16);
    self.name_label.text = @"很犀利";
    [self addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_image.mas_top);
        make.left.equalTo(weakSelf.header_image.mas_right).offset(10);
    }];
    
    self.date_label = [[UILabel alloc] init];
    self.date_label.font = SetFont(12);
    self.date_label.textColor = SetColor(191, 191, 191, 1);
    self.date_label.text = @"2小时前";
    [self addSubview:self.date_label];
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.name_label.mas_left);
        make.bottom.equalTo(weakSelf.header_image.mas_bottom);
    }];
    
    self.address_label = [[UILabel alloc] init];
    self.address_label.font = SetFont(12);
    self.address_label.text = @"杭州";
    [self addSubview:self.address_label];
    [self.address_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.date_label.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.date_label.mas_centerY);
    }];
    
    self.content_label = [[TextViewMenu alloc] init];
    self.content_label.editable = NO;
    self.content_label.scrollEnabled = NO;
    self.content_label.font = SetFont(16);
    self.content_label.type = actionType_Digest;
    self.content_label.CustomDelegate = self;
    [self addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_image.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.height.mas_equalTo(20.0);
    }];
    
    //点赞
    self.spotPraise_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.spotPraise_button setImage:[UIImage imageNamed:@"parise_button"] forState:UIControlStateNormal];
    [self addSubview:self.spotPraise_button];
    [self.spotPraise_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-20);
        make.left.equalTo(weakSelf.header_image.mas_left);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.spotPraise_button addTarget:self action:@selector(touchPraiseAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.spotPraise_label = [[UILabel alloc] init];
    self.spotPraise_label.font = SetFont(14);
    self.spotPraise_label.textColor = SetColor(191, 191, 191, 1);
    self.spotPraise_label.text = @"你和其他25人点赞";
    [self addSubview:self.spotPraise_label];
    [self.spotPraise_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.spotPraise_button.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.spotPraise_button.mas_centerY);
    }];
    
    //评论button
    self.comment_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.comment_button setImage:[UIImage imageNamed:@"comment_button"] forState:UIControlStateNormal];
    [self.comment_button addTarget:self action:@selector(touchCommentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.comment_button];
    [self.comment_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.spotPraise_label.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.spotPraise_button.mas_centerY);
        make.size.equalTo(weakSelf.spotPraise_button);
    }];
    
    self.comment_label = [[UILabel alloc] init];
    self.comment_label.font = SetFont(14);
    self.comment_label.textColor = SetColor(191, 191, 191, 1);
    self.comment_label.text = @"26";
    [self addSubview:self.comment_label];
    [self.comment_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.comment_button.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.spotPraise_button.mas_centerY);
    }];
    
    //删除动态按钮
    self.delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delete_button.titleLabel.font = SetFont(14);
    [self.delete_button setTitleColor:SetColor(242, 68, 89, 1) forState:UIControlStateNormal];
    [self.delete_button setTitle:@"删除" forState:UIControlStateNormal];
    [self.delete_button addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.delete_button];
    [self.delete_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_image.mas_top);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
}

#pragma mark ---- collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collection_data_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageview.contentMode = UIViewContentModeScaleAspectFill;
    
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:self.collection_data_array[indexPath.row]] placeholderImage:[UIImage imageNamed:@"image1"]];
    return cell;
}

#pragma mark ---- collectionview flowlayout delegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self formatItemSize:self.collection_data_array];
}

- (void)setCollection_data_array:(NSArray *)collection_data_array {
    _collection_data_array = collection_data_array;
    __weak typeof(self) weakSelf = self;
    CGSize size = [self formatItemSize:self.collection_data_array];
    if (_collection_data_array.count > 0) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionview.backgroundColor = WhiteColor;
        self.collectionview.delegate = self;
        self.collectionview.dataSource = self;
        [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.collectionview];
        [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.content_label.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.mas_left);
            make.right.equalTo(weakSelf.mas_right);
            make.height.mas_equalTo(size.height + 20);
        }];
    }
    [self.collectionview reloadData];
}

//整理item的size   根据图片的张数来确定
- (CGSize)formatItemSize:(NSArray *)imageArray {
    CGSize item_size = CGSizeZero;
    if (imageArray.count == 0) {
        item_size = CGSizeZero;
    }else if (imageArray.count == 1) {
        //屏幕上的图片显示的最大宽度
        CGFloat width = SCREENBOUNDS.width - 40;
        item_size = CGSizeMake(width, 300);
    }else {
        CGFloat width = (SCREENBOUNDS.width - 40 - 20) / 3;
        item_size = CGSizeMake(width, width);
    }
    return item_size;
}

- (void)setIsShowDeleteButton:(BOOL)isShowDeleteButton {
    _isShowDeleteButton = isShowDeleteButton;
    if (_isShowDeleteButton) {
        self.delete_button.hidden = NO;
    }else {
        self.delete_button.hidden = YES;
    }
}

//发布父评论
- (void)touchCommentButtonAction {
    if ([_delegate respondsToSelector:@selector(touchPublishComment:)]) {
        [_delegate touchPublishComment:self.section];
    }
}

//删除动态
- (void)deleteButtonAction {
    if ([_delegate respondsToSelector:@selector(touchDeleteButtonAction:)]) {
        [_delegate touchDeleteButtonAction:self.section];
    }
}

//点赞
- (void)touchPraiseAction {
    if ([_delegate respondsToSelector:@selector(touchPraiseButtonAction:PraiseLabel:)]) {
        [_delegate touchPraiseButtonAction:self.section PraiseLabel:self.spotPraise_label];
    }
}

#pragma mark ****** setter **********
- (void)setUser_like_status:(NSInteger)user_like_status {
    _user_like_status = user_like_status;
    if (_user_like_status == 0) {
        self.spotPraise_label.textColor = SetColor(191, 191, 191, 1);
    }else {
        self.spotPraise_label.textColor = ButtonColor;
    }
}

/** 添加到摘记本 */
- (void)touchDigestAction {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.digest = [[DigestView alloc] init];
    self.digest.type = OPRATION_TYPE_CREATE;
    self.digest.digest_content_string = [self.content_label textInRange:[self.content_label selectedTextRange]];
    [app.window addSubview:self.digest];
    [self.digest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    __weak typeof(self) weakSelf = self;
    //点击了新建摘记本按钮的回调
    self.digest.creatBookBlock = ^{
        weakSelf.digest.hidden = YES;
        [weakSelf addCreatBookView];
    };
}

//新建摘记本
- (void)addCreatBookView {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.creat_book = [[CreatBookView alloc] init];
    self.creat_book.type = 1;
    __weak typeof(self) weakSelf = self;
    self.creat_book.backBlock = ^{
        [weakSelf.creat_book removeFromSuperview];
        weakSelf.digest.hidden = NO;
    };
    
    self.creat_book.returnBookNameBlock = ^(NSString *name) {
        [weakSelf.creat_book removeFromSuperview];
        weakSelf.digest.hidden = NO;
        [weakSelf.digest getHttpData];
    };
    [app.window addSubview:self.creat_book];
    [self.creat_book mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
