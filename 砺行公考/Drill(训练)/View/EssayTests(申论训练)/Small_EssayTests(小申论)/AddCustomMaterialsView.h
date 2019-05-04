//
//  AddCustomMaterialsView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCustomMaterialsView : UIView

- (instancetype)initWithFrame:(CGRect)frame AndTips_ID:(NSString *)tip_id AndContent_string:(NSString *)content_string;

@property (nonatomic, copy) void(^addMaterialsDataFinishBlock)(void);

@end
