//
//  ErrorTagModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/10.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GlobarFile.h"

@interface ErrorTagModel : NSObject

@property (nonatomic, strong) NSString *tag_id;

//标签文本
@property (nonatomic, strong) NSString *tagString;

//标签宽度
@property (nonatomic, assign) CGFloat tagWidth;

@end
