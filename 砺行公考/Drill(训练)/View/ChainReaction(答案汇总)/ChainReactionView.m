//
//  ChainReactionView.m
//  LianDong
//
//  Created by 薛林 on 16/9/17.
//  Copyright © 2016年 xuelin. All rights reserved.
//

#import "ChainReactionView.h"
#import <Masonry.h>
#import "XLChannelLabel.h"
#import "AnswerCollectionViewCell.h"
#import "CustomAnswerModel.h"
#import "GlobarFile.h"

static NSString *HomeItemReuseIdentifier = @"HomeItemReuseIdentifier";
@interface ChainReactionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *channelView;//频道View
@property (nonatomic, strong) UICollectionView *collectionView;//底部数据
@property (nonatomic, strong) UIView *underLine;//底部线条
@property (nonatomic, strong) XLChannelLabel *selectedLabel;//选中的按钮
@property (nonatomic, strong) NSMutableArray *labelArray;//频道数组

@end



@implementation ChainReactionView

- (instancetype)initWithFrame:(CGRect)frame withNameArray:(NSArray *)nameArray {
    if (self = [super initWithFrame:frame]) {
        self.nameArray = nameArray;
        //设置UI
        [self setUpUI];
    }
    return self;
}
//设置UI
- (void)setUpUI {
    __weak typeof(self) weakSelf = self;
    //添加控件
    [self addSubview:self.channelView];
    [self addSubview:self.collectionView];
    [self addSubview:self.underLine];
    //设置约束
//    [self.channelView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.equalTo(weakSelf).offset(30);
//        make.top.equalTo(weakSelf).offset(20);
//        make.height.mas_equalTo(44);
//    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.channelView.mas_bottom);
        make.bottom.leading.trailing.equalTo(weakSelf);
    }];
    
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.leading.bottom.equalTo(weakSelf.channelView);
        make.width.mas_equalTo(60);
    }];

}

#pragma mark - 懒加载
//频道view
- (UIScrollView *)channelView {
    if (!_channelView) {
        _channelView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 0, SCREENBOUNDS.width - 60, 44)];
        
        //创建按钮
        CGFloat buttonWidth = ([UIScreen mainScreen].bounds.size.width - 60) / 5;
        CGFloat buttonHeight = 44;
        CGFloat buttonY = 0;
        
        self.labelArray = [NSMutableArray array];
        
        for (int i = 0; i < self.nameArray.count; i++) {
            CGFloat buttonX = i * buttonWidth;
            XLChannelLabel *button = [[XLChannelLabel alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
            button.text = self.nameArray[i];
            button.font = [UIFont systemFontOfSize:14];
            button.tag = i;
            if (button.tag == 0) {
                button.scale = 1.0;
                self.selectedLabel = button;
            }
            [self.labelArray addObject:button];
            //添加事件
            [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
            
            [_channelView addSubview:button];
        }
        _channelView.backgroundColor = [UIColor whiteColor];
        _channelView.bounces = NO;
        _channelView.contentSize = CGSizeMake(self.nameArray.count * buttonWidth, 0);
        _channelView.showsHorizontalScrollIndicator = NO;
    }
    return _channelView;
}

//底部数据
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //流水布局
//        ELCVFlowLayout *flowLayout = [[ELCVFlowLayout alloc] init];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 180) / 5;
        flowLayout.itemSize = CGSizeMake(width, width);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30);
        flowLayout.minimumLineSpacing = 20;
        flowLayout.minimumInteritemSpacing = 30;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        //注册item
        [_collectionView registerClass:[AnswerCollectionViewCell class] forCellWithReuseIdentifier:HomeItemReuseIdentifier];
        
    }
    return _collectionView;
}

//底部线条
- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] init];
        _underLine.backgroundColor = [UIColor whiteColor];
    }
    return _underLine;
}

#pragma mark - collectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomAnswerModel *model = self.data_array[indexPath.row];
    AnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeItemReuseIdentifier forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    //判断是否有答案
    if (model.isHaveAnswer) {
        if (self.isShowYESAndNO) {
            if (model.isCorrect) {
                cell.label.backgroundColor = ButtonColor;
            }else {
                cell.label.backgroundColor = [UIColor redColor];
            }
        }else {
            cell.label.backgroundColor = ButtonColor;
        }
    }else {
        cell.label.backgroundColor = DetailTextColor;
    }
    return cell;
}

