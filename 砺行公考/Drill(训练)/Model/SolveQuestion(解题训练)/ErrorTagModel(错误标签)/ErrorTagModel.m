//
//  ErrorTagModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/10.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ErrorTagModel.h"

@implementation ErrorTagModel
StringWidth();

- (CGFloat)tagWidth {
    CGFloat width = [self calculateRowWidth:self.tagString withFont:14];
    return width;
}
@end
