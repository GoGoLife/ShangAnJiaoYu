//
//  QuestionMaterialsModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/7.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "QuestionMaterialsModel.h"
#import "GlobarFile.h"

@implementation QuestionMaterialsModel

StringHeight()
- (CGFloat)materials_heigth {
    _materials_heigth = [self calculateRowHeight:self.materials_content fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    return _materials_heigth;
}

@end
