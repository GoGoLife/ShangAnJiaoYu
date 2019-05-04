//
//  CommentModel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//header + cell  + footer  数据
@interface CommentModel : NSObject

@property (nonatomic, strong) NSString *comment_id;

//头像
@property (nonatomic, strong) NSString *headerURL;

//昵称
@property (nonatomic, strong) NSString *nickName;

//标签
@property (nonatomic, strong) NSString *tagString;

//时间
@property (nonatomic, strong) NSString *dateString;

//评论内容
@property (nonatomic, strong) NSString *contentString;

//点赞数量
@property (nonatomic, strong) NSString *soptString;

//高度
@property (nonatomic, assign) CGFloat header_view_height;

//子评论数据
@property (nonatomic, strong) NSArray *cellCommentData;

@end

//仅仅只是cell 数据
@interface CommentCellModel : NSObject

@property (nonatomic, strong) NSString *cell_comment_id;

@property (nonatomic, strong) NSString *cell_comment_content;

@property (nonatomic, strong) NSString *cell_user_image_url;

@property (nonatomic, strong) NSString *cell_user_name;

@property (nonatomic, strong) NSString *cell_parent_image_url;

@property (nonatomic, strong) NSString *cell_parent_name;

@property (nonatomic, strong) NSString *finish_comment_string;

@property (nonatomic, assign) CGFloat cell_height;

@end
