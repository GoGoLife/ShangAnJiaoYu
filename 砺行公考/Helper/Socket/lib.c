//
//  lib.c
//  TcpClientDemo02
//
//  Created by SQ.Li on 2019/3/13.
//  Copyright © 2019 macbook. All rights reserved.
//

#include "lib.h"
#include <pthread.h>

char * int2str(int len){
    char * str = (char *)malloc(sizeof(char) * 4);
    
    int x = sprintf(str, "%4d", len);
    
    char * s = (char *)malloc(sizeof(char) * 4);
    
    for (int i = 0; i < 4; i++) {
        int index = 4 - i;
        
        char c = *(str + 4 - i - 1);
        
        if (c == ' ') {
            int x = 48;
            
            char a = (char)x;
            
            s[4 - i - 1] = a;
        } else {
            s[4 - i - 1] = c;
        }
    }
    
    return s;
}

int str2int(char * data) {
    int x = atoi(data);
    
    return x;
}

int connect_server(char *ip, int port){
    int sockfd = socket(PF_INET, SOCK_STREAM, 0);
    
    struct sockaddr_in server;
    bzero(&server, sizeof(server));
    server.sin_family = PF_INET;
    
    server.sin_port = htons(port);
    
    inet_aton(ip, &(server.sin_addr));
    
    struct hostent * he;
    
    he = gethostbyname(ip);
    
    server.sin_addr.s_addr = inet_addr(ip);
    
    int cid = connect(sockfd, (struct sockaddr *)&server, sizeof(server));
    
    return sockfd;
}

void delete_connect(int sockfd){
    close(sockfd);
}

char * send_data(int sockfd, char * data, int timeout){
    char * result;
    
    struct timeval timeval_1 = {120, 0};
    
    int send_len = strlen(data);
    
    char * send_len_str = int2str(send_len);
    
    int char_len = send_len + 4;
    
    char * send_data_str = (char *)malloc(sizeof(char) * (char_len));
    
    memset(send_data_str, 0, char_len);
    
    strcat(send_data_str, send_len_str);
    
    strcat(send_data_str, data);
    
    char * tmp_data;
    tmp_data = send_data_str;
    
    int send_num = send(sockfd, tmp_data, strlen(tmp_data), 0);
    
    free(send_data_str);
    
    setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout, sizeof(timeval_1));
    
    char buf[4] = {0};
    
    int n = recv(sockfd, buf, 4, 0);
    
    int num = str2int(buf);
    int count = 0;
    
    char * bytes_recv = (char *)malloc(sizeof(char) * num);
    memset(bytes_recv, 0, sizeof(char) * num);
    
    while (num != count) {
        int len = num - count;
        
        char * tmp_recv = (char *)malloc(sizeof(char) * len);
        
        int tmp_num = recv(sockfd, tmp_recv, len, 0);
        
        strcat(bytes_recv, tmp_recv);
        
        free(tmp_recv);
        
        count = count + tmp_num;
    }
    
    result = bytes_recv;
    
    return result;
}

void async_send(int sockfd, char * data) {
    int send_len = strlen(data);
    
    char * send_len_str = int2str(send_len);
    
    int char_len = send_len + 4;
    
    char * send_data_str = (char *)malloc(sizeof(char) * (char_len));
    
    memset(send_data_str, 0, char_len);
    
    strcat(send_data_str, send_len_str);
    
    strcat(send_data_str, data);
    
    char * tmp_data;
    tmp_data = send_data_str;
    
    int send_num = send(sockfd, tmp_data, strlen(tmp_data), 0);
    
    free(send_data_str);
}

//函数指针
void (* event_func)(const char * msg, int cid);

//h注册回调函数
void add_eventHandler(void (* callback_func)(const char * msg, int cid)) {
    event_func = callback_func;
}

void async_receive(int connectfd) {
    
    ChatThreadParameter * parameter = (ChatThreadParameter *)malloc(sizeof(ChatThreadParameter));
    parameter->connectfd = connectfd;
    
    //启动线程接收数据
    pthread_t thd;
    pthread_create(&thd, NULL, async_recv_work, (void *)parameter);
}

void * async_recv_work(void * param) {
    
    ChatThreadParameter * parameter = (ChatThreadParameter *)param;
    
    int connectfd = parameter->connectfd;
    
    int int_check = 1;
    
    while (int_check == 1) {
        char buf[4] = {0};
        
        int n = recv(connectfd, buf, 4, 0);
        
        if (n < 0) {
            int_check = 0;
            
            break;
        }
        
        int num = str2int(buf);
        int count = 0;
        
        char * bytes_recv = (char *)malloc(sizeof(char) * num);
        //
        memset(bytes_recv, 0, sizeof(char) * num);
        
        while (num != count) {
            
            int len = num - count;
            
            char * tmp_recv = (char *)malloc(sizeof(char) * len);
            
            int tmp_num = recv(connectfd, tmp_recv, len, 0);
            
            printf("Socket接收数据长度：%d, 接收数据：%s\n", tmp_num, tmp_recv);
            
            char * temp_recv = lsq_strsub(tmp_recv, tmp_num);
            
            char * temp_recv_data = lsq_strcat(bytes_recv, temp_recv);
            
            count = count + tmp_num;
            
            free(tmp_recv);
            free(bytes_recv);
            free(temp_recv);
            
            bytes_recv = temp_recv_data;
        }
        
        //回调通知外界
        FireThreadParameter * file_param = (FireThreadParameter *)malloc(sizeof(FireThreadParameter));
        
        file_param->connectfd = connectfd;
        file_param->data = bytes_recv;
        
        pthread_t thd;
        pthread_create(&thd, NULL, fire_event, (void *)file_param);
    }
    
    return NULL;
}

void * fire_event(void * param) {
    FireThreadParameter * parameter = (FireThreadParameter *)param;
    
    char * msg = parameter->data;
    int cid = parameter->connectfd;
    
    event_func(msg, cid);
    
    return NULL;
}

char * lsq_strsub(char * str, int num) {
    char * result;
    
    result = (char *)malloc(sizeof(char) * (num + 1));
    
    int i = 0;
    
    while (i != num) {
        
        *(result + i) = *(str + i);
        
        i = i + 1;
    }
    
    *(result + i) = '\0';
    
    return result;
}

char * lsq_strcat(char * des, char * src) {
    
    char * result;
    
    int length = strlen(des);
    
    int len = strlen(src);
    int i = len;
    
    char * temp = (char *)malloc(sizeof(char) * (len + length + 1));
    
    
    int x = length + len;
    int y = 0;
    while (y <= length) {
        
        if (*(des + y) == '\0') {
            break;
        } else {
            *(temp + y) = *(des + y);
            y = y + 1;
        }
    }
    
    int z = 0;
    while (z <= len) {
        
        *(temp + y + z) = *(src + z);
        z = z + 1;
    }
    
    *(temp + y + z) = '\0';
    
    //free(des);
    
    result = temp;
    
    return result;
}



