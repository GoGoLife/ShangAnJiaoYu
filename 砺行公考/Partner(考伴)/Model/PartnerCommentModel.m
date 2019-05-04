//
//  PartnerCommentModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PartnerCommentModel.h"
#import "GlobarFile.h"

@implementation PartnerCommentModel

- (NSString *)finish_content {
    if ([self.parent_user_id_ isEqualToString:@""]) {
        _finish_content = self.content_;
    }else {
        _finish_content = [NSString stringWithFormat:@"回复 %@：%@", self.parent_name_, self.content_];
    }
    return _finish_content;
}

StringHeight()
- (CGFloat)comment_height {
    CGFloat height = [self calculateRowHeight:self.finish_content fontSize:14 withWidth:SCREENBOUNDS.width - 40 - 40 - 10];
    return height + 45.0;
}

@end
