//
//  ProveReusableView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROVE_HEIGHT 740

NS_ASSUME_NONNULL_BEGIN

@interface ProveReusableView : UICollectionReusableView

@property (nonatomic, copy) void (^returnTextfieldContentAndIndex)(NSString *content, NSInteger index);

@end

NS_ASSUME_NONNULL_END
