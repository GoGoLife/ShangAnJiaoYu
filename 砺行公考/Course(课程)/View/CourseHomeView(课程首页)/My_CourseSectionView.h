//
//  My_CourseSectionView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCourseSectionViewDelegate<NSObject>

- (void)touchSelfTargetAction:(NSInteger)section;

@end

@interface My_CourseSectionView : UIView

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) UILabel *title_label;

@property (nonatomic, strong) UILabel *detail_label;

@property (nonatomic, strong) UILabel *finish_label;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, weak) id<MyCourseSectionViewDelegate> delegate;

@end
