//
//  ChangeBookIndexView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/11.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChangeBookIndexViewDelegate <NSObject>

- (void)ChangeBookIndexAction:(NSInteger)changeType;

@end

@interface ChangeBookIndexView : UIView

@property (nonatomic, weak) id<ChangeBookIndexViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
