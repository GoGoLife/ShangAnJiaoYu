//
//  MyOrderFooterView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MYORDERTYPE) {
    MYORDERTYPE_ALL = 0,
    MYORDERTYPE_WAITPAY,
    MYORDERTYPE_WAITPUSH,
    MYORDERTYPE_WAITPULL,
    MYORDERTYPE_WAITEVALUATE
};

@protocol MyOrderFooterViewDelegate <NSObject>

- (void)touchButtonTargetAction:(NSString *)buttonTitle;

@end

@interface MyOrderFooterView : UIView

@property (nonatomic, assign) MYORDERTYPE type;

@property (nonatomic, strong) UILabel *shop_finish_content;

@property (nonatomic, weak) id<MyOrderFooterViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withActionButtonTitlesArray:(NSArray *)titles;

@end

NS_ASSUME_NONNULL_END
