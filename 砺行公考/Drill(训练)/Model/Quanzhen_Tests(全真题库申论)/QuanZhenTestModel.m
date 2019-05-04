//
//  QuanZhenTestModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/2.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "QuanZhenTestModel.h"
#import "GlobarFile.h"

@implementation QuanZhenTestModel

- (NSString *)require_finish_string {
    NSString *finish_string = @"";
    for (NSString *string in self.require_content_array) {
        finish_string = [finish_string stringByAppendingString:[NSString stringWithFormat:@"%@\n", string]];
    }
    _require_finish_string = finish_string;
    return _require_finish_string;
}

@end


@implementation EssayTestQuanZhenMaterialsModel

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self == [super init]) {
//        self.materials_id = [aDecoder decodeObjectForKey:@"materials_id"];
//        self.materials_content = [aDecoder decodeObjectForKey:@"materials_content"];
//        self.materials_image_array = [aDecoder decodeObjectForKey:@"materials_image_array"];
//        self.materials_content_height = [[aDecoder decodeObjectForKey:@"materials_content_height"] floatValue];
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.materials_id forKey:@"materials_id"];
//    [aCoder encodeObject:self.materials_content forKey:@"materials_content"];
//    [aCoder encodeObject:self.materials_image_array forKey:@"materials_image_array"];
//    [aCoder encodeObject:@(self.materials_content_height) forKey:@"materials_content_height"];
//}

StringHeight()
- (CGFloat)materials_content_height {
    CGFloat height = [self calculateRowHeight:self.materials_content fontSize:14 withWidth:SCREENBOUNDS.width - 50];
    _materials_content_height = height;
    return _materials_content_height;
}

@end
