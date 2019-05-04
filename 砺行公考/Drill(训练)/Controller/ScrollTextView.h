//
//  ScrollTextView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/8/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollTextViewDelegate <NSObject>

- (void)touchScrollTextActionWithIndex:(NSDictionary *)indexDic;

@end

@interface ScrollTextView : UIView

- (instancetype)initWithFrame:(CGRect)frame whitTextArray:(NSArray *)array;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, weak) id<ScrollTextViewDelegate> delegate;

@end
