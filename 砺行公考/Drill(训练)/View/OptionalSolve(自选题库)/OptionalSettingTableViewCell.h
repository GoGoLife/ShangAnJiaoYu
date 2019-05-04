//
//  OptionalSettingTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OPTIONAL_CELL_HEIGHT 60

@protocol OptionalSettingTableViewCellDelegate <NSObject>

- (void)touchLessbuttonAction:(NSIndexPath *)indexPath;

- (void)touchAddbuttonAction:(NSIndexPath *)indexPath;

@end


@interface OptionalSettingTableViewCell : UITableViewCell

//cell的indexPath
@property (nonatomic, strong) NSIndexPath *indexPath;

//左侧视图
@property (nonatomic, strong) UIImageView *leftImage;

//自选类型文本
@property (nonatomic, strong) UILabel *titleLabel;

//减
@property (nonatomic, strong) UIButton *lessButton;

//数量
@property (nonatomic, strong) UILabel *numberLabel;

//加
@property (nonatomic, strong) UIButton *addButton;

//是否显示加减按钮以及数量框
@property (nonatomic, assign) BOOL isShowOperateButton;

//点击左侧视图  block
@property (nonatomic, copy) void(^touchLeftImageBlock)(NSIndexPath *indexPath);

//见  block
//@property (nonatomic, copy) void(^touchLessButtonBlock)(NSIndexPath *indexPath);
//
////加  block
//@property (nonatomic, copy) void(^touchAddButtonBlock)(NSIndexPath *indexPath);

@property (nonatomic, weak) id<OptionalSettingTableViewCellDelegate> delegate;

@end
