//
//  CustomSelectFuntionPicker.h
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/18.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomSelectFunctionPickerDelegate <NSObject>

- (void)returnSelectFunctionStringAtIndex:(NSInteger)row;

@end

@interface CustomSelectFuntionPicker : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<CustomSelectFunctionPickerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
