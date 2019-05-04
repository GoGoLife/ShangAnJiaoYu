//
//  ClassifyModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.isBlock = [aDecoder decodeObjectForKey:@"isBlock"];
        self.materialsArray = [aDecoder decodeObjectForKey:@"materialsArray"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.isBlock) forKey:@"isBlock"];
    [aCoder encodeObject:self.materialsArray forKey:@"materialsArray"];
}



@end
