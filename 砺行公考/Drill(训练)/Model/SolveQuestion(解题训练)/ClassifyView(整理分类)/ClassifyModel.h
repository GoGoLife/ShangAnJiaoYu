//
//  ClassifyModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyModel : NSObject<NSCoding>

//区分是分点   还是  分块
@property (nonatomic, assign) BOOL isBlock;

//选择的采点材料数组
@property (nonatomic, strong) NSArray *materialsArray;

@end
