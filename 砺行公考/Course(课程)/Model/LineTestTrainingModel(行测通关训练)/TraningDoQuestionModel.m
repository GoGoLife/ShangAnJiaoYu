//
//  TraningDoQuestionModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/10.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TraningDoQuestionModel.h"
#import "GlobarFile.h"

@implementation TraningDoQuestionModel

StringHeight()
- (CGFloat)question_content_height {
    CGFloat height = [self calculateRowHeight:self.question_content fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    return height + 50.0;
}

@end


@implementation TraningAnswerModel



@end
