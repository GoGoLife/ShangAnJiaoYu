//
//  ShowShoppingCategoryView.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKTagView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShowShoppingCategoryViewDelegate <NSObject>

- (void)touchAddButtonAction:(UIButton *)add_button Numbers:(UILabel *)number_label;

- (void)touchLessButtonAction:(UIButton *)add_button Numbers:(UILabel *)number_label;

@end

@interface ShowShoppingCategoryView : UIView

//商品ID
@property (nonatomic, strong) NSString *shop_id;

@property (nonatomic, strong) UIImageView *imageview;

@property (nonatomic, strong) UILabel *price_label;

//库存
@property (nonatomic, strong) UILabel *inventory_label;

@property (nonatomic, strong) UILabel *choose_category_label;

@property (nonatomic, strong) UILabel *category_label;

@property (nonatomic, strong) SKTagView *tagView;

@property (nonatomic, strong) UILabel *pay_nubmer_label;

@property (nonatomic, strong) UIButton *less_button;

@property (nonatomic, strong) UILabel *number_label;

@property (nonatomic, strong) UIButton *add_button;

//确认button
@property (nonatomic, strong) UIButton *confirm_button;

@property (nonatomic, strong) NSArray *tag_array;

@property (nonatomic, copy) void(^touchCancelAction)(void);

@property (nonatomic, copy) void(^touchConfirmAction)(NSDictionary *small_tag_dic);

@property (nonatomic, weak) id<ShowShoppingCategoryViewDelegate> delegate;

/** 数量具体值 */
@property (nonatomic, strong) NSString *numbers_string;

@end

NS_ASSUME_NONNULL_END
