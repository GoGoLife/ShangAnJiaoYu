//
//  XLChannelLabel.m
//  XLNewsBaseFoundation
//
//  Created by 薛林 on 16/6/21.
//  Copyright © 2016年 xuelin. All rights reserved.
//

#import "XLChannelLabel.h"

@implementation XLChannelLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //文字居中
        self.textAlignment = NSTextAlignmentCenter;
        //字体大小
        self.font = [UIFont systemFontOfSize:20];
        
        self.userInteractionEnabled = YES;
        
        self.scale = 0;
    }
    return self;
}

//重设比例
- (void)setScale:(float)scale{
    _scale = scale;
    
    self.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1.0];
    
    //2.让其tranform的scale发生变化
    //0.8 ~ 1.0
    CGFloat lastScale = 0.8 + (1 - 0.8) * scale;
    self.transform = CGAffineTransformMakeScale(lastScale, lastScale);
}

@end
