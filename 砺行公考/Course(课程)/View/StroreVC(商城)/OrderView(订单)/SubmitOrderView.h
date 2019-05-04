//
//  SubmitOrderView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SubmitOrderViewDelegate <NSObject>

//点击提交订单按钮执行的方法
- (void)touchSubmitButtonAction;

@end

@interface SubmitOrderView : UIView

@property (nonatomic, strong) UIButton *submit_button;

@property (nonatomic, strong) UILabel *price_label;

@property (nonatomic, strong) UILabel *left_label;

//全选按钮
@property (nonatomic, strong) UIButton *all_choose_button;

//优惠
@property (nonatomic, strong) UILabel *discounts_label;

@property (nonatomic, assign) BOOL isUpdateLayout;

@property (nonatomic, weak) id<SubmitOrderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
