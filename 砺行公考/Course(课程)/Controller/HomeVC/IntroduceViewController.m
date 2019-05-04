//
//  IntroduceViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "IntroduceViewController.h"
#import <SJVideoPlayer.h>
#import "BigTrainingFirstViewController.h"
#import "SmallTrainingFirstViewController.h"
#import "BigEssayFirstViewController.h"

@interface IntroduceViewController ()

@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) SJPlayModel *playModel;

@property (nonatomic, strong) UITextView *textview;

@end

@implementation IntroduceViewController

- (void)getIntroduceData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"exam_id_":self.training_id,@"order_":@"1"};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_interpretation_data" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            
            NSString *player_url_string = responseObject[@"data"][@"path_"] ?: @"";
            
            weakSelf.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:player_url_string] playModel:weakSelf.playModel];
            weakSelf.textview.text = responseObject[@"data"][@"desc_"] ?: @"";
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextVC)];
    
    __weak typeof(self) weakSelf = self;
    self.playModel = [SJPlayModel new];
    self.player = [[SJVideoPlayer alloc] init];
    self.player.placeholderImageView.image = [UIImage imageNamed:@"no_image"];
    ViewRadius(self.player.view, 8.0);
    self.player.disableAutoRotation = YES;
    [self.view addSubview:self.player.view];
    self.player.autoPlay = NO;
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(5);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(160);
    }];
    //播放结束回调
    self.player.playDidToEndExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        [player replay];
    };
    
    self.textview = [[UITextView alloc] init];
    self.textview.font = SetFont(14);
    self.textview.editable = NO;
    [self.view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.player.view.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
    }];
    
    [self getIntroduceData];
}

- (void)pushNextVC {
    if (self.introduceType == IntroduceType_BigEssayTraining) {
        BigTrainingFirstViewController *bigTraining = [[BigTrainingFirstViewController alloc] init];
        bigTraining.bigTestTraining_id = self.training_id;
        [self.navigationController pushViewController:bigTraining animated:YES];
    }else if(self.introduceType == IntroduceType_SmallEssayTraining) {
        SmallTrainingFirstViewController *smallFrist = [[SmallTrainingFirstViewController alloc] init];
        smallFrist.exam_id = self.training_id;
        smallFrist.topic_count = self.smallEssay_topic_count;
        [self.navigationController pushViewController:smallFrist animated:YES];
    }else if (self.introduceType == IntroduceType_SmallEssayTests) {
        //小申论解题训练
        SmallTrainingFirstViewController *smallFrist = [[SmallTrainingFirstViewController alloc] init];
        smallFrist.exam_id = self.training_id;
        smallFrist.topic_count = self.smallEssay_topic_count;
        [self.navigationController pushViewController:smallFrist animated:YES];
    }else {
        BigEssayFirstViewController *first = [[BigEssayFirstViewController alloc] init];
        first.bigEssay_id = self.training_id;
        [self.navigationController pushViewController:first animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
