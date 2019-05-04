//
//  ErrorQuestionBookViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ErrorBookType) {
    ErrorBookType_ONE = 0,
    ErrorBookType_TWO,
    ErrorBookType_MORE,
    ErrorBookType_FINISH
};

@interface ErrorQuestionBookViewController : BaseViewController

@property (nonatomic, assign) ErrorBookType type;

@end

NS_ASSUME_NONNULL_END
