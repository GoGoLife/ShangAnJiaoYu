//
//  SearchDigestViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchDigestViewController : BaseViewController

@property (nonatomic, copy) void(^returnSearchContentWithTagID)(NSString *content, NSArray *tag_id_array, NSString *type);

@end

NS_ASSUME_NONNULL_END
