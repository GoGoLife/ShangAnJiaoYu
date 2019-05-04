//
//  ChatMessageModel.m
//  weihouDemo
//
//  Created by 钟文斌 on 2019/2/14.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ChatMessageModel.h"

@implementation ChatMessageModel

- (CGFloat)returnCellHeight {
    return 40.0;
}

- (CGFloat)returnStringWidth {
    return 0.0;
}

- (NSMutableAttributedString *)returnFinishShowMessage {
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:@"xiaoming:发送了一条消息"];
    return attributed;
}

@end
