//
//  chooseTitleView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/19.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReturnChooseTitleArrayDelegate<NSObject>

- (void)returnChooseTitleArray:(NSArray *)array;

@end

@interface chooseTitleView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSString *big_essayTest_id;

@property (nonatomic, weak) id<ReturnChooseTitleArrayDelegate> delegate;

@end
