//
//  FinishAnswerModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/23.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinishAnswerModel : NSObject

//section  文本
@property (nonatomic, strong) NSString *section_string;

//大申论的各项答案
@property (nonatomic, strong) NSString *answer_string;

@end
