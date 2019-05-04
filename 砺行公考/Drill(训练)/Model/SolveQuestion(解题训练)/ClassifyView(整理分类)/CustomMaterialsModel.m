//
//  CustomMaterialsModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CustomMaterialsModel.h"
#import "GlobarFile.h"

@implementation CustomMaterialsModel
StringHeight()

//- (CGFloat)content_string_height {
//    CGFloat height = [self calculateRowHeight:self.content_string fontSize:14 withWidth:SCREENBOUNDS.width - 70];
//    return height;
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.materials_id = [aDecoder decodeObjectForKey:@"materials_id"];
        self.tag_string_id = [aDecoder decodeObjectForKey:@"tag_string_id"];
        self.isSelected = [aDecoder decodeObjectForKey:@"isSelected"];
        self.content_string = [aDecoder decodeObjectForKey:@"content_string"];
        self.tag_string = [aDecoder decodeObjectForKey:@"tag_string"];
        self.content_string_height = [[aDecoder decodeObjectForKey:@"content_string_height"] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.materials_id forKey:@"materials_id"];
    [aCoder encodeObject:self.tag_string_id forKey:@"tag_string_id"];
    [aCoder encodeObject:@(self.isSelected) forKey:@"isSelected"];
    [aCoder encodeObject:self.content_string forKey:@"content_string"];
    [aCoder encodeObject:self.tag_string forKey:@"tag_string"];
    [aCoder encodeObject:@(self.content_string_height) forKey:@"content_string_height"];
}


@end
