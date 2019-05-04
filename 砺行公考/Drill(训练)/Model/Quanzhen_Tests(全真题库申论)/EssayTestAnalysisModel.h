//
//  EssayTestAnalysisModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EssayTestAnalysisModel : NSObject

@property (nonatomic, strong) NSString *Analysis_model_string;

@property (nonatomic, strong) NSString *Analysis_content;

@property (nonatomic, assign) CGFloat analysis_content_height;

@end

NS_ASSUME_NONNULL_END
