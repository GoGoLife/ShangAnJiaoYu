//
//  BannerDetailsModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/21.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerDetailsModel : NSObject

/** 类型 */
@property (nonatomic, strong) NSString *type;

/** 排序 */
@property (nonatomic, strong) NSString *order;

/** 内容 */
@property (nonatomic, strong) NSString *content;

/** ID */
@property (nonatomic, strong) NSString *link_page_id;

@property (nonatomic, assign) CGFloat content_height;

@end

NS_ASSUME_NONNULL_END
