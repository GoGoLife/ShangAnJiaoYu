//
//  TrainingHomeModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/17.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrainingHomeModel : NSObject

/** ID */
@property (nonatomic, strong) NSString *training_id;

/** 视频URL */
@property (nonatomic, strong) NSString *video_file_url;

/** 分类 */
@property (nonatomic, strong) NSArray *categoty_array;

/** 分类下的数据 */
@property (nonatomic, strong) NSArray *dataInCategoty_array;

/** 判断是否购买 */
@property (nonatomic, assign) NSInteger is_purchase;

@end

@interface CategoryUnderDataModel : NSObject

/** ID */
@property (nonatomic, strong) NSString *data_id;

/** 标题 */
@property (nonatomic, strong) NSString *data_title;

/** 通关训练所属试卷的数量（共有几轮） */
@property (nonatomic, assign) NSInteger exam_count;

/** 判断是否免费 */
@property (nonatomic, assign) NSInteger whetherFree;

@end

NS_ASSUME_NONNULL_END
