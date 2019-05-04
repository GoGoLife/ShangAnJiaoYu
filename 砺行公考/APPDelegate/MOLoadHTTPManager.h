//
//  MOLoadHTTPManager.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/2.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SuccessBlock) (id responseObject);

typedef void (^FailedBlock) (id error);

@interface MOLoadHTTPManager : NSObject

/** Post 请求 */
+(void)PostHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock;

/** Get 请求 */
//+(void)GetHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock;

/** Post 请求   表单 */
+(void)PostHttpFormWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic imageArray:(NSArray *)imageArray SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock;

///压缩图片
+ (NSData *)imageCompressToData:(UIImage *)image;

@end
