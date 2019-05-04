//
//  ChooseDateView.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/26.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChooseDateViewDelegate <NSObject>

- (void)returnSelectFunctionStringAtIndex:(NSArray *)rowData;

@end

@interface ChooseDateView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<ChooseDateViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
