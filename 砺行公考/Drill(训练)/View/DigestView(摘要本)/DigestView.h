//
//  DigestView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
//笔记本的具体操作
typedef NS_ENUM(NSInteger, OPRATION_TYPE) {
    OPRATION_TYPE_CREATE = 0,           //创建笔记
    OPRATION_TYPE_MOVE,                 //移动
    OPRATION_TYPE_COPY                  //复制
};

@protocol DigestViewDelegate <NSObject>

- (void)finishOprationAction;

@end

@interface DigestView : UIView

//隐藏view
- (void)hiddenView;

//需要摘记的内容
@property (nonatomic, strong) NSString *digest_content_string;

@property (nonatomic, copy) void (^creatBookBlock)(void);

//获取摘记本数据
- (void)getHttpData;

@property (nonatomic, assign) OPRATION_TYPE type;

//移动或者复制的笔记数组
@property (nonatomic, strong) NSArray *moveOrCopy_data_array;

@property (nonatomic, weak) id<DigestViewDelegate> delegate;

@end
