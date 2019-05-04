//
//  CourseHomeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/10.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CourseHomeViewController.h"
#import "CourseTableViewCell.h"
#import "Course_TwoTableViewCell.h"
#import "BannerView.h"
#import "ScrollTextView.h"
#import "TrainingHomeViewController.h"
#import "CourseHome_CourseShopModel.h"
#import "EssayTests_HomeViewController.h"
#import "FiveRoundsTrainingViewController.h"
//商品详情
#import "ShoppigDetailsViewController.h"
//行测通关训练
#import "TrainingHomeViewController.h"
#import "BannerDetailsViewController.h"
#import "ClassViewController.h"
#import "PlayerViewController.h"
#import "PlayVideoViewController.h"
#import "CategoryShopViewController.h"

@interface CourseHomeViewController ()<UITableViewDelegate, UITableViewDataSource, BannerViewDelegate, ScrollTextViewDelegate>

@property (nonatomic, strong) UIButton *right_button;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSArray *shop_data_array;

/** 区分  最新   课程 */
@property (nonatomic, assign) NSInteger type_index;

@property (nonatomic, strong) NSArray *bannerData;

/** 直播数据 */
@property (nonatomic, strong) NSArray *liveData;

/** 录播数据 */
@property (nonatomic, strong) NSArray *recordedData;

@end

@implementation CourseHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/**
 获取除商品以外的课程首页的所有数据
 */
- (void)getCourseData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/find_home" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"course data === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.bannerData = responseObject[@"data"][@"course_home_banner_list"];
            //轮播图URL
            NSMutableArray *bannerUrl = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"course_home_banner_list"]) {
                [bannerUrl addObject:dic[@"path_"]];
            }
            
            //第一张图片URL
            NSString *first_image_url = [responseObject[@"data"][@"course_home_generalize_list"] count] > 0 ? responseObject[@"data"][@"course_home_generalize_list"][0][@"path_"] : @"";
            NSString *second_image_url = [responseObject[@"data"][@"course_home_library_list"] count] > 0 ? responseObject[@"data"][@"course_home_library_list"][0][@"path_"] : @"";
            
            //整理数据
            weakSelf.dataDic = @{
                                 @"bannerUrl":bannerUrl,
                                 @"first_image_url":first_image_url,
                                 @"lixingkuaibao":responseObject[@"data"][@"mall_message_list"],
                                 @"user_course_list_new":responseObject[@"data"][@"user_course_list"][@"user_latest_training_list"],
                                 @"user_course_list":responseObject[@"data"][@"user_course_list"][@"user_training_list"],
                                 @"fiveRounds_image_url":second_image_url,
                                 @"live_data":responseObject[@"data"][@"course_content_live_list"],
                                 @"recorded_data":responseObject[@"data"][@"course_content_recorded_list"]
                                 };
            [weakSelf getShopData];
        }else {
            [weakSelf.tableview.mj_header endRefreshing];
        }
    } FailureBlock:^(id error) {
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}

/**
 获取商品数据
 */
