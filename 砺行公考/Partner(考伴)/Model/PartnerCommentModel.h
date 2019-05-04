//
//  PartnerCommentModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PartnerCommentModel : NSObject

@property (strong, nonatomic) NSString *picture_;

//内容
@property (strong, nonatomic) NSString *content_;

@property (strong, nonatomic) NSString *id_;

@property (strong, nonatomic) NSString *name_;

@property (strong, nonatomic) NSString *parent_id_;

@property (nonatomic, strong) NSString *parent_name_;

@property (strong, nonatomic) NSString *create_time_;

@property (strong, nonatomic) NSString *user_id_;

@property (nonatomic, strong) NSString *parent_user_id_;

@property (nonatomic, strong) NSString *finish_content;

//评论内容的高度  仅仅只是内容
@property (nonatomic, assign) CGFloat comment_height;

@end

NS_ASSUME_NONNULL_END
