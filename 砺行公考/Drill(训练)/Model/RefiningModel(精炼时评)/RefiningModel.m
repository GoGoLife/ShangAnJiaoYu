//
//  RefiningModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "RefiningModel.h"
#import "GlobarFile.h"

@implementation RefiningModel
StringHeight()
- (CGFloat)content_string_height {
    return [self calculateRowHeight:self.content_string fontSize:16 withWidth:SCREENBOUNDS.width - 90] + 70.0;
}

- (CGFloat)teacher_review_height {
    return [self calculateRowHeight:self.teacher_review fontSize:16 withWidth:SCREENBOUNDS.width - 40] + 50.0;
}

@end


@implementation RefiningContentModel
StringHeight()
- (CGFloat)content_height {
    if (self.publish_type == 1) {
        return 260.0 + 20;
    }else {
        return [self returnContentHeight:self.content withFont:16];
    }
}

- (CGFloat)returnContentHeight:(NSString *)content withFont:(NSInteger)font {
    UITextView *textview = [[UITextView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width - 40, 10.0)];
    textview.font = SetFont(font);
    textview.text = content;
    return textview.contentSize.height + 20.0;
}

@end

@implementation RefiningSonModel

StringHeight()
- (CGFloat)son_height {
    return [self calculateRowHeight:self.son_content fontSize:16 withWidth:SCREENBOUNDS.width - 40] + 20.0;
}

@end
