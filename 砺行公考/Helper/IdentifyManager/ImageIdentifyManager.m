//
//  ImageIdentifyManager.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/8.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ImageIdentifyManager.h"
#import <AipOcrSdk/AipOcrSdk.h>

@implementation ImageIdentifyManager {
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

+ (instancetype)sharedManager {
    static ImageIdentifyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        manager = [[super allocWithZone:NULL] init];
        NSLog(@"1111111111111");
    });
    return manager;
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [ImageIdentifyManager sharedManager];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [ImageIdentifyManager sharedManager];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [ImageIdentifyManager sharedManager];
}

- (void)createInstanceCurrentVC:(UIViewController *)currentVC {
    NSLog(@"2222222222222");
    [[AipOcrService shardService] authWithAK:@"hE0URYTQodDaRkayKuaGYfB3" andSK:@"t01n3e79j83ted0FBFzl1MFW9gPrgfcG"];
    
    [self configCallback:currentVC];
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextAccurateFromImage:image
                                                      withOptions:options
                                                   successHandler:self->_successHandler
                                                      failHandler:self->_failHandler];
        
    }];
    [currentVC presentViewController:vc animated:YES completion:nil];
    
}

- (void)configCallback:(UIViewController *)currentVC {
    __weak typeof(currentVC) weakSelf = currentVC;
    __weak typeof(self) WeakSelf = self;
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
//        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        __strong typeof(WeakSelf) strongSelf = WeakSelf;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if ([strongSelf->_delegate respondsToSelector:@selector(returnIdentifyString:)]) {
                    [strongSelf->_delegate returnIdentifyString:message];
                }
            }];
        }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"识别失败 === %@", error);
        __strong typeof(WeakSelf) strongSelf = WeakSelf;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if ([strongSelf->_delegate respondsToSelector:@selector(returnIdentifyString:)]) {
                    [strongSelf->_delegate returnIdentifyString:@"识别失败"];
                }
            }];
        }];
        
        
    };
}

@end
