//
//  ImageIdentifyManager.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/8.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImageIdentifyManagerDelegate <NSObject>

- (void)returnIdentifyString:(NSString *)text;

@end

@interface ImageIdentifyManager : NSObject

+ (instancetype)sharedManager;

- (void)createInstanceCurrentVC:(UIViewController *)currentVC;

@property (nonatomic, weak) id<ImageIdentifyManagerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
