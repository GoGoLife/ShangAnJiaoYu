//
//  DetailsHeaderView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsHeaderView : UIView

@property (nonatomic, strong) NSArray *collectionview_data_array;

@property (nonatomic, strong) NSString *title_string;

@property (nonatomic, strong) NSArray *tag_array;

@property (nonatomic, strong) NSString *price_string;

@property (nonatomic, strong) NSString *pay_numbers_string;

@property (nonatomic, strong) NSString *date_string;

@end

NS_ASSUME_NONNULL_END
