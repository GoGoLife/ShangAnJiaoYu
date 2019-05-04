//
//  CommentModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//
#import "CommentModel.h"
#import "GlobarFile.h"

@implementation CommentModel
StringHeight()

- (CGFloat)header_view_height {
    CGFloat content_height = [self calculateRowHeight:self.contentString fontSize:14 withWidth:SCREENBOUNDS.width - 20 - 40 - 10 - 20];
    _header_view_height = content_height + 60;
    return _header_view_height;
}

@end

@implementation CommentCellModel
StringHeight()

- (NSString *)finish_comment_string {
    _finish_comment_string = [NSString stringWithFormat:@"%@回复%@:%@", self.cell_user_name, self.cell_parent_name, self.cell_comment_content];
    return _finish_comment_string;
}

- (CGFloat)cell_height {
    CGFloat content_height = [self calculateRowHeight:self.finish_comment_string fontSize:14 withWidth:SCREENBOUNDS.width - 20 - 40 - 10 - 20 - 20];
    _cell_height = content_height + 40.0;
    return _cell_height;
}

@end
