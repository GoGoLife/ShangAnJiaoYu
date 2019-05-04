//
//  ChangeOrCreatBookViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, BOOK_TYPE) {
    BOOK_TYPE_CHANGE = 0,                       //修改笔记本信息
    BOOK_TYPE_CREATE                             //创建新的笔记本
};

NS_ASSUME_NONNULL_BEGIN

@interface ChangeOrCreatBookViewController : BaseViewController

@property (nonatomic, assign) BOOK_TYPE type;

//笔记本ID  用于删除笔记本
@property (nonatomic, strong) NSString *book_id;

@property (nonatomic, strong) NSString *book_name;

@property (nonatomic, strong) NSString *book_numbers;

@property (nonatomic, strong) NSString *book_details;

@property (nonatomic, strong) NSString *book_image_url;

/**
  判断笔记本类型   仅限优题本  摘记本
 */
@property (nonatomic, strong) NSString *book_type;

@end

NS_ASSUME_NONNULL_END
