//
//  VideoCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import <SJVideoPlayer.h>
#import <Masonry.h>

@interface VideoCollectionViewCell ()<SJVideoPlayerControlLayerDelegate, SJVideoPlayerControlLayerDataSource>

@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) UIButton *play_button;

@end

@implementation VideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
//        [self initCellUI];
    }
    return self;
}

//@"https://lixingjiaoyu.oss-cn-hangzhou.aliyuncs.com/test/picture/1544002208873.mp4"

- (void)setVideo_url_string:(NSString *)video_url_string {
    _video_url_string = video_url_string;
    if ([video_url_string isEqualToString:@""]) {
        self.contentView.layer.contents = (id)[UIImage imageNamed:@"date"].CGImage;
    }else {
        [self initCellUI];
    }
}

- (void)initCellUI {
    self.player = [SJVideoPlayer player];
    self.player.controlLayerDelegate = self;
    self.player.controlLayerDataSource = self;
    self.player.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.player.view];
    self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.video_url_string]];
    self.player.autoPlay = NO;
    
    self.play_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.play_button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.play_button addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.play_button];
    __weak typeof(self) weakSelf = self;
    [self.play_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

//NO  === 停用播放器所有手势
- (BOOL)triggerGesturesCondition:(CGPoint)location {
    return NO;
}

// YES ==== 隐藏控制层
- (BOOL)controlLayerDisappearCondition {
    return NO;
}

- (UIView *)controlView {
    return nil;
}

- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer statusDidChanged:(SJVideoPlayerPlayStatus)status {
    if (status == 5) {
        NSLog(@"paused paused");
        if (videoPlayer.inactivityReason == SJVideoPlayerInactivityReasonPlayEnd) {
            NSLog(@"end   end  end");
            self.play_button.hidden = NO;
        }
        self.play_button.hidden = NO;
    }
}

- (void)controlLayerNeedAppear:(__kindof SJBaseVideoPlayer *)videoPlayer {
    
}

- (void)controlLayerNeedDisappear:(__kindof SJBaseVideoPlayer *)videoPlayer {
    
}

//点击开始播放视频
- (void)playVideoAction {
    self.play_button.hidden = YES;
    [self.player play];
}

@end
