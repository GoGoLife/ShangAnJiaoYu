//
//  Tips_AddSummarizeViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tips_AddSummarizeViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *tableview_data_array;

@property (nonatomic, copy) void(^AddMoreQuestionBlock)(NSMutableArray *array);

//tips笔记的ID  用于h直接获取tips详情
@property (nonatomic, strong) NSString *tips_id;

@property (nonatomic, strong) UICollectionView *collectionview;

//选择的图片的Array
@property (nonatomic, strong) NSMutableArray *imageArray;

//总结内容
@property (nonatomic, strong) UITextView *textview;

@end

NS_ASSUME_NONNULL_END
