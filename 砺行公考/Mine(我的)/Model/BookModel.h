//
//  BookModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/10.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookModel : NSObject

@property (nonatomic, strong) NSString *book_id;

@property (nonatomic, strong) NSString *image_url;

@property (nonatomic, strong) NSString *name_string;

@property (nonatomic, strong) NSString *numbers_string;

@property (nonatomic, strong) NSString *details_string;

@end

NS_ASSUME_NONNULL_END
