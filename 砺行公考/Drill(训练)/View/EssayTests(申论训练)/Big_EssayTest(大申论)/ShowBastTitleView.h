//
//  ShowBastTitleView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/21.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowBastViewDelegate<NSObject>

- (void)touchStartButtonAction;

@end

@interface ShowBastTitleView : UIView

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, weak) id<ShowBastViewDelegate> delegate;

@end
