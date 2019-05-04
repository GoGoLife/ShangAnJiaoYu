//
//  ShopDetailsModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/26.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShopDetailsModel.h"
#import "GlobarFile.h"

@implementation ShopDetailsModel

StringHeight()
- (CGFloat)shop_details_string_height {
    CGFloat height = [self calculateRowHeight:self.shop_details_string fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    _shop_details_string_height = height;
    return _shop_details_string_height;
}

@end


/**
 评论
 */
@implementation ShopCommentModel

StringHeight()
- (CGFloat)comment_cell_height {
    CGFloat content_height = [self calculateRowHeight:self.comment_string fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    CGFloat collection_height = [self returnCollectionViewHeigth];
    _comment_cell_height = content_height + collection_height + 100;
    return _comment_cell_height;
}

//根据图片数量  返回collectionview的高度
- (CGFloat)returnCollectionViewHeigth {
    NSInteger count = self.image_array.count;
    //返回整数行
    NSInteger forIndex = count / 3;
    //是否需要在整数的基础上  多加一行
    NSInteger endIndex = count % 3;
    //图片大小的高度
    CGFloat itemHeight = (SCREENBOUNDS.width - 40 - 10 * 2) / 3;
    CGFloat height = 0.0;
    if (endIndex > 0) {
        height = itemHeight * (forIndex + 1) + 20 + forIndex * 10;
    }else {
        height = itemHeight * forIndex + 20 + (forIndex - 1) * 10;
    }
    return height;
}

@end
