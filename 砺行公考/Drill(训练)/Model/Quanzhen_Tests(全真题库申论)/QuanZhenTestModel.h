//
//  QuanZhenTestModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/2.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuanZhenTestModel : NSObject

/**
 全真题目ID
 */
@property (nonatomic, strong) NSString *test_id;

/**
 全真题目题干
 */
@property (nonatomic, strong) NSString *test_content_string;

/**
 全真题目要求数组
 */
@property (nonatomic, strong) NSArray *require_content_array;


/**
 最终的题目要求字符串
 */
@property (nonatomic, strong) NSString *require_finish_string;

/**
 我的答案
 */
@property (nonatomic, strong) NSString *answer_content_string;

/**
 材料数组
 */
@property (nonatomic, strong) NSArray *materials_array;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

//全真申论材料Model
@interface EssayTestQuanZhenMaterialsModel : NSObject

//材料ID
@property (nonatomic, strong) NSString *materials_id;

//材料文本
@property (nonatomic, strong) NSString *materials_content;

//材料图片
@property (nonatomic, strong) NSArray *materials_image_array;

@property (nonatomic, assign) CGFloat materials_content_height;

@end

NS_ASSUME_NONNULL_END
