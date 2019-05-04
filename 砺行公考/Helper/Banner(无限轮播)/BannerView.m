//
//  BannerView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BannerView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface BannerView () <UIScrollViewDelegate>

@property BOOL hasTimer;
@property (nonatomic, assign) NSUInteger interval;

@property (nonatomic, strong) UIImage *placeHolder;

@property (nonatomic, strong) NSArray * imageArray;

@property (nonatomic, strong) UIScrollView *wheelScrollView;        // scrollView
@property (nonatomic, strong) UIPageControl *wheelPageControl;      // pageControl

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger currentImageIndex;

@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UIImageView *image3;

@property (nonatomic, assign) NSUInteger imageNum;

@property (nonatomic, strong) UIImageView *mask;
@property (nonatomic, assign) BOOL isLocal;

@end

@implementation BannerView

#pragma mark - init
+ (instancetype)initWithFrame:(CGRect)frame
                    withArray:(NSArray*)array
                     hasTimer:(BOOL)hastimer
                     interval:(NSUInteger)inter
                      isLocal:(BOOL)isLocal
{
    BannerView * carousel = [[BannerView alloc] initWithFrame:frame];
    carousel.hasTimer = hastimer;
    carousel.interval = inter;
    if (isLocal) {
        [carousel setupWithLocalArray:array];
    }else {
        [carousel setupWithArray:array];
    }
    return carousel;
}

+ (instancetype)initWithFrame:(CGRect)frame
                     hasTimer:(BOOL)hastimer
                     interval:(NSUInteger)inter
                  placeHolder:(UIImage*)image
{
    BannerView * carousel = [[BannerView alloc] initWithFrame:frame];
    carousel.placeHolder = image;
    carousel.hasTimer = hastimer;
    carousel.interval = inter;
    carousel.mask.image = image;
    return carousel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mask = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.wheelScrollView];
        [self addSubview:self.wheelPageControl];
        [self addSubview:self.mask];
        self.wheelScrollView.scrollEnabled = NO;
    }
    return self;
}


- (void)setupWithArray:(NSArray *)array
{
    self.wheelScrollView.scrollEnabled = YES;
    self.mask.hidden = YES;
    self.imageArray = array;
    self.imageNum = self.imageArray.count;
    self.currentImageIndex = 0;
    
    if (self.imageNum == 1) {
        self.wheelPageControl.hidden = YES;
        self.wheelScrollView.scrollEnabled = NO;
    }
    
    [self setup];
}

- (void)setupWithLocalArray:(NSArray *)array
{
    self.isLocal = YES;
    self.wheelScrollView.scrollEnabled = YES;
    self.mask.hidden = YES;
    self.imageArray = array;
    self.imageNum = self.imageArray.count;
    self.currentImageIndex = 0;
    
    if (self.imageNum == 1) {
        self.wheelPageControl.hidden = YES;
        self.wheelScrollView.scrollEnabled = NO;
    }
    
    [self setup];
}

/**
 *  初始化，启动定时器；轮播图片
 */
- (void)setup
{
    // 设置PageControl中心点
    self.wheelPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.wheelPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    CGPoint p = CGPointMake(self.frame.size.width * 0.5, 0.92 * self.frame.size.height);
    self.wheelPageControl.center = p;
    
    if (self.hasTimer) {
        [self setupTimer];
    }
    [self updateImage];
}

/**
 *  图片更新
 */
- (void)updateImage
{
    self.imageNum = (int)self.imageArray.count;
    self.wheelPageControl.numberOfPages = self.imageNum;
    
    [self updateScrollImage];
}



- (void)updateScrollImage
{
    int left;
    int right;
    
    // 计算页数
    int page = self.wheelScrollView.contentOffset.x / self.wheelScrollView.frame.size.width;
    if (page == 0)
    {
        // 计算当前图片索引
        self.currentImageIndex = (self.currentImageIndex + self.imageNum - 1) % self.imageNum;   // %限定当前索引不越界；
    }
    else if(page == 2)
    {
        // 计算当前图片索引
        self.currentImageIndex = (self.currentImageIndex + 1) % self.imageNum;
    }
    
    // 当前图片左右索引
    left = (int)(self.currentImageIndex + self.imageNum - 1) % self.imageNum;
    right = (int)(self.currentImageIndex + 1) % self.imageNum;
    
    // 更换UIImage
    if (self.isLocal)
    {
        self.image1.image = [UIImage imageNamed:self.imageArray[left]];
        self.image2.image = [UIImage imageNamed:self.imageArray[self.self.currentImageIndex]];
        self.image3.image = [UIImage imageNamed:self.imageArray[right]];
    }
    else
    {
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:self.imageArray[left]]  placeholderImage:self.placeHolder];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:self.imageArray[self.currentImageIndex]] placeholderImage:self.placeHolder];
        [self.image3 sd_setImageWithURL:[NSURL URLWithString:self.imageArray[right]] placeholderImage:self.placeHolder];
    }
    
    self.wheelPageControl.currentPage = self.currentImageIndex;
    [self.wheelScrollView setContentOffset:CGPointMake(self.wheelScrollView.frame.size.width, 0) animated:NO];
}

#pragma mark - NSTimer
- (void)setupTimer
{
    if (self.interval == 0)
    {
        self.interval = 3;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(updateWheel) userInfo:nil repeats:YES];
    
    // 避免tableview滚动时，定时器停止；
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateWheel
{
    CGPoint offset = self.wheelScrollView.contentOffset;
    offset.x += self.wheelScrollView.frame.size.width;
    [self.wheelScrollView setContentOffset:offset animated:YES];
}



- (void)destroy
{
    [self.timer invalidate];
}

#pragma mark - UIScrollView
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateScrollImage];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateScrollImage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.hasTimer) {
        [self setupTimer];
    }else {
        
    }
}


- (void)touchAction
{
    if ([self.delegate respondsToSelector:@selector(carouselTouch:atIndex:)]) {
        [self.delegate carouselTouch:self atIndex:self.currentImageIndex];
    }
    
    // 使用block的回调
    if (self.bannerTouchBlock)
    {
        self.bannerTouchBlock(self.currentImageIndex);
    }
}

#pragma mark - Getter

- (UIScrollView *)wheelScrollView
{
    if (!_wheelScrollView)
    {
        _wheelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _wheelScrollView.backgroundColor = [UIColor clearColor];
        _wheelScrollView.pagingEnabled = YES;
        _wheelScrollView.delegate = self;
        _wheelScrollView.showsHorizontalScrollIndicator = NO;
        _wheelScrollView.showsVerticalScrollIndicator = NO;
        
        // 添加点击事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)];
        [_wheelScrollView addGestureRecognizer:tap];
        
        // 使用3个UIImageView，
        _image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _image2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        _image3 = [[UIImageView alloc] initWithFrame:CGRectMake(2*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        _image2.image = self.placeHolder;
        
        for (UIImageView * img in @[_image1,_image2,_image3]) {
            [_wheelScrollView addSubview:img];
        }
        
        [_wheelScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        _wheelScrollView.scrollEnabled = YES;
        _wheelScrollView.contentSize = CGSizeMake(3*self.frame.size.width, self.frame.size.height);
    }
    return _wheelScrollView;
}

- (UIPageControl *)wheelPageControl
{
    if (!_wheelPageControl)
    {
        _wheelPageControl = [[UIPageControl alloc] init];
        [_wheelPageControl setBackgroundColor:[UIColor clearColor]];
        _wheelPageControl.currentPage = 0;
        _wheelPageControl.numberOfPages = self.imageNum;
    }
    
    return _wheelPageControl;
}

@end
