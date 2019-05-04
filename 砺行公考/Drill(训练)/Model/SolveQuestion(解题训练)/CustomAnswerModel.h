//
//  CustomAnswerModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomAnswerModel : NSObject

//题目ID
@property (nonatomic, strong) NSString *question_id;

//答案ID  数组
@property (nonatomic, strong) NSArray *option_id_array;

//是否作答
@property (nonatomic, assign) BOOL isHaveAnswer;

//是否正确
@property (nonatomic, assign) BOOL isCorrect;

/** 题目材料ID数组 */
@property (nonatomic, strong) NSArray *question_materials_id_array;

@end
