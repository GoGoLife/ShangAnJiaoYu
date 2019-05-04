//
//  TestTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//
//
//                      全真题库Cell

#import <UIKit/UIKit.h>

#define TEST_CELL_HEIGHT 60

@interface TestTableViewCell : UITableViewCell

//左侧imageView
@property (nonatomic, strong) UIImageView *leftImageV;

//试卷名称Label
@property (nonatomic, strong) UILabel *testNameLabel;

//试卷说明
@property (nonatomic, strong) UILabel *detailsLabel;

//标签说明
@property (nonatomic, strong) UILabel *tagLabel;

//右侧箭头
@property (nonatomic, strong) UIImageView *rightImageV;

//选择视图
@property (nonatomic, strong) UIImageView *chooseImageV;

//是否显示下载选择按钮
@property (nonatomic, assign) BOOL isShowChoose;

//是否已经选择
@property (nonatomic, assign) BOOL isSelected;

//是否显示左侧image
@property (nonatomic, assign) BOOL isShowLeftImage;

@end
