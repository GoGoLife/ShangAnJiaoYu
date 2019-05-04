//
//  ScrollTextView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ScrollTextView.h"
#import "GlobarFile.h"

@interface ScrollTextView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, assign) NSTimeInterval interval;

@property (nonatomic, strong) NSArray *data_array;

@end

@implementation ScrollTextView

- (instancetype)initWithFrame:(CGRect)frame whitTextArray:(NSArray *)array {
    if (self == [super initWithFrame:frame]) {
        self.interval = 2;
//        [self creatUI:[self changeData:array]];
    }
    return self;
}

- (instancetype)init {
    if (self == [super init]) {
        self.interval = 2;
    }
    return self;
}


- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self creatUI:[self changeData:_titleArray]];
}

- (NSArray *)changeData:(NSArray *)dataArr {
    NSMutableArray *tmpArray = [dataArr mutableCopy];
    if ([dataArr count] > 1) {
        // 额外拷贝第一个和最后一个数据
        [tmpArray addObject:[dataArr firstObject]];
        [tmpArray insertObject:[dataArr lastObject] atIndex:0];
    }
    self.data_array = [tmpArray copy];
    return self.data_array;
}

- (void)creatUI:(NSArray *)array {
    self.scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.delegate = self;
    self.scroll.pagingEnabled = YES;
    [self addSubview:self.scroll];
    for (NSInteger index = 0; index < array.count; index++) {
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(40, self.bounds.size.height * index, self.bounds.size.width - 40, self.bounds.size.height)];
        label.font = SetFont(12);
        label.text = array[index][@"title_"] ?: array[index][@"content_"];
        label.tag = index;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchLabelAction:)];
        [label addGestureRecognizer:tapGes];
        
        UILabel *leftV = [[UILabel alloc] initWithFrame:FRAME(5, CGRectGetMidY(label.frame) + self.bounds.size.height / 2, 5, 5)];
        leftV.textColor = SetColor(242, 68, 89, 1);
        leftV.font = SetFont(14);
        leftV.text = @"HOT";
        [leftV sizeToFit];
        [leftV setCenter:CGPointMake(leftV.center.x, label.center.y)];
        
        [self.scroll addSubview:leftV];
        [self.scroll addSubview:label];
    }
    [self.scroll setContentSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height * array.count)];
    
    if (array.count > 1) {
        [self startAutoScroll];
    }
}

- (void)makeInfiniteScrolling {
    CGFloat height = self.frame.size.height;
    NSInteger currentPage = (self.scroll.contentOffset.y + height / 2.0) / height;
    
    if (currentPage == self.data_array.count - 1) {
        self.currentPage = 0;
        [self.scroll setContentOffset:CGPointMake(0, height) animated:NO];
    } else if (currentPage == 0) {
        self.currentPage = self.data_array.count - 2;
        
        [self.scroll setContentOffset:CGPointMake(0, height * (self.data_array.count - 2)) animated:NO];
    } else {
        self.currentPage = currentPage - 1;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self makeInfiniteScrolling];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self makeInfiniteScrolling];
}

- (void)startAutoScroll {
    if (self.scrollTimer || self.interval == 0 ) {
        return;
    }
    self.scrollTimer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(doScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSDefaultRunLoopMode];
}

- (void)doScroll {
    
    [self.scroll setContentOffset:CGPointMake(0, self.scroll.contentOffset.y + self.frame.size.height) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoScroll];
}

- (void)stopAutoScroll {
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startAutoScroll];
}

- (void)touchLabelAction:(UITapGestureRecognizer *)ges {
    NSInteger tag = ges.view.tag;
    tag = tag == 0 ? self.titleArray.count - 1 : tag - 1;
    if ([_delegate respondsToSelector:@selector(touchScrollTextActionWithIndex:)]) {
        [_delegate touchScrollTextActionWithIndex:self.titleArray[tag]];
    }
}

@end
