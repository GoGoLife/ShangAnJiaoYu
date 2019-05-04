//
//  RefiningContentSectionView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/5/2.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefiningContentSectionView : UIView

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, copy) void (^touchButtonChangeOnStatusAction)(NSInteger section);

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) BOOL isShowButton;

@end

NS_ASSUME_NONNULL_END
