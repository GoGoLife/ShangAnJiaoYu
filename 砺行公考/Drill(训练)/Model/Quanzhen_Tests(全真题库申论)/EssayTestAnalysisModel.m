//
//  EssayTestAnalysisModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "EssayTestAnalysisModel.h"
#import "GlobarFile.h"

@implementation EssayTestAnalysisModel

StringHeight()
- (CGFloat)analysis_content_height {
    if ([self.Analysis_model_string isEqualToString:@"采点示范"]) {
        return 300.0;
    }else if ([self.Analysis_model_string isEqualToString:@"思维导图"] || [self.Analysis_model_string isEqualToString:@"逻辑树图"]) {
        return 300.0;
    }else {
        CGFloat height = [self calculateRowHeight:self.Analysis_content fontSize:16 withWidth:SCREENBOUNDS.width - 40] + 40.0;
        if ([self.Analysis_content isEqualToString:@""]) {
            height = 0.0;
        }
        return height;
    }
}

@end
