//
//  testModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface testModel : NSObject

//试卷ID
@property (nonatomic, strong) NSString *test_id;

//试卷名称
@property (nonatomic, strong) NSString *testNameString;

//试卷描述
@property (nonatomic, strong) NSString *testDetailString;

//试卷标签
@property (nonatomic, strong) NSString *tagString;

//标签宽度
@property (nonatomic, assign) CGFloat tag_width;

@property (nonatomic, assign) BOOL isShowChoose;

@property (nonatomic, assign) BOOL isSelected;

@end