- (void)getShopData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/search_commodity" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"shop data === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *shop_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *shop_dic in responseObject[@"data"][@"rows"]) {
                CourseHome_CourseShopModel *model = [[CourseHome_CourseShopModel alloc] init];
                model.course_shop_id = shop_dic[@"id_"];
                model.image_url_string = [shop_dic[@"path_"] isKindOfClass:[NSNull class]] ? @"" : shop_dic[@"path_"];
                model.course_title_string = shop_dic[@"title_"];
                model.price_string = [NSString stringWithFormat:@"￥%.2f", [shop_dic[@"o_price_"] integerValue] / 100.0];
                model.pay_numbers_string = [NSString stringWithFormat:@"%ld人付款", [shop_dic[@"payment_number_"] integerValue]];
                model.good_evaluate_string = [NSString stringWithFormat:@"%@好评率", shop_dic[@"praise_rate_"]];
                model.tag_array = shop_dic[@"lable"];
                model.other_string = shop_dic[@"note"];
                [shop_array addObject:model];
            }
            weakSelf.shop_data_array = [shop_array copy];
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_header endRefreshing];
        }else {
            [weakSelf.tableview.mj_header endRefreshing];
        }
    } FailureBlock:^(id error) {
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.type_index = 0;
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.font = SetFont(32);
    label.text = @"课程";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(40);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    self.right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.right_button setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
    //    [right_button addTarget:self action:@selector(pushSchedule) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(self.right_button, 20.0);
    [self.view addSubview:self.right_button];
    [self.right_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[CourseTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[Course_TwoTableViewCell class] forCellReuseIdentifier:@"twoCell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(90, 0, 0, 0));
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCourseData];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.type_index == 0) {
            return [self.dataDic[@"user_course_list_new"] count];
        }else if (self.type_index == 1) {
            return [self.dataDic[@"user_course_list"] count];
        }else if (self.type_index == 2) {
            return [self.dataDic[@"live_data"] count];
        }else if (self.type_index == 3) {
            return [self.dataDic[@"recorded_data"] count];
        }
    }
    return self.shop_data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (self.type_index == 0) {
            NSDictionary *course_new = self.dataDic[@"user_course_list_new"][indexPath.row];
            cell.title_label.text = course_new[@"title_"];
            [cell.left_view sd_setImageWithURL:[NSURL URLWithString:course_new[@"path_"]] placeholderImage:[UIImage imageNamed:@"no_image"]];
        }else if (self.type_index == 1) {
            NSDictionary *course = self.dataDic[@"user_course_list"][indexPath.row];
            cell.title_label.text = course[@"title_"];
            [cell.left_view sd_setImageWithURL:[NSURL URLWithString:course[@"path_"]] placeholderImage:[UIImage imageNamed:@"no_image"]];
        }else if (self.type_index == 2) {
            //直播
            NSDictionary *liveData = self.dataDic[@"live_data"][indexPath.row];
            cell.title_label.text = liveData[@"title_"];
            [cell.left_view sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"no_image"]];
            
        }else if (self.type_index == 3) {
            //录播
            NSDictionary *liveData = self.dataDic[@"recorded_data"][indexPath.row];
            cell.title_label.text = liveData[@"title_"];
            [cell.left_view sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"no_image"]];
        }
        cell.touchButton.userInteractionEnabled = NO;
        [cell.touchButton setTitle:@"马上学习" forState:UIControlStateNormal];
        return cell;
    }
    Course_TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
    CourseHome_CourseShopModel *model = self.shop_data_array[indexPath.row];
    [cell.left_view sd_setImageWithURL:[NSURL URLWithString:model.image_url_string] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.title_label.text = model.course_title_string;
    cell.tag_array = model.tag_array;
    cell.price_label.text = model.price_string;
    cell.number_label.text = model.pay_numbers_string;
    cell.good_label.text = model.good_evaluate_string;
    cell.remark_label.text = model.other_string;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return Course_Cell_height;
    }
    return Course_Two_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 400.0;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 150.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    if (section == 0) {
        [self setOneHeaderView:header_view];
    }else {
        [self setSecondHeaderView:header_view];
    }
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    if (section == 0) {
        [self setFooterView:footer_view];
    }
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.type_index == 2) {
            NSDictionary *dic = self.dataDic[@"live_data"][indexPath.row];
            //直播
            PlayerViewController *weihou = [[PlayerViewController alloc] init];
            weihou.room_id = dic[@"room_id_"];
            [self.navigationController pushViewController:weihou animated:YES];
        }else if (self.type_index == 3) {
            NSDictionary *dic = self.dataDic[@"recorded_data"][indexPath.row];
            //录播
            PlayVideoViewController *playVideo = [[PlayVideoViewController alloc] init];
            playVideo.video_path = dic[@"path_"];
            [self.navigationController pushViewController:playVideo animated:YES];
            
        }else {
            NSInteger type;
            NSString *training_id = @"";
            if (self.type_index == 0) {
                NSDictionary *dic = self.dataDic[@"user_course_list_new"][indexPath.row];
                type = [dic[@"type_"] integerValue];
                training_id = dic[@"id_"];
            }else {
                NSDictionary *dic = self.dataDic[@"user_course_list"][indexPath.row];
                type = [dic[@"type_"] integerValue];
                training_id = dic[@"id_"];
            }
            
            if (type == 0) {
                NSLog(@"不是任何一种类型");
                return;
            }else if (type == 1) {
                //行测通关训练
                TrainingHomeViewController *home = [[TrainingHomeViewController alloc] init];
                home.training_id = training_id;
                [self.navigationController pushViewController:home animated:YES];
            }else if (type == 2) {
                //大申论通关训练入口
                EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
                home.TestTraining_id = training_id;
                home.type = ESSAY_TESTS_TYPE_BigTestTraining;
                [self.navigationController pushViewController:home animated:YES];
            }else if (type == 3) {
                //小申论通关训练入口
                EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
                home.TestTraining_id = training_id;
                home.type = ESSAY_TESTS_TYPE_SmallTestTraining;
                [self.navigationController pushViewController:home animated:YES];
            }
        }
    }else {
        CourseHome_CourseShopModel *model = self.shop_data_array[indexPath.row];
        ShoppigDetailsViewController *shopDetails = [[ShoppigDetailsViewController alloc] init];
        shopDetails.shop_id = model.course_shop_id;
        [self.navigationController pushViewController:shopDetails animated:YES];
    }
}

