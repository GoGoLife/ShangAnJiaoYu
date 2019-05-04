//
//  AddCartView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCartViewDelegate <NSObject>

- (void)touchButtonTargetAction:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AddCartView : UIView

@property (nonatomic, strong) UIButton *kf_button;

@property (nonatomic, strong) UIButton *cart_button;

@property (nonatomic, strong) UIButton *add_cart_button;

@property (nonatomic, strong) UIButton *pay_button;

@property (nonatomic, weak) id<AddCartViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
