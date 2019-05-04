//
//  RefiningViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "RefiningViewController.h"
#import "RefiningTableViewCell.h"
#import "RefiningHeaderView.h"
#import "RefiningFooterView.h"
#import "RefiningModel.h"
#import <SJVideoPlayer.h>
#import "AnalysisForLabelTableViewCell.h"
#import "RefiningContentSectionView.h"

@interface RefiningViewController ()<UITableViewDelegate, UITableViewDataSource, RefiningHeaderViewDelegate, SJVideoPlayerControlLayerDelegate, SJVideoPlayerControlLayerDataSource, RefiningFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) RefiningModel *model;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *bottom_tool;

@property (nonatomic, strong) UITextField *input_comment_textfield;

/** 记录当前点击的section */
@property (nonatomic, assign) NSInteger current_touch_section;

@property (nonatomic, strong) SJVideoPlayer *videoPlayer;

/**
 发布内容的时间戳   用于后续评论
 */
@property (nonatomic, strong) NSString *publishTimeInterval;

@end

@implementation RefiningViewController

//获取精炼时评内容数据
- (void)getRefiningData {
    [self.dataArray removeAllObjects];
    
//    NSInteger interval = [KPDateTool currentTimeStamp];
    NSString *currentDate = [KPDateTool currentDateStrWithFormatter:@"yyyy/MM/dd"];
    NSString *finishDate = [currentDate stringByAppendingString:@" 08:00:00"];
    NSString *timeInterval = [KPDateTool getTimeStrWithString:finishDate];
    self.publishTimeInterval = timeInterval;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/sum_com_from_app/find_details_new" Dic:@{@"releaseDate": @(timeInterval.integerValue * 1000)} SuccessBlock:^(id responseObject) {
        __weak typeof(self) weakSelf = self;
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"refining data == %@", responseObject);
            //思考话题
            RefiningContentModel *contentModel = [[RefiningContentModel alloc] init];
            contentModel.isOn = YES;
            contentModel.refining_id = @"";//responseObject[@"data"][@""][@"id_"];
            contentModel.publish_type = [responseObject[@"data"][@"topic"][@"type"] integerValue];
            NSArray *content_list = responseObject[@"data"][@"topic"][@"content"];
            contentModel.content = [content_list componentsJoinedByString:@"\n"];
            contentModel.refining_video_url = responseObject[@"data"][@"topic"][@"video"];
            [weakSelf.dataArray addObject:contentModel];

            //资料分享
            RefiningContentModel *contentModel1 = [[RefiningContentModel alloc] init];
            contentModel1.isOn = YES;
            contentModel1.refining_id = @"";//responseObject[@"data"][@"id_"];
            contentModel1.publish_type = 2;//[responseObject[@"data"][@"type_"] integerValue];
            NSArray *share_content_list = responseObject[@"data"][@"share"][@"content"];
            contentModel1.content = [share_content_list componentsJoinedByString:@"\n"];
            contentModel1.refining_video_url = @"";
            [weakSelf.dataArray addObject:contentModel1];


            //砺行点评
            RefiningContentModel *contentModel2 = [[RefiningContentModel alloc] init];
            contentModel2.isOn = NO;
            contentModel2.refining_id = @"";//responseObject[@"data"][@"id_"];
            contentModel2.publish_type = 2;//[responseObject[@"data"][@"type_"] integerValue];
            NSArray *review_content_list = responseObject[@"data"][@"review"][@"content"];
            contentModel2.content = [review_content_list componentsJoinedByString:@"\n"];
            contentModel2.refining_video_url = @"";
            [weakSelf.dataArray addObject:contentModel2];
            
            //父评论
            for (NSDictionary *dic in responseObject[@"data"][@"comments_list"]) {
                RefiningModel *parent_model = [[RefiningModel alloc] init];
                parent_model.parent_id = dic[@"commentId"];
                parent_model.header_url = dic[@"userPortrait"];
                parent_model.name = dic[@"userName"];
                parent_model.time = [KPDateTool timeBeforeInfoWithString:[dic[@"createTime"] integerValue]];
                parent_model.content_string = dic[@"commentContent"];
                parent_model.teacher_review = [dic[@"feedbackContent"] isKindOfClass:[NSNull class]] ? @"" : dic[@"feedbackContent"];
                parent_model.praise_number = @"0";
                parent_model.isPraise = NO;
                //子评论
                NSMutableArray *son_array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *sonDic in dic[@"children"]) {
                    RefiningSonModel *sonModel = [[RefiningSonModel alloc] init];
                    sonModel.son_content = [NSString stringWithFormat:@"%@: %@", sonDic[@"userName"], sonDic[@"commentContent"]];
                    [son_array addObject:sonModel];
                }
                parent_model.son_array = [son_array copy];
                [weakSelf.dataArray addObject:parent_model];
            }
            [weakSelf.tableview.mj_header endRefreshing];
            [weakSelf.tableview reloadData];
        }else if ([responseObject[@"msg"] isEqualToString:@"记录不存在"]) {
            [weakSelf showHUDWithTitle:@"无数据"];
            [weakSelf.tableview.mj_header endRefreshing];
        }
    } FailureBlock:^(id error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.title = @"精炼时评";
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.current_touch_section = -1;
    
//    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"历史记录" target:self action:@selector(lookHistoryList)];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[RefiningTableViewCell class] forCellReuseIdentifier:@"refiningCell"];
    [self.tableview registerClass:[AnalysisForLabelTableViewCell class] forCellReuseIdentifier:@"labelCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"videoCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getRefiningData];
    }];
    [self.tableview.mj_header beginRefreshing];
    
    self.bottom_tool = [[UIView alloc] init];
    self.bottom_tool.backgroundColor = SetColor(238, 238, 238, 1);
    [self.view addSubview:self.bottom_tool];
    [self.bottom_tool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self setToolBarContent:self.bottom_tool];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 3) {
        return 1;
    }
    RefiningModel *model = self.dataArray[section];
    return model.son_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RefiningContentModel *model = self.dataArray[indexPath.section];
        if (model.publish_type == 1) {
            //表示是视频
            UITableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
            
            self.videoPlayer = [[SJVideoPlayer alloc] init];
            self.videoPlayer.disableAutoRotation = YES;
            [videoCell.contentView addSubview:self.videoPlayer.view];
            self.videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://lixingjiaoyu.oss-cn-hangzhou.aliyuncs.com/test/picture/1544002208873.mp4"]];
            self.videoPlayer.autoPlay = NO;
            [self.videoPlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(videoCell.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            //播放结束回调
            self.videoPlayer.playDidToEndExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
                [player play];
            };
            
            return videoCell;
        }else {
            AnalysisForLabelTableViewCell *labelCell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
            labelCell.content_label.text = model.content;
            return labelCell;
        }
    }else if (indexPath.section == 1 || indexPath.section == 2) {
        RefiningContentModel *model = self.dataArray[indexPath.section];
        AnalysisForLabelTableViewCell *labelCell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
        labelCell.content_label.text = model.content;
        return labelCell;
    }
    RefiningModel *model = self.dataArray[indexPath.section];
    RefiningSonModel *sonModel = model.son_array[indexPath.row];
    RefiningTableViewCell *cell = [RefiningTableViewCell creatRefiningCell:tableView withModel:sonModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 3) {
        RefiningContentModel *model = self.dataArray[indexPath.section];
        if (model.isOn) {
            return model.content_height;
        }else {
            return 0.0;
        }
        
    }
    RefiningModel *model = self.dataArray[indexPath.section];
    RefiningSonModel *sonModel = model.son_array[indexPath.row];
    return sonModel.son_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < 3) {
        return 40.0;
    }
    RefiningModel *model = self.dataArray[section];
    return model.content_string_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section < 2) {
        return 10.0;
    }else if (section == 2) {
        return 40.0;
    }
    RefiningModel *model = self.dataArray[section];
    return model.teacher_review_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section < 3) {
        RefiningContentSectionView *header_view = [[RefiningContentSectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40.0)];
        if (section == 0) {
            header_view.isShowButton = NO;
        }else {
            header_view.isShowButton = YES;
        }
        
        header_view.section = section;
        header_view.label.text = @[@"思考话题", @"资料分享", @"砺行点评"][section];
        __weak typeof(self) weakSelf = self;
        header_view.touchButtonChangeOnStatusAction = ^(NSInteger section) {
            RefiningContentModel *model = weakSelf.dataArray[section];
            model.isOn = !model.isOn;
            [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        };
        return header_view;
        
    }
    RefiningModel *model = self.dataArray[section];
    RefiningHeaderView *header_view = [RefiningHeaderView creatHeaderViewWithModel:model Frame:FRAME(0, 0, SCREENBOUNDS.width, 100.0)];
    header_view.section = section;
    header_view.delegate = self;
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section < 3) {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = SetColor(246, 246, 246, 1);
        if (section == 2) {
            [self setFooterView:header withSection:section];
        }
        return header;
    }
    RefiningModel *model = self.dataArray[section];
    RefiningFooterView *footer_view = [RefiningFooterView creatFooterViewWithModel:model Frame:FRAME(0, 0, SCREENBOUNDS.width, 50.0)];
    footer_view.delegate = self;
    return footer_view;
}

