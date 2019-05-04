//
//  MOLoadHTTPManager.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/2.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "MOLoadHTTPManager.h"
#import <AFNetworking.h>
#import "GlobarFile.h"
#import "AppDelegate.h"
#import <Hyphenate/Hyphenate.h>

//com.lixingTest.phone

#define BaseUrl @"http://47.110.40.243:9092"

@implementation MOLoadHTTPManager

//http://192.168.0.192:9091          赵稳
//http://47.110.40.243:9091          阿里云
//http://192.168.0.138:9091          彭伟
//http://47.99.181.42:9091           正式服务器

//http://192.168.0.194:9092          赵稳本地  新地址
//http://47.110.40.243:9092          阿里云  新地址

//com.lixing.aliyun  bundle id 阿里云
//com.lixing.phone  bundle id  本地

/** Post 请求 */
+(void)PostHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock {
    url = [BaseUrl stringByAppendingString:url];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    NSString *app_token = [[NSUserDefaults standardUserDefaults] objectForKey:APP_TOKEN];
    req.timeoutInterval= 15;//[[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:app_token forHTTPHeaderField:@"app_token"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if ([responseObject[@"state"] integerValue] == 9) {
                NSLog(@"未登陆!!!!!!");
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:APP_TOKEN];
                //环信登出操作
                [[EMClient sharedClient] logout:YES];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate setLoginVCToWindowRoot];
            }
            
//            NSLog(@"Reply JSON: %@", responseObject);
            /** 这里是处理事件的回调 */
            if (successBlock) {
                successBlock(responseObject);
            }
            
            //检测环信是否登录  若没有登录  则登录
//            if (![[EMClient sharedClient] isLoggedIn]) {
//                NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
//                [[EMClient sharedClient] loginWithUsername:account password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
//                    if (!aError) {
//                        NSLog(@"登录成功！！！");
//                    }else {
//                        NSLog(@"aError === %@", aError.errorDescription);
//                    }
//                }];
//            }
        } else {
            NSLog(@"error: %@", error);
            /** 这里是处理事件的回调 */
            if (failureBlock) {
                failureBlock(error);
            }
        }
    }] resume];
}



///压缩图片
+ (NSData *)imageCompressToData:(UIImage *)image{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length>300*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(image, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(image, 0.5);
        }else if (data.length>300*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(image, 0.9);
        }
    }
    return data;
}

/** Post 请求   表单 */
+(void)PostHttpFormWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic imageArray:(NSArray *)imageArray SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock {
    
    url = [BaseUrl stringByAppendingString:url];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //表单提交
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    [manage.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manage.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    NSString *app_token = [[NSUserDefaults standardUserDefaults] objectForKey:APP_TOKEN];
    [manage.requestSerializer setValue:app_token forHTTPHeaderField:@"app_token"];
    
    __weak typeof(self) weakSelf = self;
    [manage POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *image in imageArray) {
            NSData *imageData = [weakSelf imageCompressToData:image];
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file1111.png" mimeType:@"image/jpg/png"];
            NSLog(@"formdata === %@", formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        * 这里是处理事件的回调
        if (successBlock) {
            successBlock(responseDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /** 这里是处理事件的回调 */
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}




@end
