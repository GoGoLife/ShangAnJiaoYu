//
//  ErrorBookNaviViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ErrorBookNaviDelegate <NSObject>

- (void)returnSearchData:(NSDictionary *)data;

@end

@interface ErrorBookNaviViewController : BaseViewController

@property (nonatomic, weak) id<ErrorBookNaviDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
