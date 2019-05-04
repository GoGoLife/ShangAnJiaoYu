//
//  TcpClientLib.h
//  TcpClientDemo02
//
//  Created by SQ.Li on 2019/3/13.
//  Copyright © 2019 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lib.h"

void callback_func(const char * data, int cid);

NS_ASSUME_NONNULL_BEGIN

@interface TcpClientLib : NSObject

-(int)connect:(NSString *)ip port:(int)port;

-(NSString *)send:(int)sockfd data:(NSString *)data timeout:(int)timeout;

-(void)disconnect:(int)sid;

-(void)async_send:(int)sockfd data:(NSString *)data;

-(void)add_event;

-(void)async_receive:(int) cid;

@end


NS_ASSUME_NONNULL_END
