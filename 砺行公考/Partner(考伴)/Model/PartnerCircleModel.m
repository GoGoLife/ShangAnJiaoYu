//
//  PartnerCircleModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PartnerCircleModel.h"
#import "GlobarFile.h"

@implementation PartnerCircleModel

- (NSString *)user_name_ {
    if ([_user_name_ isEqualToString:@""]) {
        return self.login_name_;
    }else {
        return _user_name_;
    }
}

//整理item的size   根据图片的张数来确定
- (CGSize)formatItemSize {
    CGSize item_size = CGSizeZero;
    NSInteger count = self.moment_picture_url_array.count;
    if (count == 0) {
        item_size = CGSizeZero;
    }else if (count == 1) {
        //屏幕上的图片显示的最大宽度
        CGFloat width = SCREENBOUNDS.width - 40;
        item_size = CGSizeMake(width, 300.0);
    }else {
        CGFloat width = (SCREENBOUNDS.width - 40 - 20) / 3;
        item_size = CGSizeMake(width, width);
    }
    return item_size;
}

- (CGFloat)content_height {
    CGFloat content_height = [self calculateRowHeight:self.content_ fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    return content_height;
}

StringHeight()
- (CGFloat)infomation_height {
    _infomation_height = 0.0;
//    CGFloat content_height = [self calculateRowHeight:self.content_ fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    //count > 1 item的height
    CGFloat item_height = [self formatItemSize].height; //(SCREENBOUNDS.width - 40 - 20) / 3;
    NSInteger count = self.moment_picture_url_array.count;
    if (count == 0) {
        _infomation_height = self.content_height + 120.0;
    }else if (count == 1) {
        _infomation_height = self.content_height + 120.0 + item_height + 20.0;
    }else if (count >= 2 && count <= 3) {
        _infomation_height = self.content_height + 120.0 + item_height + 20.0;
    }else if (count > 3 && count <= 6) {
        _infomation_height = self.content_height + 120.0 + item_height * 2 + 20.0 + 10.0;
    }else if (count > 6 && count <= 9) {
        _infomation_height = self.content_height + 120.0 + item_height * 3 + 20.0 + 20.0;
    }
    return _infomation_height;
}
@end
