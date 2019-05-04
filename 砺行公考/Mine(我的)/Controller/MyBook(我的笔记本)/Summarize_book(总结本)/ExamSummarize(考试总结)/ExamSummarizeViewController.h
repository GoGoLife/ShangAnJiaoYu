//
//  ExamSummarizeViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "TipsCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamSummarizeViewController : BaseViewController

@property (nonatomic, strong) NSString *exam_id;

@property (nonatomic, strong) UICollectionView *collectionview;

//选择的图片的Array
@property (nonatomic, strong) NSMutableArray *imageArray;

//标题内容
@property (nonatomic, strong) UITextField *title_textfield;

@end

NS_ASSUME_NONNULL_END
