//
//  ErrorTagCollectionViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/10.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorTagCollectionViewCell : UICollectionViewCell

//是否显示编辑按钮
@property (nonatomic, assign) BOOL isShowEditButton;

@property (nonatomic, strong) UILabel *contentLable;

@property (nonatomic, strong) UIView *back_view;

@end
