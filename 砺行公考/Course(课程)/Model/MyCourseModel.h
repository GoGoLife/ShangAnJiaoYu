//
//  MyCourseModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCourseModel : NSObject

@property (nonatomic, strong) NSString *myCourse_id;

//内容
@property (nonatomic, strong) NSString *content_string;

//标签
@property (nonatomic, strong) NSString *tag_string;

//是否已学习
@property (nonatomic, assign) BOOL isStudy;

@end
