//
//  TrainingHomeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/10.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TrainingHomeViewController.h"
#import <SJVideoPlayer.h>
#import "View_Collectionview.h"
#import "TraningDoQuestionViewController.h"
#import "TrainingHomeModel.h"

@interface TrainingHomeViewController ()<UITableViewDelegate, UITableViewDataSource, SJVideoPlayerControlLayerDelegate, SJVideoPlayerControlLayerDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) SJPlayModel *playModel;

@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) TrainingHomeModel *model;

@property (nonatomic, strong) View_Collectionview *topView;

@end

@implementation TrainingHomeViewController

/** 加载进入页面的数据 */
- (void)getDataWithFirstEnterView {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"fiveTrainingId":self.training_id};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/find_five_training" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"dddddddd === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.model.training_id = responseObject[@"data"][@"fiveTrainId"];
            weakSelf.model.is_purchase = [responseObject[@"data"][@"is_purchase"] integerValue];
            weakSelf.model.video_file_url = [responseObject[@"data"][@"fileList"] count] == 0 ? @"" :  responseObject[@"data"][@"fileList"][0][@"path"];
            //分类
            NSMutableArray *category_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *category in responseObject[@"data"][@"train_node_type"]) {
                LineTest_Category_Model *model = [[LineTest_Category_Model alloc] init];
                model.lineTest_category_id = category[@"key"];
                model.lineTest_category_content = category[@"value"];
                [category_array addObject:model];
            }
            weakSelf.model.categoty_array = [category_array copy];
            //分类下的数据
            NSMutableArray *category_data_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"five_train_node_list"][@"rows"]) {
                CategoryUnderDataModel *model = [[CategoryUnderDataModel alloc] init];
                model.data_id = dic[@"fiveTrainNodeId"];
                model.data_title = dic[@"title"];
                model.exam_count = [dic[@"exam_count_"] integerValue];
                model.whetherFree = [dic[@"whetherFree"] integerValue];
                [category_data_array addObject:model];
            }
            weakSelf.model.dataInCategoty_array = [category_data_array copy];
            weakSelf.topView.dataArr = weakSelf.model.categoty_array;
            [weakSelf.tableview reloadData];
            weakSelf.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:weakSelf.model.video_file_url] playModel:weakSelf.playModel];
        }
        [weakSelf.tableview.mj_header endRefreshing];
    } FailureBlock:^(id error) {
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}

/**
 根据分类ID  获取节点数据

 @param category_id 分类ID
 */
- (void)getDataWithCategoryID:(NSString *)category_id {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"fiveTrainingId":self.model.training_id,@"twoType":category_id};
    NSLog(@"param == %@", param);
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_choice_list" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"response == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            //分类下的数据
            NSMutableArray *category_data_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"rows"]) {
                CategoryUnderDataModel *model = [[CategoryUnderDataModel alloc] init];
                model.data_id = dic[@"fiveTrainNodeId"];
                model.data_title = dic[@"title"];
                model.exam_count = [dic[@"exam_count_"] integerValue];
                [category_data_array addObject:model];
            }
            weakSelf.model.dataInCategoty_array = [category_data_array copy];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.model = [[TrainingHomeModel alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    self.playModel = [SJPlayModel new];
    self.player = [[SJVideoPlayer alloc] init];
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
    
    //分类
    self.topView = [[View_Collectionview alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.player.view.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.mas_equalTo(65);
    }];
    //点击某个分类
    self.topView.returnSelectedIndex = ^(NSIndexPath *indexPath) {
        LineTest_Category_Model *model = weakSelf.model.categoty_array[indexPath.row];
        NSString *catecory_id = model.lineTest_category_id;
        //获取数据
        [weakSelf getDataWithCategoryID:catecory_id];
    };
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topView.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithFirstEnterView];
    }];
    [self.tableview.mj_header beginRefreshing];
}

#pragma mark ---- tableview delegate datasource -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.dataInCategoty_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryUnderDataModel *model = self.model.dataInCategoty_array[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = SetFont(14);
    cell.textLabel.text = model.data_title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self isPushDeQuestionViewWithModel:self.model IndexPath:indexPath];
}

/**
 判断是否跳转

 @param model HomeModel
 @param indexPath indexPath
 */
- (void)isPushDeQuestionViewWithModel:(TrainingHomeModel *)model IndexPath:(NSIndexPath *)indexPath {
    CategoryUnderDataModel *dataModel = model.dataInCategoty_array[indexPath.row];
    if (model.is_purchase == 1 || dataModel.whetherFree == 0) {
        //已购买 或者 免费  直接跳转
        [self pushVC:dataModel];
        
    }else {
        //未购买  并且  不免费  请求接口
        //请求是否是会员的接口
        __weak typeof(self) weakSelf = self;
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/is_user_group" Dic:@{} SuccessBlock:^(id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1) {
                //是否是会员  0 == 不是  1 == 是
                NSInteger is_user_group = [responseObject[@"data"][@"is_user_group"] integerValue];
                //是否有效   针对用户按时间购买课程
                NSInteger is_period_validity = [responseObject[@"data"][@"is_period_validity"] integerValue];
                //剩余次数   针对用户按次数购买课程
                NSInteger remaining_number = [responseObject[@"data"][@"remaining_number"] integerValue];
                if (is_user_group == 1 || is_period_validity == 1 || remaining_number > 0) {
                    //是会员 或者 有效  或者  剩余次数大于0   则可以直接做题
                    if (remaining_number > 0) {
                        //请求接口  有效次数 - 1
                        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/insert_user_mall_use_count" Dic:@{} SuccessBlock:^(id responseObject) {
                            if ([responseObject[@"state"] integerValue] == 1) {
                                //有效次数 - 1 成功
                                //直接跳转
                                [weakSelf pushVC:dataModel];
                            }
                        } FailureBlock:^(id error) {
                            
                        }];
                    }else {
                        //直接跳转
                        [weakSelf pushVC:dataModel];
                    }
                }else {
                    //提醒去购买
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"去商城购买" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
            }
        } FailureBlock:^(id error) {
            
        }];
    }
}


/**
 跳转做题界面
 */
- (void)pushVC:(CategoryUnderDataModel *)model {
    [[NSUserDefaults standardUserDefaults] setObject:model.data_id forKey:@"current_exam_id"];
    TraningDoQuestionViewController *traningDoQuestion = [[TraningDoQuestionViewController alloc] init];
    traningDoQuestion.training_id = model.data_id;
    traningDoQuestion.doType = DoQuestionType_Training_First;
    traningDoQuestion.isShowPlayer = YES;
    //记录行测通关训练的试卷总数量
    [[NSUserDefaults standardUserDefaults] setObject:@(model.exam_count) forKey:@"lineTestExamCount"];
    [self.navigationController pushViewController:traningDoQuestion animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
