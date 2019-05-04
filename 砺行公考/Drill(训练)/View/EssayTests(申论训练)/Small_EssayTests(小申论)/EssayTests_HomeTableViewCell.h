//
//  EssayTests_HomeTableViewCell.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ESSAYTEST_CELL_HEIGHT 270


@protocol EssayTests_HomeTableViewCellDelegate <NSObject>

- (void)touchGoPlayPloblem:(NSIndexPath *)indexPath;

@end


@interface EssayTests_HomeTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

//视频背景图
@property (nonatomic, strong) UIImageView *video_back_image;

//播放image
@property (nonatomic, strong) UIImageView *play_image;

//题量
@property (nonatomic, strong) UILabel *test_number_label;

//申论题目名称
@property (nonatomic, strong) UILabel *title_label;

//申论题目说明
@property (nonatomic, strong) UILabel *detail_label;

//已参加人数
@property (nonatomic, strong) UILabel *didJoin_number;

//购买  价钱按钮
@property (nonatomic, strong) UIButton *pay_button;

@property (nonatomic, weak) id<EssayTests_HomeTableViewCellDelegate> delegate;

@end
