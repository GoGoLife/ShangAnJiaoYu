//
//  CustomBigTrainingModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CustomBigTrainingModel.h"

@implementation CustomBigTrainingModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.small_content_array = [aDecoder decodeObjectForKey:@"small_content_array"];
        self.content_height = [[aDecoder decodeObjectForKey:@"content_height"] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.small_content_array forKey:@"small_content_array"];
    [aCoder encodeObject:@(self.content_height) forKey:@"content_height"];
}

@end



@implementation SmallContentModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.small_content = [aDecoder decodeObjectForKey:@"small_content"];
        self.small_content_height = [[aDecoder decodeObjectForKey:@"small_content_height"] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.small_content forKey:@"small_content"];
    [aCoder encodeObject:@(self.small_content_height) forKey:@"small_content_height"];
}

@end