#pragma mark ---- Header -----
- (void)setOneHeaderView:(UIView *)header_view {
    header_view.backgroundColor = WhiteColor;
    
    BannerView *banner = [BannerView initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 170.0) withArray:self.dataDic[@"bannerUrl"] hasTimer:YES interval:2.0 isLocal:NO];
    banner.delegate = self;
    [header_view addSubview:banner];
    
    UIImageView *lixingClass = [[UIImageView alloc] init];
    [lixingClass sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"first_image_url"]] placeholderImage:[UIImage imageNamed:@"no_image"]];
    [header_view addSubview:lixingClass];
    [lixingClass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(banner.mas_bottom).offset(20);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(76.0);
    }];
    lixingClass.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushClassVC)];
    [lixingClass addGestureRecognizer:tapGes];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lixingClass.mas_bottom).offset(20);
        make.left.equalTo(header_view.mas_left);
        make.right.equalTo(header_view.mas_right);
        make.height.mas_equalTo(5);
    }];
    
    //砺行快报
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @"砺行快报";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    ScrollTextView *scrollText = [[ScrollTextView alloc] initWithFrame:FRAME(100, 290, SCREENBOUNDS.width - 120, 40) whitTextArray:@[]];
    scrollText.delegate = self;
    scrollText.titleArray = self.dataDic[@"lixingkuaibao"];
    [header_view addSubview:scrollText];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left);
        make.right.equalTo(header_view.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"课程", @"直播", @"点播"]];
    [segment setSelectedSegmentIndex:self.type_index];
    [segment addTarget:self action:@selector(changeTypeIndexAction:) forControlEvents:UIControlEventValueChanged];
    [header_view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(40.0);
    }];
}

- (void)setSecondHeaderView:(UIView *)header_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    label.text = @"砺行推荐";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
    
    UIButton *more_button = [UIButton buttonWithType:UIButtonTypeCustom];
    more_button.titleLabel.font = SetFont(14);
    [more_button setBackgroundColor:header_view.backgroundColor];
    [more_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [more_button setTitle:@"查看更多" forState:UIControlStateNormal];
    [header_view addSubview:more_button];
    [more_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
    [more_button addTarget:self action:@selector(touchLookMoreShopAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ---- footer ----
- (void)setFooterView:(UIView *)footer_view {
    footer_view.backgroundColor = WhiteColor;
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"fiveRounds_image_url"]] placeholderImage:[UIImage imageNamed:@"no_image"]];
    [footer_view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(15, 20, 15, 20));
    }];
    
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushTraingHomeVC)];
    [imageV addGestureRecognizer:tapGes];
}

/**
 跳转五轮训练
 */
- (void)pushTraingHomeVC {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/is_user_group" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            //是否是会员  0 == 不是  1 == 是
            NSInteger is_user_group = [responseObject[@"data"][@"is_user_group"] integerValue];
            if (is_user_group == 0) {
                //提醒去购买
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"非会员" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }else {
                FiveRoundsTrainingViewController *fiveRounds = [[FiveRoundsTrainingViewController alloc] init];
                [self.navigationController pushViewController:fiveRounds animated:YES];
            }
        }
    } FailureBlock:^(id error) {
        
    }];
}


/**
 课程   班级  segment

 @param segment segment
 */
- (void)changeTypeIndexAction:(UISegmentedControl *)segment {
    self.type_index = segment.selectedSegmentIndex;
    [self.tableview reloadData];
}

#pragma mark ---- banner delegate ----
- (void)carouselTouch:(BannerView *)carousel atIndex:(NSUInteger)index {
    NSString *bannerID = self.bannerData[index][@"link_path_"];
    BannerDetailsViewController *details = [[BannerDetailsViewController alloc] init];
    details.banner_id = bannerID;
    [self.navigationController pushViewController:details animated:YES];
}

/**
 重大通知点击方法
 
 @param indexDic indexDic
 */
- (void)touchScrollTextActionWithIndex:(NSDictionary *)indexDic {
    BannerDetailsViewController *details = [[BannerDetailsViewController alloc] init];
    details.banner_id = indexDic[@"link_path_"];
    [self.navigationController pushViewController:details animated:YES];
}

/** 跳转到班级页面 */
- (void)pushClassVC {
    ClassViewController *classVC = [[ClassViewController alloc] init];
    [self.navigationController pushViewController:classVC animated:YES];
}

/**
 点击查看更多商品
 */
- (void)touchLookMoreShopAction {
    CategoryShopViewController *shopVC = [[CategoryShopViewController alloc] init];
    [self.navigationController pushViewController:shopVC animated:YES];
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
