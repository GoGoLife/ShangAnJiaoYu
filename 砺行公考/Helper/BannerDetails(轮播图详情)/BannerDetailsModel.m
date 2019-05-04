//
//  BannerDetailsModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/21.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BannerDetailsModel.h"
#import "GlobarFile.h"

@implementation BannerDetailsModel

StringHeight()
- (CGFloat)content_height {
    if ([self.type isEqualToString:@"3"]) {
        CGFloat height = [self GetImageSizeWithURL:self.content].height;
        CGFloat scale = (SCREENBOUNDS.width - 40) / [self GetImageSizeWithURL:self.content].width;
        return height * scale + 20.0;
    }else if ([self.type isEqualToString:@"2"]) {
        //文本
        return [self calculateRowHeight:self.content fontSize:14 withWidth:SCREENBOUNDS.width - 40] + 20;
    }else {
        //标题
        return [self calculateRowHeight:self.content fontSize:16 withWidth:SCREENBOUNDS.width - 40] + 20;
    }
}

- (CGSize)GetImageSizeWithURL:(id)imageURL {
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]) {
        URL = imageURL;
    }
    
    if([imageURL isKindOfClass:[NSString class]]) {
        URL = [NSURL URLWithString:imageURL];
    }
    
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];
    return CGSizeMake(image.size.width, image.size.height);
}

@end
