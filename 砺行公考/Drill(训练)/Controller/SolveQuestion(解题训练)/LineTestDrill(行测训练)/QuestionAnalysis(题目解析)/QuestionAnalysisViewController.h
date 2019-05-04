//
//  QuestionAnalysisViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//
//
//
//
//                                     题目解析界面

#import "BaseViewController.h"

@interface QuestionAnalysisViewController : BaseViewController

//题目解析数组
@property (nonatomic, strong) NSArray *analysis_array;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, assign) BOOL isShowNextButton;

@end
