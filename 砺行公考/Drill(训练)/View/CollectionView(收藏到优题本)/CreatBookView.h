//
//  CreatBookView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatBookView : UIView

@property (nonatomic, copy) void(^backBlock)(void);

@property (nonatomic, copy) void(^returnBookNameBlock)(NSString *name);

- (void)removeView;

@property (nonatomic, strong) UIButton *add_image_button;

@property (nonatomic, strong) UIImageView *book_header_image;

//选择的图片  用于上传
@property (nonatomic, strong) UIImage *result_image;


/**
 新建的笔记本的类型  1 === 摘记本   2 === 优题本
 */
@property (nonatomic, assign) NSInteger type;

@end
