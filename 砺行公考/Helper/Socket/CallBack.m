//
//  CallBack.m
//  TcpClientDemo02
//
//  Created by SQ.Li on 2019/3/19.
//  Copyright © 2019 macbook. All rights reserved.
//

#import "CallBack.h"


@implementation CallBack

- (instancetype)init {
    if (self == [super init]) {
        
    }
    return self;
}

-(void)Invoke:(NSString *) data cid:(int)cid {
    NSLog(@"数据接收为：");
    NSLog(@"%@", data);
    if (data) {
        NSLog(@"11111111111");
        //注册通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VoteNotifacation" object:nil userInfo:@{@"data":data}];
    }else {
        NSLog(@"2222222222");
    }
}
@end
