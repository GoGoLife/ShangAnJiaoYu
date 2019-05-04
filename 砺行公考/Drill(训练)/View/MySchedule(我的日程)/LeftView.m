//
//  LeftView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "LeftView.h"
#import "ScheduleCollectionViewCell.h"
#import <Masonry.h>
#import "GlobarFile.h"
#import "KPDateTool.h"

@interface LeftView()<UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation LeftView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    CGFloat width = SCREENBOUNDS.width / 4 * 3 / 6 - 2;
    layout.itemSize = CGSizeMake(width, 30);
    layout.headerReferenceSize = CGSizeMake(SCREENBOUNDS.width, 10.0);
    
    self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.backgroundColor = [UIColor whiteColor];
    [self.collectionV registerClass:[ScheduleCollectionViewCell class] forCellWithReuseIdentifier:@"left"];
    [self.collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self addSubview:self.collectionV];
    __weak typeof(self) weakSelf = self;
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [KPDateTool returnDaysInYear];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"left" forIndexPath:indexPath];
    cell.label.font = SetFont(12);
    cell.textAlignment = VerticalAlignmentTop;
    cell.label.textColor = SetColor(175, 175, 175, 1);
    NSString *string = [NSString stringWithFormat:@"%02ld:00", indexPath.row];
    cell.label.textAlignment = NSTextAlignmentRight;
    cell.label.text = string;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    header.backgroundColor = WhiteColor;
    return header;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.setContentOffset(scrollView.contentOffset);
}

@end