#pragma mark ************ header view *************
- (void)setHeaderView:(UIView *)header withSection:(NSInteger)section {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    label.text = @[@"思考话题", @"资料分享", @"砺行点评"][section];
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.mas_centerY);
        make.left.equalTo(header.mas_left).offset(20);
    }];
    
    
//    __weak typeof(self) weakSelf = self;
//    UILabel *label = [[UILabel alloc] init];
//    label.font = SetFont(18);
//    label.text = @"主题";
//    [header addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(header.mas_top).offset(10);
//        make.left.equalTo(header.mas_left).offset(20);
//    }];
//
//
//    CGFloat video_height = 0.0;
//    if (model.publish_type == 1) {
//        video_height = 260.0;
//    }
//
//    self.videoPlayer = [[SJVideoPlayer alloc] init];
//    [header addSubview:self.videoPlayer.view];
//    self.videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://lixingjiaoyu.oss-cn-hangzhou.aliyuncs.com/test/picture/1544002208873.mp4"]];
//    self.videoPlayer.autoPlay = NO;
//    [self.videoPlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(label.mas_bottom).offset(10);
//        make.left.equalTo(header.mas_left);
//        make.right.equalTo(header.mas_right);
//        make.height.mas_equalTo(video_height);
//    }];
//    //播放结束回调
//    self.videoPlayer.playDidToEndExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
//        [player play];
//    };
//
//    UILabel *content_label = [[UILabel alloc] init];
//    content_label.font = SetFont(14);
//    content_label.textColor = SetColor(74, 74, 74, 1);
//    content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
//    content_label.numberOfLines = 0;
//    content_label.text = model.content;
//    [header addSubview:content_label];
//    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.videoPlayer.view.mas_bottom).offset(10);
//        make.left.equalTo(label.mas_left);
//        make.right.equalTo(header.mas_right).offset(-20);
//    }];
//
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = SetColor(246, 246, 246, 1);
//    [header addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(content_label.mas_bottom).offset(10);
//        make.left.equalTo(header.mas_left);
//        make.right.equalTo(header.mas_right);
//        make.height.mas_equalTo(10);
//    }];
//
//    UILabel *bottom_label = [[UILabel alloc] init];
//    bottom_label.font = SetFont(18);
//    bottom_label.text = @"评论";
//    [header addSubview:bottom_label];
//    [bottom_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line.mas_bottom).offset(10);
//        make.left.equalTo(header.mas_left).offset(20);
//    }];
//
//    UIView *line1 = [[UIView alloc] init];
//    line1.backgroundColor = SetColor(246, 246, 246, 1);
//    [header addSubview:line1];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(header.mas_left);
//        make.right.equalTo(header.mas_right);
//        make.bottom.equalTo(header.mas_bottom);
//        make.height.mas_equalTo(1);
//    }];
}

