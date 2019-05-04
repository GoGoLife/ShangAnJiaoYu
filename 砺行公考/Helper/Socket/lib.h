//
//  lib.h
//  TcpClientDemo02
//
//  Created by SQ.Li on 2019/3/13.
//  Copyright © 2019 macbook. All rights reserved.
//

#ifndef lib_h
#define lib_h

#include <stdio.h>

#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

char * int2str(int len);
int str2int(char * data);

int str2int(char * data);

int connect_server(char *ip, int port);

void delete_connect(int sockfd);

char * send_data(int sockfd, char * data, int timeout);

void add_eventHandler(void (* callback_func)(const char * msg, int cid));

//线程参数
typedef struct chat_thread_parameter {
    
    int connectfd;
    
} ChatThreadParameter;

typedef struct fire_thread_parameter {
    
    int connectfd;
    
    char * data;
    
} FireThreadParameter;

void async_send(int sockfd, char * data);

void async_receive(int connectfd);

void * async_recv_work(void * param);

void * fire_event(void * param);

char * lsq_strcat(char * des, char * src);

char * lsq_strsub(char * str, int num);

#endif /* lib_h */
