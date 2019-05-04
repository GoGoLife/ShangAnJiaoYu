//
//  CenterNaviView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NaviCenterDidSelectDelegate <NSObject>

- (void)centerViewSelectRow:(NSInteger)index DataString:(NSString *)data;

@end

@interface CenterNaviView : UIView

@property (nonatomic, strong) NSArray *center_data_array;

@property (nonatomic, weak) id<NaviCenterDidSelectDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
