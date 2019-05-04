//
//  CustomBigTrainingModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomBigTrainingModel : NSObject<NSCoding>

/** 总的内容 */
@property (nonatomic, strong) NSString *content;

/** 内容的高度 */
@property (nonatomic, assign) CGFloat content_height;

/** 细分的内容数组 */
@property (nonatomic, strong) NSArray *small_content_array;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface SmallContentModel : NSObject<NSCoding>

/** 细分的具体内容 */
@property (nonatomic, strong) NSString *small_content;

/** 内容的高度 */
@property (nonatomic, assign) CGFloat small_content_height;

@end

NS_ASSUME_NONNULL_END