//有值的时间    刷新视图   展示结果
- (void)setData_array:(NSArray *)data_array {
    _data_array = data_array;
    [self.collectionView reloadData];
}

#pragma mark - collectionViewDelegate
//监听滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    [self setUpWhenScroll:scrollView];
}

#pragma mark - 滚动时执行的方法
- (void)setUpWhenScroll:(UIScrollView *)scrollView {
    //获取collectionView的中心点
    CGPoint pointItem = [self convertPoint:self.collectionView.center toView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointItem];
    for (XLChannelLabel *channel in self.labelArray) {
        if (channel.tag == indexPath.row) {
            self.selectedLabel = channel;
            [self setChannellabelTextAndColor];
        }
    }
    //1.计算一下,scrollView.contentOffset.x / scrollView.bounds.size.width;
    CGFloat value = (CGFloat)scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    if (value < 0 || value > (self.labelArray.count -1)) return;
    
    //2.左边的索引
    int leftIndex = (int)scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    //3.右边的索引
    int rightIndex = leftIndex + 1;
    
    //4.右边的缩放比率
    CGFloat rightScale = (value - leftIndex);
    
    //5.左边的缩放比率
    CGFloat leftScale = 1 - rightScale;
    
    //6.取出左边的ChannelLabel给它设置左边对应的缩放比率
    XLChannelLabel *leftChannelLabel = self.labelArray[leftIndex];
    leftChannelLabel.scale = leftScale;
    
    //7.取出右边的ChannelLabel给它设置左边对应的缩放比率
    if (rightIndex < self.labelArray.count) {
        XLChannelLabel *rightChannelLabel = self.labelArray[rightIndex];
        rightChannelLabel.scale = rightScale;
    }
    
}

//数组
//- (NSArray *)nameArray {
//    if (!_nameArray) {
//        _nameArray = @[@"1~20",@"21~40",@"41~60",@"61~80",@"81~100"];
//    }
//    return _nameArray;
//}

#pragma mark - 点击事件
- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    XLChannelLabel *chanelLabel = (XLChannelLabel *)recognizer.view;
    self.selectedLabel = chanelLabel;
    
    [self setChannellabelTextAndColor];
    
    //跳转到对应底部界面
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:chanelLabel.tag inSection:0];
//
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    CGFloat width = self.collectionView.bounds.size.height;//[UIScreen mainScreen].bounds.size.width - 30;
    self.collectionView.contentOffset = CGPointMake(0, chanelLabel.tag * width);
}
#pragma mark - 选中按钮文字处理方法
//设置channel文字变大、变红、居中的方发
- (void)setChannellabelTextAndColor {
//    //1.计算channelView应该滚动多远
//    CGFloat needScrollContentOffsetX = self.selectedLabel.center.x - self.channelView.bounds.size.width * 0.5;
//
//    //1.1 重新设置,点击最左边的极限值
//    if (needScrollContentOffsetX < 0) {
//        needScrollContentOffsetX = 0;
//    }
//    CGFloat maxScrollContentOffsetX = self.channelView.contentSize.width - self.channelView.bounds.size.width;
//
//    //1.2 重新设置,点击最右边的极限值
//    if (needScrollContentOffsetX > maxScrollContentOffsetX) {
//        needScrollContentOffsetX = maxScrollContentOffsetX;
//    }
//
//    //2.让其滚动
//    [self.channelView setContentOffset:CGPointMake(needScrollContentOffsetX, 0) animated:YES];
    
    //3.选中的最大最红,没选中的最小最黑
    for (XLChannelLabel *channelLabel in self.labelArray) {
        if (channelLabel == self.selectedLabel) {
            channelLabel.scale = 1.0; //变成最大最红
        }else{
            channelLabel.scale = 0.0; //变成最小最黑
        }
    }
//    [self underLinePosition:needScrollContentOffsetX];
}
#pragma mark - 底线的动画
- (void)underLinePosition:(CGFloat)needScrollContentOffsetX {
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect tempFrame = self.underLine.frame;
        tempFrame.origin.x = self.selectedLabel.frame.origin.x - needScrollContentOffsetX;
        self.underLine.frame = tempFrame;
    }];
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(returnCollectionviewDidSelectIndexPath:)]) {
        [_delegate returnCollectionviewDidSelectIndexPath:indexPath];
    }
}



@end
