//
//  CollectionTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Collection_Cell_Height 70

@interface CollectionTableViewCell : UITableViewCell

//图片
@property (nonatomic, strong) UIImageView *leftImageV;

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@end
