//
//  SumUpModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SumUpModel.h"
#import "GlobarFile.h"

@implementation SumUpModel
StringHeight()

- (CGFloat)sum_up_string_height {
    CGFloat height = [self calculateRowHeight:self.sum_up_string fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    return height;
}

@end
