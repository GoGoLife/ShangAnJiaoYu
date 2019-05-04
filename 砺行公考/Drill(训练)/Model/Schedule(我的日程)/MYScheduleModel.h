//
//  MYScheduleModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/29.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MYScheduleModel : NSObject

//表明日程item  是否被选择
@property (nonatomic, assign) BOOL isSelect;

//每个item的    indexPath
@property (nonatomic, strong) NSIndexPath *indexPath;

//item的标记    半小时标记一次
@property (nonatomic, strong) NSString *item_tag_float;

//显示的文本字符串
@property (nonatomic, strong) NSString *item_content_string;

//显示的item的颜色
@property (nonatomic, strong) UIColor *item_color;

@end
