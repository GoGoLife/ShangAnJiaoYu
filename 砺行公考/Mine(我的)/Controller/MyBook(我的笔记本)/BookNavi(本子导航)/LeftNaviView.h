//
//  LeftNaviView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NaviLeftDidSelectDelegate <NSObject>

- (void)leftViewSelectRow:(NSInteger)index DataString:(NSString *)data;

@end

@interface LeftNaviView : UIView

@property (nonatomic, weak) id<NaviLeftDidSelectDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
