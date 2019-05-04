//
//  BigEssayWriteContentViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WriteContentType) {
    WriteContentType_YinYan = 0,
    WriteContentType_ChengJie,
    WriteContentType_JieWei
};

@interface BigEssayWriteContentViewController : BaseViewController

@property (nonatomic, strong) NSString *default_content;

@property (nonatomic, assign) WriteContentType type;

@end

NS_ASSUME_NONNULL_END
