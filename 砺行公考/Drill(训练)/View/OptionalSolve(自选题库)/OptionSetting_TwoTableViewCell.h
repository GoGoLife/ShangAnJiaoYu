//
//  OptionSetting_TwoTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
//代理实现点击回调    显示下拉框
@protocol touchChooseButtonDelegate<NSObject>

- (void)touchChooseButtonAndShowList:(NSIndexPath *)indexPath;

@end

@interface OptionSetting_TwoTableViewCell : UITableViewCell

//cell的indexPath
@property (nonatomic, strong) NSIndexPath *indexPath;

//左侧视图
@property (nonatomic, strong) UIImageView *leftImage;

//描述文本
@property (nonatomic, strong) UILabel *titleLabel;

//对应方法显示
@property (nonatomic, strong) UILabel *FunctionLabel;

//选择方法按钮    出现下拉框
@property (nonatomic, strong) UIButton *chooseButton;

//是否显示选择方法按钮
@property (nonatomic, assign) BOOL isShowFunctionButton;

/**
 是否显示左侧视图
 */
@property (nonatomic, assign) BOOL isShowLeftImage;

//点击左侧视图  block
@property (nonatomic, copy) void(^touchLeftImageBlock)(NSIndexPath *indexPath);

@property (nonatomic, weak) id<touchChooseButtonDelegate> delegate;

@end
