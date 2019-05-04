//
//  Shopping_CommentTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Shopping_CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *header_image;

@property (nonatomic, strong) UILabel *name_label;

@property (nonatomic, strong) UILabel *tag_label;

//等级
@property (nonatomic, strong) UILabel *grade_label;

@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, strong) UILabel *category_label;

//用来承载图片
@property (nonatomic, strong) UICollectionView *collectionview;

//数据相关
@property (nonatomic, strong) NSArray *imageArray;

@end

NS_ASSUME_NONNULL_END
