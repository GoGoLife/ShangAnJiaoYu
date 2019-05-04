//
//  BigTrainingTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BigTrainingTableViewCellDelegate <NSObject>

//- (void)returnFieldContent:(NSString *)content withIndexPath:(NSIndexPath *)indexPath;

- (void)reloadTableviewCellTextView:(UITextView *)textView withIndexPath:(NSIndexPath *)indexPath withContentHieght:(CGFloat)height;

@end

@interface BigTrainingTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *left_imageview;

@property (nonatomic, strong) UITextView *content_textview;

@property (nonatomic, assign) BOOL isShowLeftImage;

@property (nonatomic, weak) id<BigTrainingTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
