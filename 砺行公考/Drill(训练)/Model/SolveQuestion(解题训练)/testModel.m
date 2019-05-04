//
//  testModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "testModel.h"
#import "GlobarFile.h"

@implementation testModel

StringWidth();
- (CGFloat)tag_width {
    CGFloat width = [self calculateRowWidth:self.tagString withFont:10];
    return width;
}

@end
