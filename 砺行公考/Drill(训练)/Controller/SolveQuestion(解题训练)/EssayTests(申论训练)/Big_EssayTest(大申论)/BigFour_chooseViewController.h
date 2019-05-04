//
//  BigFour_chooseViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

//introduction  countermeasure
typedef NS_ENUM(NSInteger, SUPER_VIEW_TYPE) {
    SUPER_VIEW_TYPE_WRITE_INTRODUCTION = 0,         //上级页面是引言写作跳转
    SUPER_VIEW_TYPE_ANALYZE,                        //上级页面是写分析总括句
    SUPER_VIEW_TYPE_COUNTERMEASURE,                 //上级页面是写对策总括句
};

@interface BigFour_chooseViewController : BaseViewController

@property (nonatomic, assign) SUPER_VIEW_TYPE type;

@end
