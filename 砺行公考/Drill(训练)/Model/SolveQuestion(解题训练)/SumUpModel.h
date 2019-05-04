//
//  SumUpModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SumUpModel : NSObject

//总括句
@property (nonatomic, strong) NSString *sum_up_string;

//精炼提取
@property (nonatomic, strong) NSString *refine_string;

@property (nonatomic, assign) CGFloat sum_up_string_height;

@end
