//
//  ChooseDoTypeViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DoType) {
    DoType_Small_Tests = 0,  //小申论解题训练
    DoType_Big_Tests         //大申论解题训练
};

@interface ChooseDoTypeViewController : BaseViewController

@property (nonatomic, assign) DoType doType;

@property (nonatomic, strong) NSArray *essay_id_array;

@property (nonatomic, strong) NSString *training_id;

@end

NS_ASSUME_NONNULL_END
