//
//  ChooseDefaultContentViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ChooseContentType) {
    ChooseContentType_YinYan = 0,
    ChooseContentType_FenXi,
    ChooseContentType_ChengJie,
    ChooseContentType_DuiCe,
    ChooseContentType_JieWei
};

@interface ChooseDefaultContentViewController : BaseViewController

@property (nonatomic, assign) ChooseContentType type;

@end

NS_ASSUME_NONNULL_END
