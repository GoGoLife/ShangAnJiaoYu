//
//  AnswerModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AnswerModel.h"
#import "GlobarFile.h"

@implementation AnswerModel
StringHeight()

//- (NSMutableAttributedString *)answer_content {
//
//////    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:answer_content];
////    if (![self.answer_content_image isEqualToString:@""]) {
////        //base64图片数据转image
////        NSLog(@"----------------------");
////        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.answer_content_image]];
////        UIImage *image = [UIImage imageWithData:imageData];
////
////        NSTextAttachment *imageText = [[NSTextAttachment alloc] init];
////        imageText.image = image;
////        imageText.bounds = FRAME(0, 20, 40, 40);
////        //创建可携带图片的富文本
////        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:imageText];
////        [_answer_content insertAttributedString:string atIndex:_answer_content.length];
////    }
//
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.answer_content_image]];
//    UIImage *image = [UIImage imageWithData:imageData];
//
//    NSTextAttachment *imageText = [[NSTextAttachment alloc] init];
//    imageText.image = image;
//    imageText.bounds = FRAME(0, 20, 40, 40);
//    //创建可携带图片的富文本
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:imageText];
//    [_answer_content insertAttributedString:string atIndex:_answer_content.length];
//    return _answer_content;
//}


//- (CGFloat)answer_height {
//    if ([self.answer_content_image isEqualToString:@""]) {
//        NSString *string = [self.answer_content string];
//        CGFloat height = [self calculateRowHeight:[NSString stringWithFormat:@"%@", string] fontSize:14 withWidth:SCREENBOUNDS.width - 90];
//        return height + 40;
//    }
//    CGFloat height = [self calculateRowHeight:[NSString stringWithFormat:@"%@", self.answer_content] fontSize:14 withWidth:SCREENBOUNDS.width - 90];
//    return height;
//}
//
//- (CGFloat)answer_height_second {
//    if ([self.answer_content_image isEqualToString:@""]) {
//        NSString *string = [self.answer_content string];
//        CGFloat height = [self calculateRowHeight:[NSString stringWithFormat:@"%@", string] fontSize:14 withWidth:SCREENBOUNDS.width - 190];
//        return height + 40;
//    }
//    CGFloat height = [self calculateRowHeight:[NSString stringWithFormat:@"%@", self.answer_content] fontSize:14 withWidth:SCREENBOUNDS.width - 190];
//    return height;
//}

@end
