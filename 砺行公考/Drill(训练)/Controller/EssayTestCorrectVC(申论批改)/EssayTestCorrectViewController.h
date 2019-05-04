//
//  EssayTestCorrectViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/21.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EssayTestCorrectViewController : BaseViewController

/**
 试卷类型
 */
@property (nonatomic, strong) NSArray *testType;

/**
 考试省份
 */
@property (nonatomic, strong) NSArray *testProvice;

/**
 考试年份
 */
@property (nonatomic, strong) NSArray *testYear;

/**
 搜索到的试卷列表
 */
@property (nonatomic, strong) NSArray *testArray;

/**
 保存的是试卷类型ID
 */
@property (nonatomic, strong) NSString *test_type_string;

/**
 保存的是省份的ID
 */
@property (nonatomic, strong) NSString *test_provice_string;

/**
 保存年份
 */
@property (nonatomic, strong) NSString *test_year_string;

/**
 当前选择的试卷的ID
 */
@property (nonatomic, strong) NSString *test_id_string;

/**
 当前选择的indexPath
 */
@property (nonatomic, strong) NSIndexPath *current_indexPath;

/**
 保存当前试卷的答案
 */
@property (nonatomic, strong) NSArray *user_answer_array;

/**
 支付方式数组
 */
@property (nonatomic, strong) NSArray *payWay_array;

/**
 是否显示试卷的答案  以及订单信息    支付方式信息
 */
@property (nonatomic, assign) BOOL isShowTestInfo;

@end

NS_ASSUME_NONNULL_END
