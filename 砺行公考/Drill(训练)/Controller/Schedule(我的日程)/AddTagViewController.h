//
//  AddTagViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/30.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddTagDelegate<NSObject>

- (void)returnTag_content:(NSString *)content Color_R:(NSString *)color_r Color_G:(NSString *)color_g Color_B:(NSString *)color_b;

@end

@interface AddTagViewController : BaseViewController

@property (nonatomic, weak) id<AddTagDelegate> delegate;

@end
