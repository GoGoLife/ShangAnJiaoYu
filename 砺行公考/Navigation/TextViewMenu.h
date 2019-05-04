//
//  TextViewMenu.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/8.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, actionType) {
    actionType_Digest = 0,
    actionType_CollectPoints
};

@protocol TextViewMenuDelegate <NSObject>

@optional
- (void)touchDigestAction;

@optional
- (void)touchCollectionPoints;

@end

@interface TextViewMenu : UITextView

@property (nonatomic, assign) actionType type;

@property (nonatomic, weak) id<TextViewMenuDelegate> CustomDelegate;

- (instancetype)initWithType:(actionType)type;

@end

NS_ASSUME_NONNULL_END
