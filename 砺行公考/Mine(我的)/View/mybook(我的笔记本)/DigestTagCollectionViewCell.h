//
//  DigestTagCollectionViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DigestTagCollectionViewCellDelegate <NSObject>

- (void)deleteBindTagWithDigest:(NSIndexPath *)indexPath;

@end

@interface DigestTagCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UILabel *tag_label;

@property (nonatomic, weak) id<DigestTagCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
