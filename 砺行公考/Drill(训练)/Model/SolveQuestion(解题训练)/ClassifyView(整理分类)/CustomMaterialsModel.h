//
//  CustomMaterialsModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CustomMaterialsModel : NSObject<NSCoding>

/** 采点数据ID */
@property (nonatomic, strong) NSString *materials_id;

/** 采点分类ID */
@property (nonatomic, strong) NSString *tag_string_id;

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** 采点数据 */
@property (nonatomic, strong) NSString *content_string;

/** 注解词数据 */
@property (nonatomic, strong) NSString *tag_string;

/** 采点数据高度 */
@property (nonatomic, assign) CGFloat content_string_height;

/** 采点类型 */
@property (nonatomic, strong) NSString *tag_type_string;

@end