- (void)setFooterView:(UIView *)footer_view withSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    label.text = @"评论";
    [footer_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footer_view.mas_centerY);
        make.left.equalTo(footer_view.mas_left).offset(20);
    }];
}

- (void)setToolBarContent:(UIView *)tool {
    //评论按钮
    UIButton *comment_button = [UIButton buttonWithType:UIButtonTypeCustom];
    comment_button.titleLabel.font = SetFont(14);
    [comment_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [comment_button setTitle:@"评论" forState:UIControlStateNormal];
    [comment_button addTarget:self action:@selector(submitCommentContentAction) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:comment_button];
    [comment_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tool.mas_right).offset(-10);
        make.centerY.equalTo(tool.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    //评论输入框
    self.input_comment_textfield = [[UITextField alloc] init];
    self.input_comment_textfield.backgroundColor = WhiteColor;
    
    self.input_comment_textfield.leftViewMode = UITextFieldViewModeAlways;
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 10, 10)];
    self.input_comment_textfield.leftView = left_label;
    
    self.input_comment_textfield.placeholder = @"写评论";
    ViewRadius(self.input_comment_textfield, 17.0);
    [tool addSubview:self.input_comment_textfield];
    [self.input_comment_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tool.mas_top).offset(8);
        make.left.equalTo(tool.mas_left).offset(20);
        make.bottom.equalTo(tool.mas_bottom).offset(-8);
        make.right.equalTo(comment_button.mas_left).offset(-10);
    }];
    
    //注册按钮通知
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    /* 增加监听（当键盘退出时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)submitCommentContentAction {
    if (self.dataArray.count == 0) {
        [self showHUDWithTitle:@"无内容"];
        return;
    }
//    RefiningContentModel *contentModel = self.dataArray[0];
    NSString *parent_id = @"";
    if (self.current_touch_section == -1) {
        //表示发表的是父评论
    }else {
        //表示发表的是子评论
        RefiningModel *model = self.dataArray[self.current_touch_section];
        parent_id = model.parent_id;
    }
    
    NSDictionary *param = @{
                            @"releaseDate":self.publishTimeInterval,
                            @"parentCommentsId":parent_id,
                            @"commentsContent":self.input_comment_textfield.text,
                            @"fileList":@[]
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/training/sum_com_from_app/insert_comment_new" Dic:param imageArray:@[] SuccessBlock:^(id responseObject) {
        NSLog(@"时评 评论数据 == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.input_comment_textfield.text = @"";
            [weakSelf.input_comment_textfield resignFirstResponder];
            [weakSelf showHUDWithTitle:@"评论成功"];
            [weakSelf getRefiningData];
        }else {
            [weakSelf showHUDWithTitle:@"评论失败"];
        }
    } FailureBlock:^(id error) {
        NSLog(@"时评 评论数据 error == %@", error);
        [weakSelf showHUDWithTitle:@"评论失败"];
    }];
}

#pragma mark ******* header delegate ******
- (void)returnCurrentTouchIndex:(NSInteger)section {
    self.current_touch_section = section;
    //指定第一响应者
    [self.input_comment_textfield becomeFirstResponder];
}

#pragma mark ******* footer delegate *******
- (void)touchPraiseButtonAction:(UIButton *)button withSection:(NSInteger)section {
    RefiningModel *model = self.dataArray[section];
    model.isPraise = !model.isPraise;
    if (model.isPraise) {
        model.praise_number = [NSString stringWithFormat:@"%ld", [model.praise_number integerValue] + 1];
    }else {
        model.praise_number = [NSString stringWithFormat:@"%ld", [model.praise_number integerValue] - 1];
    }
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

/** 键盘弹出 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
//    self.bottom_tool.hidden = NO;
}

/** 键盘退出 */
- (void)keyboardWillHide:(NSNotification *)aNotification  {
//    self.bottom_tool.hidden = YES;
}

#pragma mark ---- SJVideoPlayer  delegate    datasource
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
//            self.play_button.hidden = NO;
        }
//        self.play_button.hidden = NO;
    }
}

- (void)controlLayerNeedAppear:(__kindof SJBaseVideoPlayer *)videoPlayer {
    
}

- (void)controlLayerNeedDisappear:(__kindof SJBaseVideoPlayer *)videoPlayer {
    
}

/**
 查看历史记录
 */
- (void)lookHistoryList {
    
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
