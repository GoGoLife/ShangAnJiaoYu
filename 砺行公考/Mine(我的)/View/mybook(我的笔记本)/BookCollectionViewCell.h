//
//  BookCollectionViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol BookCollectionViewCellDelegate <NSObject>

- (void)touchEditButtonActionWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface BookCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageview;

@property (nonatomic, strong) UILabel *name_label;

@property (nonatomic, strong) UILabel *numbers_label;

@property (nonatomic, strong) UIButton *edit_button;

@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 是否显示编辑按钮
 */
@property (nonatomic, assign) BOOL isShowEditButton;

@property (nonatomic, weak) id<BookCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
