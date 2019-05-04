//
//  View_Collectionview.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "View_Collectionview.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "View_CollectionViewCell.h"

@interface View_Collectionview()<UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation View_Collectionview

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    CGFloat width = (SCREENBOUNDS.width - 50) / 4;
    layout.itemSize = CGSizeMake(width, 44);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.pagingEnabled = YES;
    /// 设置此属性为yes 不满一屏幕 也能滚动
    self.collectionview.alwaysBounceHorizontal = YES;
    self.collectionview.showsHorizontalScrollIndicator = NO;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[View_CollectionViewCell class] forCellWithReuseIdentifier:@"viewCell"];
    [self addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LineTest_Category_Model *model = self.dataArr[indexPath.row];
    View_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"viewCell" forIndexPath:indexPath];
    cell.contentLabel.text = model.lineTest_category_content;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected  indexPath == %@", indexPath);
    self.returnSelectedIndex(indexPath);
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionview reloadData];
    [self.collectionview selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setDataArray:(NSArray *)array withIndexPath:(NSIndexPath *)indexPath {
    self.dataArr = array;
    [self.collectionview reloadData];
    [self.collectionview selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

@end
