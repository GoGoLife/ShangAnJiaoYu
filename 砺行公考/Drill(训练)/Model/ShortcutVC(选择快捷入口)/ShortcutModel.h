//
//  ShortcutModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/28.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShortcutModel : NSObject

@property (nonatomic, strong) NSString *imageNamed;

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *isShow;

@property (nonatomic, strong) NSString *categoryModel;

@property (nonatomic, strong) NSString *targetVCNamed;

@property (nonatomic, strong) NSString *targetData;

@end

NS_ASSUME_NONNULL_END
