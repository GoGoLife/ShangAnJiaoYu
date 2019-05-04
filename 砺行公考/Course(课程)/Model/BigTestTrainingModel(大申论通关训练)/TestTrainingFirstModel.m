//
//  TestTrainingFirstModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/18.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TestTrainingFirstModel.h"
#import "GlobarFile.h"

@implementation TestTrainingFirstModel

- (NSString *)finish_require_string {
    NSString *finish_string = @"要求：\n";
    for (NSString *string in self.question_require) {
        finish_string = [finish_string stringByAppendingString:[NSString stringWithFormat:@"%@\n", string]];
    }
    return finish_string;
}

StringHeight()
- (CGFloat)question_content_height {
    CGFloat title_height = [self calculateRowHeight:self.question_title fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    CGFloat require_height = [self calculateRowHeight:self.finish_require_string fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    CGFloat judge_title_height = [self calculateRowHeight:self.judge_title fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    return title_height + require_height + judge_title_height + 90.0;
}

- (CGFloat)judge_parsing_height {
    return [self calculateRowHeight:self.judge_parsing fontSize:14 withWidth:SCREENBOUNDS.width - 80] + 80.0;
}

@end
