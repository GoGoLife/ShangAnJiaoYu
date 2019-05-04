//
//  ShowAndWriteTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ShowAndWrite_Cell_Height 200

@interface ShowAndWriteTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView *textview;

@property (nonatomic, strong) UIView *back_view;

@end
