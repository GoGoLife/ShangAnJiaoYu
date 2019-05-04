//
//  BottomShowMaterialsView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/2.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BottomShowMaterialsView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "QuanZhenTestModel.h"
#import "TipsCollectionViewCell.h"
#import "TextViewMenu.h"

@interface BottomShowMaterialsView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TextViewMenuDelegate>

@property (nonatomic, strong) UIScrollView *top_scroll;

@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, strong) UIView *back_view;

@property (nonatomic, assign) NSInteger current_index;

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) TextViewMenu *textview;

@end

@implementation BottomShowMaterialsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = SetColor(155, 155, 155, 0.5);
//        [self initViewUI];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self initViewUI];
}

StringHeight()
- (void)initViewUI {
    //初始化
    self.current_index = 0;
    __weak typeof(self) weakSelf = self;
    
//    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
//    [self addSubview:cancel];
//    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.mas_top).offset(20);
//        make.right.equalTo(weakSelf.mas_right).offset(-20);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
//    [cancel addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    
    self.back_view = [[UIView alloc] init];
    self.back_view.backgroundColor = WhiteColor;
    [self addSubview:self.back_view];
    [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(200, 0, 0, 0));
    }];
    
    self.top_scroll = [[UIScrollView alloc] initWithFrame:FRAME(0, 0, self.bounds.size.width, 44)];
    [self.back_view addSubview:self.top_scroll];
    //材料按钮宽度
    CGFloat width = SCREENBOUNDS.width / 5;
    for (NSInteger index = 0; index < self.dataArray.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.frame = FRAME(width * index, 2, width, 40);
        [button setTitleColor:DetailTextColor forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(14);
        [button setTitle:[NSString stringWithFormat:@"材料%ld", index + 1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchChangeMaterials:) forControlEvents:UIControlEventTouchUpInside];
        [self.top_scroll addSubview:button];
        if (index == 0) {
            [button setTitleColor:ButtonColor forState:UIControlStateNormal];
        }
    }
    self.top_scroll.contentSize = CGSizeMake(width * self.dataArray.count, 0);
    
    //collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    layout.minimumLineSpacing = 0.0;
//    layout.minimumInteritemSpacing = 0.0;
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.back_view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top_scroll.mas_bottom);
        make.left.equalTo(weakSelf.back_view.mas_left).offset(0);
        make.right.equalTo(weakSelf.back_view.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.back_view.mas_bottom).offset(0);
    }];
}

- (void)cancelView {
    [self removeFromSuperview];
}

- (void)touchChangeMaterials:(UIButton *)sender {
    for (UIButton *button in self.top_scroll.subviews) {
        if (![button isKindOfClass:[UIButton class]]) {
            continue;
        }
        if (button.tag == sender.tag) {
            [button setTitleColor:ButtonColor forState:UIControlStateNormal];
            self.current_index = sender.tag;
            [self.collectionview reloadData];
        }else {
            [button setTitleColor:DetailTextColor forState:UIControlStateNormal];
        }
    }
}

#pragma mark ------ collectionview delegate ---------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    EssayTestQuanZhenMaterialsModel *model = self.dataArray[self.current_index];
    NSString *content = model.materials_content ?: @"";
    self.textview.text = [@"      " stringByAppendingString:content];
    [header_view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    return header_view;
}

#pragma mark ----- uicollectionview delegate flowlayout ------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    EssayTestQuanZhenMaterialsModel *model = self.dataArray[self.current_index];
    return CGSizeMake(SCREENBOUNDS.width, model.materials_content_height + 50);
}

#pragma mark --- 懒加载 -----
-(TextViewMenu *)textview {
    if (!_textview) {
        _textview = [[TextViewMenu alloc] initWithType:actionType_CollectPoints];
        _textview.textColor = SetColor(74, 74, 74, 1);
        _textview.font = SetFont(14);
        _textview.editable = NO;
        _textview.scrollEnabled = NO;
        _textview.CustomDelegate = self;
    }
    return _textview;
}

- (void)touchCollectionPoints {
    [self removeFromSuperview];
}



@end
