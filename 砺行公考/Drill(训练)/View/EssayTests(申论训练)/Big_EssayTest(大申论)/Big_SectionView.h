//
//  Big_SectionView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Big_touchSectionDelegate<NSObject>

- (void)touchSectionPushVC:(NSInteger)section;

@end

@interface Big_SectionView : UIView

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, weak) id<Big_touchSectionDelegate> delegate;

@end
