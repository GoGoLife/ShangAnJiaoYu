//
//  BannerView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  原理很简单，就是放上3个UIImageView, 默认显示的是中间的UIImageView，
 *  当用户滑到下一张图片的临界点时候，偷偷的切换回中间的UIImageView展示，但是UIImage却全部换掉了；
 *  也就是说用户永远看到的是中间的UIImageView，只是内容不同而已。
 *
 */

@class BannerView;
@protocol BannerViewDelegate <NSObject>

- (void)carouselTouch:(BannerView*)carousel atIndex:(NSUInteger)index;

@end

@interface BannerView : UIView

@property (nonatomic, copy) void(^bannerTouchBlock)(NSUInteger index);

@property (nonatomic, weak) id<BannerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  轮播图url数组
 *
 */
- (void)setupWithArray:(NSArray *)array;

/**
 *  本地图片数组；
 */
- (void)setupWithLocalArray:(NSArray *)array;

/**
 *  类初始化方法；
 *
 */
+ (instancetype)initWithFrame:(CGRect)frame
                    withArray:(NSArray*)array
                     hasTimer:(BOOL)hastimer
                     interval:(NSUInteger)inter
                      isLocal:(BOOL)isLocal;

+ (instancetype)initWithFrame:(CGRect)frame
                     hasTimer:(BOOL)hastimer
                     interval:(NSUInteger)inter
                  placeHolder:(UIImage*)image;

@end
