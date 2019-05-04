//
//  Classify_sectionView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol touchSectionDelegate<NSObject>

- (void)touchSectionAction:(NSInteger)section;

@end

@interface Classify_sectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame withIndexPath:(NSInteger)section;

//判断是分点   还是  分块
@property (nonatomic, assign) BOOL isBlock;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, weak) id<touchSectionDelegate> delegate;

@end
