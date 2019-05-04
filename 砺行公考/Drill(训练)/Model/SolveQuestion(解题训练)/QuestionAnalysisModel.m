//
//  QuestionAnalysisModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "QuestionAnalysisModel.h"
#import "ErrorTagModel.h"

@implementation QuestionAnalysisModel
StringHeight();

/**
 题干文本的高度

 @return 题目文本高度
 */
- (CGFloat)questionStringHeight {
    CGFloat height = [self calculateRowHeight:self.questionString fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    return height;
}

//根据图片数量返回图片布局高度
- (CGFloat)questionImageHeight {
    CGFloat height = (SCREENBOUNDS.width - 100) / 4;
    NSInteger count = self.question_image_array.count;
    //整行
    NSInteger line = count / 4;
    //余数行
    NSInteger line_more = count % 4;
    if (line_more > 0) {
        line++;
    }
   return line * height + (line - 1) * 20 + 40;
}


/**
 返回题干高度+图片高度

 @return 返回题干高度+图片高度
 */
- (CGFloat)questionStringAndImageHeight {
    _questionStringAndImageHeight = self.questionStringHeight + [self questionImageHeight];
    return _questionStringAndImageHeight;
}

- (NSString *)answerAnalysisString {
    return [@"解析步骤：\n\n" stringByAppendingString:_answerAnalysisString];
}

- (CGFloat)answerAnalysisString_height {
    CGFloat height = [self calculateRowHeight:self.answerAnalysisString fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    return height;
}

- (NSArray<ErrorTagModel *> *)errorTagArray {
    if ([self.error_label_list isEqualToString:@""]) {
        ErrorTagModel *tagModel = [[ErrorTagModel alloc] init];
        tagModel.tagString = @"添加";
        return @[tagModel];
    }
    NSArray *error_tag = [self.error_label_list componentsSeparatedByString:@","];
    NSMutableArray *error_tag_arr = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < error_tag.count; index++) {
        ErrorTagModel *tagModel = [[ErrorTagModel alloc] init];
        tagModel.tagString = error_tag[index];
        [error_tag_arr addObject:tagModel];
    }
    ErrorTagModel *tagModel = [[ErrorTagModel alloc] init];
    tagModel.tagString = @"添加";
    [error_tag_arr addObject:tagModel];
    _errorTagArray = [error_tag_arr copy];
    return _errorTagArray;
}

- (NSString *)finish_function_string {
    NSString *finish = @"砺行方法：\n\n";
    for (NSInteger index = 0; index < self.analysis_function_array.count; index++) {
        NSString *content = [NSString stringWithFormat:@"%@\n", self.analysis_function_array[index][@"name_"]];
        finish = [finish stringByAppendingString:content];
    }
    _finish_function_string = finish;
    return _finish_function_string;
}

- (CGFloat)finish_function_height {
    CGFloat height = [self calculateRowHeight:self.finish_function_string fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    _finish_function_height = height;
    return _finish_function_height;
}

@end
