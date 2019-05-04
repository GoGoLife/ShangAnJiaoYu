//
//  AnswerModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject

//选项的ID
@property (nonatomic, strong) NSString *answer_id;

//选项的内容
@property (nonatomic, strong) NSString *answer_content;

//选项包含的图片
@property (nonatomic, strong) NSString *answer_content_image;

@property (nonatomic, strong) NSString *answer_order;

//选项是否正确
@property (nonatomic, strong) NSString *isCorrect;

//用于区分A B C D 
@property (nonatomic, strong) NSString *answer_type;

//选项内容的高度    距离右边40的高度
@property (nonatomic, assign) CGFloat answer_height;

//选项内容的高度    距离右边100的高度
@property (nonatomic, assign) CGFloat answer_height_second;

@end
