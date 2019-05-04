//
//  QuestionMaterialsModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/7.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionMaterialsModel : NSObject

//材料id
@property (nonatomic, strong) NSString *materials_id;

@property (nonatomic, strong) NSString *materials_content;

@property (nonatomic, strong) NSArray *materials_image_array;

@property (nonatomic, assign) CGFloat materials_heigth;

@end

NS_ASSUME_NONNULL_END
