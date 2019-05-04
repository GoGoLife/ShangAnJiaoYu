//
//  SpecializedTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SpecializedTableViewCellDelegate <NSObject>

- (void)returnCellIndexPath:(NSIndexPath *)indexPath;

@end

@interface SpecializedTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, strong) UITextView *answer_textview;

@property (nonatomic, weak) id<SpecializedTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
