//
//  QuestionModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "QuestionModel.h"
#import "GlobarFile.h"

@implementation QuestionModel


StringHeight()

/**
 题目文本的高度

 @return 高度
 */
- (CGFloat)question_content_height {
    CGFloat question_content_height = [self calculateRowHeight:self.question_content fontSize:16 withWidth:SCREENBOUNDS.width - 80];
    _question_content_height = question_content_height;
    return _question_content_height;
}



- (CGFloat)question_collectionview_height {
    _question_collectionview_height = self.question_content_height + [self returnCellHeightWithImageCount];
    return _question_collectionview_height;
}

/**
 根据图片的多少
 非资料分析题目
 一排显示四张

 @return 确定图片展示内容的高度
 */
- (CGFloat)returnCellHeightWithImageCount {
    CGFloat height = 0.0;
    NSInteger count = self.question_picture_array.count;
    NSInteger index = count / 4;
    NSInteger remainder = count % 4;
    NSInteger lineNumber = remainder > 0 ? index + 1 : index;
    CGFloat itemHeight = (SCREENBOUNDS.width - 100) / 4;
    height = itemHeight * lineNumber + 20 + (lineNumber - 1) * 10;
    return height;
}

@end
