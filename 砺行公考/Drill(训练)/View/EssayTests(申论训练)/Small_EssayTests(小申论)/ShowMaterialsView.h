//
//  ShowMaterialsView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/19.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowMaterialsViewDelegate<NSObject>

- (void)touchPointAction:(NSString *)pointString;

@end

@interface ShowMaterialsView : UIView

@property (nonatomic, strong) NSArray *points_array;

@property (nonatomic, weak) id<ShowMaterialsViewDelegate> delegate;

@end
