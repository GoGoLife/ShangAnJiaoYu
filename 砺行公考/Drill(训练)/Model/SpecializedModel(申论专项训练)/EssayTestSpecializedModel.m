//
//  EssayTestSpecializedModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/17.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "EssayTestSpecializedModel.h"
#import "GlobarFile.h"

@implementation EssayTestSpecializedModel

StringHeight()
- (NSString *)finish_content {
    NSString *finish = @"";
    for (NSString *string in self.specialized_content_list) {
        finish = [finish stringByAppendingString:string];
    }
    _finish_content = finish;
    return _finish_content;
}

- (NSString *)finish_prasing {
    NSString *finish = @"";
    for (NSString *string in self.specialized_parsing_list) {
        finish = [finish stringByAppendingString:string];
    }
    _finish_prasing = finish;
    return _finish_prasing;
}

- (CGFloat)finish_content_height {
    CGFloat height = [self calculateRowHeight:self.finish_content fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    _finish_content_height = height;
    return _finish_content_height;
}

@end
