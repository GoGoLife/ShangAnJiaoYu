//
//  SummarizeModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/10.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SummarizeModel : NSObject

//总结本数据的笔记ID
@property (nonatomic, strong) NSString *notes_id;

//总结内容
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *creat_time;

@property (nonatomic, strong) NSString *question_id;

@property (nonatomic, strong) NSString *question_content;

@property (nonatomic, strong) NSArray *question_choice_data;

//要求数组
@property (nonatomic, strong) NSArray *question_require_list;


@end

NS_ASSUME_NONNULL_END
