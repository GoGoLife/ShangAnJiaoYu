//
//  OptionalSettingModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionalSettingModel : NSObject

/** 是否出于选择状态 */
@property (nonatomic, assign) BOOL isShowOperateButton;

/** 大分类ID */
@property (nonatomic, strong) NSString *big_id;

/** 描述类型文本 */
@property (nonatomic, strong) NSString *titleString;

/** 默认数量 */
@property (nonatomic, strong) NSString *numberString;

/** 方法选择数组 */
@property (nonatomic, strong) NSArray *functionSelectArray;

/** 用户选择的方法对应的ID */
@property (nonatomic, strong) NSString *user_select_function_id;

/** 用户选择的方法 */
@property (nonatomic, strong) NSString *user_select_function;

@end



@interface functionModel : NSObject

@property (nonatomic, strong) NSString *function_id;

@property (nonatomic, strong) NSString *function_name;

@property (nonatomic, strong) NSString *parent_id;

@end
