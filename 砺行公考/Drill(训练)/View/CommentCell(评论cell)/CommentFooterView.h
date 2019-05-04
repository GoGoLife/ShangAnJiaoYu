//
//  CommentFooterView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/25.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommentFooterViewDelegate <NSObject>

- (void)touchCommentButtonTargetAction:(NSInteger)section;

@end

@interface CommentFooterView : UIView

@property (nonatomic, assign) NSInteger section;

//评论按钮
@property (nonatomic, strong) UIButton *comment_button;

//点赞按钮
@property (nonatomic, strong) UIButton *dotParise_button;

@property (nonatomic, strong) NSString *parise_numbers_string;

@property (nonatomic, weak) id<CommentFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
