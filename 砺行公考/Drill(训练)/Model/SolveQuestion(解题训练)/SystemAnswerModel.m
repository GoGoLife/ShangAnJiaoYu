//
//  SystemAnswerModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SystemAnswerModel.h"
#import "GlobarFile.h"

@implementation SystemAnswerModel
StringHeight()

- (CGFloat)content_string_height {
    CGFloat height = [self calculateRowHeight:self.content_string fontSize:14 withWidth:SCREENBOUNDS.width - 80];
    return height;
}



@end
