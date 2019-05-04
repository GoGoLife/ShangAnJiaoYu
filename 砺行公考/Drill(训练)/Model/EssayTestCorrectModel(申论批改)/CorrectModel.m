//
//  CorrectModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/24.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CorrectModel.h"
#import "GlobarFile.h"

@implementation CorrectModel

- (CGFloat)question_height {
    CGFloat height = [self calculateRowHeight:self.question_string fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    _question_height = height + 80.0;
    return _question_height;
}

//- (NSString *)finish_text_string {
//    NSArray *replace_array = @[@"①", @"②", @"③", @"④", @"⑤", @"⑥", @"⑦", @"⑧", @"⑨", @"⑩",
//                               @"⑪", @"⑫", @"⑬", @"⑭", @"⑮", @"⑯", @"⑰", @"⑱", @"⑲", @"⑳",
//                               @"㉑", @"㉒", @"㉓", @"㉔", @"㉕", @"㉖", @"㉗", @"㉘", @"㉙", @"㉚",
//                               @"㉛", @"㉜", @"㉝", @"㉞", @"㉟", @"㊱", @"㊲", @"㊳", @"㊴", @"㊵",
//                               @"㊶", @"㊷", @"㊸", @"㊹", @"㊺", @"㊻", @"㊼", @"㊽", @"㊾", @"㊿"];
//    NSString *finish = @"";
//    NSInteger index = 0;
//    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:1];
//    for (NSString *string in self.text_array) {
//        NSString *index_string = @"";
//        if (index < self.text_array.count - 1) {
//            //需要拼接的字符串
//            index_string = [string stringByAppendingString:replace_array[index]];
//            [temp addObject:replace_array[index]];
//        }else {
//            index_string = string;
//        }
//        finish = [finish stringByAppendingString:index_string];
//        index++;
//    }
//    _finish_text_string = finish;
//    self.replace_array = [temp copy];
//    return _finish_text_string;
//}

- (NSArray *)replace_array {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in self.correct_array) {
        [array addObject:dic[@"logo_"]];
    }
    _replace_array = [array copy];
    return _replace_array;
}

StringHeight()
- (CGFloat)finish_text_height {
    CGFloat height = [self boundingRectWithSize:CGSizeMake(SCREENBOUNDS.width - 40, 0) WithStr:self.text_string andFont:SetFont(14) andLinespace:10.0];
    _finish_text_height = height + 140;
    return _finish_text_height;
}


//求有行间距的label高度
- (CGFloat)boundingRectWithSize:(CGSize)size WithStr:(NSString*)string andFont:(UIFont *)font andLinespace:(CGFloat)space {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    CGSize retSize = [string boundingRectWithSize:size
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    
    return retSize.height;
}

@end
