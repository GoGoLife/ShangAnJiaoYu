//
//  TcpClientLib.m
//  TcpClientDemo02
//
//  Created by SQ.Li on 2019/3/13.
//  Copyright © 2019 macbook. All rights reserved.
//

#import "TcpClientLib.h"
#import "CallBack.h"

void callback_func(const char * data, int cid) {
    
    CallBack * cbo = [[CallBack alloc] init];
    
    NSString * result = [[NSString alloc] initWithCString:data encoding:NSUTF8StringEncoding];
    
    [cbo Invoke:result cid:cid];
}

@implementation TcpClientLib

-(int)connect:(NSString *)ip port:(int)port{
    
    const char * ip_1 = [ip UTF8String];
    
    int sid = connect_server(ip_1, port);
    
    return sid;
}

-(NSString *)send:(int)sockfd data:(NSString *)data timeout:(int)timeout{
    
    const char * send_str = [data UTF8String];
    
    char * recv_data = send_data(sockfd, send_str, timeout);
    
    NSString * result = [[NSString alloc] initWithCString:recv_data encoding:NSUTF8StringEncoding];
    
    return result;
}

-(void)disconnect:(int)sid{
    delete_connect(sid);
}

-(void)async_send:(int)sockfd data:(NSString *)data {
    
    const char * send_str = [data UTF8String];
    
    async_send(sockfd, send_str);
}

-(void)async_receive:(int) cid {
    async_receive(cid);
}

-(void)add_event {
    add_eventHandler(callback_func);
}

@end
