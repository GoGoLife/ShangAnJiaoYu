//
//  MaterialsModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/29.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaterialsModel : NSObject

/**
 材料ID
 */
@property (nonatomic, strong) NSString *materials_id;

/**
 材料图片数组
 */
@property (nonatomic, strong) NSArray *materials_image_array;

/**
 材料内容
 */
@property (nonatomic, strong) NSString *content_string;

/**
 材料炸词数组
 */
@property (nonatomic, strong) NSArray *materials_array;

@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
