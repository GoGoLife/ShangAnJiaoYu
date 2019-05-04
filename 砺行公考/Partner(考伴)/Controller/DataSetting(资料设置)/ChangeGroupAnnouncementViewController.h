//
//  ChangeGroupAnnouncementViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeGroupAnnouncementViewController : BaseViewController

@property (nonatomic, copy) void(^returnAnnouncementContent)(NSString *content);

@end

NS_ASSUME_NONNULL_END
