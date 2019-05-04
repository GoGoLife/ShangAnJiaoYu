//
//  BigFour_ AnalyzeViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

//主要用于区分上级页面是分析    还是  对策
typedef NS_ENUM(NSInteger, SUPER_VC_TYPE) {
    SUPER_VC_TYPE_ANALYZE = 0,             //上级页面是分析
    SUPER_VC_TYPE_COUNTERMEASURE             //上级页面是分析
};

@interface BigFour_AnalyzeViewController : BaseViewController

@property (nonatomic, assign) SUPER_VC_TYPE type;

@property (nonatomic, strong) NSArray *top_array;

@end
