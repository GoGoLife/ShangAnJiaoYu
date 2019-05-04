//
//  ChooseMaterialsViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseMaterialsViewController : BaseViewController

@property (nonatomic, copy) void(^returnSelectedData)(NSArray *data_array);

@end
