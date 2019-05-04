//
//  FuncNivaModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/28.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FuncNivaModel : NSObject

/**
 方法ID
 */
@property (nonatomic, strong) NSString *func_id;

/**
 方法名称
 */
@property (nonatomic, strong) NSString *func_name;

/**
 所属方法ID
 */
@property (nonatomic, strong) NSString *parent_id;

/**
 集合下面的方法
 */
@property (nonatomic, strong) NSArray *func_index_array;

@end


@interface FuncIndexModel : NSObject

/**
 方法ID
 */
@property (nonatomic, strong) NSString *func_index_id;

/**
 方法名称
 */
@property (nonatomic, strong) NSString *func_index_name;

/**
 所属方法ID
 */
@property (nonatomic, strong) NSString *parent_id;

@end

NS_ASSUME_NONNULL_END
