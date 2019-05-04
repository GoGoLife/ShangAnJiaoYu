//
//  CourseViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseTableViewCell.h"
#import "Course_TwoTableViewCell.h"
//横屏播放宣传片
#import "PlayVideoViewController.h"
//推荐课程
#import "RecommendCourseViewController.h"
//课后作业
#import "AfterClassWork_MoreViewController.h"
//我的课程
#import "My_CourseViewController.h"
//课程商品Model
#import "CourseHome_CourseShopModel.h"
#import "StoreHomeViewController.h"
//商品详情
#import "ShoppigDetailsViewController.h"
#import "DrillCollectionViewCell.h"
#import "ClassTableViewCell.h"
#import "BannerView.h"
#import "CategoryShopViewController.h"
//微吼
#import "PlayerViewController.h"

@interface CourseViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *tableview;

/** 判断当前展示的是我的课程 ===== 1   还是课后作业 ===== 2 */
@property (nonatomic, assign) NSInteger my_index;

/** 判断当前展示的是  课程 ===== 1   班级 ===== 2 */
@property (nonatomic, assign) NSInteger type_index;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSArray *category_image_array;

/** 推荐商品列表 */
@property (nonatomic, strong) NSArray *shop_recommend_array;

/** 商品数据 */
@property (nonatomic, strong) NSArray *shop_data_array;

@end

@implementation CourseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)getHttpData {
    NSDictionary *dic = @{};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/find_home" Dic:dic SuccessBlock:^(id responseObject) {
        NSLog(@"course Home data ==== %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf formatData:responseObject[@"data"]];
            //获取商品数据
            [self getShopData];
        }else {
        }
    } FailureBlock:^(id error) {
    }];
}
 
- (void)formatData:(NSDictionary *)httpData {
    //整理banner图数据
    NSMutableArray *banner = [NSMutableArray arrayWithCapacity:1];
    if ([httpData[@"course_home_banner_list"] count] > 0) {
        for (NSDictionary *banner_dic in httpData[@"course_home_banner_list"]) {
            [banner addObject:banner_dic[@"path_"]];
        }
    }else {
        [banner addObject:@""];
    }
    
    //整理我的课程数据
    NSMutableArray *my_course_data = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in httpData[@"user_course_list"][@"course_list"]) {
        CourseHome_MyCourseModel *model = [[CourseHome_MyCourseModel alloc] init];
        model.my_course_id = dic[@"course_id_"];
        model.my_course_type = [NSString stringWithFormat:@"%ld", [dic[@"type_"] integerValue]];
        model.image_string = dic[@"path_"];
        model.title_string = dic[@"title_"];
        model.timeLength = [dic[@"duration_"] integerValue];
        model.liveTime = [dic[@"start_time_"] integerValue];
        [my_course_data addObject:model];
    }
    
    //整理课后作业数据
    NSMutableArray *classAfter_data = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in httpData[@"user_course_list"][@"homework_list"]) {
        CourseHome_MyCourseModel *model = [[CourseHome_MyCourseModel alloc] init];
        model.my_course_id = dic[@"id_"];
        model.title_string = dic[@"title_"];
        model.detail_string = dic[@"content"];
        [classAfter_data addObject:model];
    }
    
    //商品分类列表
    NSMutableArray *shop_category_array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *shop_category in httpData[@"mall_type_module_list"]) {
        NSDictionary *dic = @{@"shop_category_id":shop_category[@"serial_number_"],
                              @"shop_category_path":shop_category[@"path_"],
                              @"shop_category_content":shop_category[@"content_"]
                              };
        [shop_category_array addObject:dic];
    }
    
    //image url
    NSString *image_url;
    if ([httpData[@"course_home_generalize_list"] count] > 0) {
        image_url = httpData[@"course_home_generalize_list"][0][@"path_"];
    }else {
        image_url = @"";
    }
    
    
    self.dataDic = @{
                     @"banner" : [banner copy],
                     @"center_image" : image_url,
                     @"my_course_data" : [my_course_data copy],
                     @"classAfter_data" : [classAfter_data copy],
                     @"shop_category_data" : [shop_category_array copy]
                     };
}

//获取商品数据
- (void)getShopData {
    NSMutableArray *shop_array = [NSMutableArray arrayWithCapacity:1];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/search_commodity" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"shop data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *shop_dic in responseObject[@"data"][@"rows"]) {
                CourseHome_CourseShopModel *model = [[CourseHome_CourseShopModel alloc] init];
                model.course_shop_id = shop_dic[@"commodityId"];
                model.image_url_string = [shop_dic[@"path_"] isKindOfClass:[NSNull class]] ? @"" : shop_dic[@"path_"];
                model.course_title_string = shop_dic[@"title_"];
                model.price_string = [NSString stringWithFormat:@"￥%.2f", [shop_dic[@"price_"] integerValue] / 100.0];
                model.pay_numbers_string = [NSString stringWithFormat:@"%ld人付款", [shop_dic[@"payment_number_"] integerValue]];
                model.tag_array = shop_dic[@"lable"];
                [shop_array addObject:model];
            }
            weakSelf.shop_data_array = [shop_array copy];
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_header endRefreshing];
        }else {
        }
    } FailureBlock:^(id error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.category_image_array = @[@[@"category_1", @"思维训练"],
                                  @[@"category_2", @"言语"],
                                  @[@"category_3", @"数量"],
                                  @[@"category_4", @"资料"],
                                  @[@"category_1", @"文化产品"],
                                  @[@"category_2", @"判断"],
                                  @[@"category_3", @"申论"],
                                  @[@"category_4", @"面试"]];
    self.type_index = 0;
    self.my_index = 0;
    [self setViewUI];
}

- (void)setViewUI {
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
    
    UIButton *right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_button setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
//    [right_button addTarget:self action:@selector(pushSchedule) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right_button];
    [right_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[CourseTableViewCell class] forCellReuseIdentifier:@"one"];
    [self.tableview registerClass:[Course_TwoTableViewCell class] forCellReuseIdentifier:@"two"];
    [self.tableview registerClass:[ClassTableViewCell class] forCellReuseIdentifier:@"class"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getHttpData];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        //判断是课程还是班级
        if (self.type_index == 1) {
            return 5;
        }
        return 0;
    }else if (section == 1) {
        if (self.type_index == 0) {
            if (self.my_index == 0) {
                //表示我的课程
                return [self.dataDic[@"my_course_data"] count];
            }else {
                //表示课后作业
                return [self.dataDic[@"classAfter_data"] count];
            }
        }else {
            return 0;
        }
    }else {
        if (self.type_index == 0) {
//            return 0;
//            return [self.dataDic[@"course_shop_data"][section-2][@"category_shop"] count];
            return self.shop_data_array.count;
        }else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //班级
        ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"class"];
        
        return cell;
    }else if (indexPath.section == 1) {
        CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
        if (self.my_index == 0) {
            //我的课程
            CourseHome_MyCourseModel *model = self.dataDic[@"my_course_data"][indexPath.row];
            if ([model.my_course_type isEqualToString:@"2"]) {
                [cell.touchButton setTitle:@"马上学习" forState:UIControlStateNormal];
                cell.tag_label.text = @"点播";
            }else if ([model.my_course_type isEqualToString:@"1"]) {
                [cell.touchButton setTitle:@"即将开始" forState:UIControlStateNormal];
                cell.tag_label.text = @"直播";
            }
            [cell.left_view sd_setImageWithURL:[NSURL URLWithString:model.image_string] placeholderImage:[UIImage imageNamed:@"no_image"]];
            cell.title_label.text = model.title_string;
            cell.detail_label.text = model.detail_string;
        }else {
            //课后作业
            CourseHome_MyCourseModel *model = self.dataDic[@"classAfter_data"][indexPath.row];
            [cell.touchButton setTitle:@"马上做题" forState:UIControlStateNormal];
            cell.title_label.text = model.title_string;
            cell.tag_label.text = @"";
            cell.detail_label.text = model.detail_string;
        }
        return cell;
    }
    Course_TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
    CourseHome_CourseShopModel *model = self.shop_data_array[indexPath.row];
    [cell.left_view sd_setImageWithURL:[NSURL URLWithString:model.image_url_string] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.title_label.text = model.course_title_string;
    cell.tag_array = model.tag_array;
    cell.price_label.text = model.price_string;
    cell.number_label.text = model.pay_numbers_string;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 105.0;
    }else if (indexPath.section == 1) {
        return Course_Cell_height;
    }
    return Course_Two_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 350.0;
    }else if (section == 1) {
        if (self.type_index == 0) {
            return 60.0;
        }
        return 0.0;
    }else {
        if (self.type_index == 0) {
            return 50.0;
        }
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (self.type_index == 0) {
            return 260.0;
        }
        return 0.0;
    }else {
        if (self.type_index == 0) {
            return 10.0;
        }
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    if (section == 0) {
        [self setFirstHeaderView:header_view];
    }else if (section == 1) {
        [self setSecondHeaderView:header_view];
    }else {
        [self setOtherHeaderView:header_view AndTitle:@"砺行推荐"];
    }
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = SetColor(246, 246, 246, 1);
    if (section == 1) {
        [self setFooterView:footer_view];
    }
    return footer_view;
}

#pragma mark ---- custom  action
//展示视频 和  图片   高度为286
- (void)setFirstHeaderView:(UIView *)header_view {
    header_view.backgroundColor = WhiteColor;
    //轮播图
    BannerView *banner = [BannerView initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 150) withArray:self.dataDic[@"banner"] hasTimer:YES interval:2.0 isLocal:NO];
    [header_view addSubview:banner];
    
    UIImageView *bottom_image = [[UIImageView alloc] init];
    [bottom_image sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"course_1"]];
    bottom_image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBottomAction)];
    [bottom_image addGestureRecognizer:tap1];
    [header_view addSubview:bottom_image];
    [bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.bottom.equalTo(header_view.mas_bottom).offset(-100);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(75.0);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = DetailTextColor;
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottom_image.mas_bottom).offset(20);
        make.left.equalTo(header_view.mas_left).offset(0);
        make.right.equalTo(header_view.mas_right).offset(0);
        make.height.mas_equalTo(10.0);
    }];
    
    //课程   班级
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"课程", @"班级"]];
    [segment setSelectedSegmentIndex:self.type_index];
    [segment addTarget:self action:@selector(changeTypeIndexAction:) forControlEvents:UIControlEventValueChanged];
    [header_view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(40.0);
    }];
}

//高度为60   我的课程    课后作业
- (void)setSecondHeaderView:(UIView *)header_view {
    header_view.backgroundColor = WhiteColor;
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"我的课程", @"课后作业"]];
    [segment setSelectedSegmentIndex:self.my_index];
    segment.tintColor = WhiteColor;
    [segment setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32.0]} forState:UIControlStateNormal];
    [segment setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32.0]} forState:UIControlStateSelected];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName : DetailTextColor} forState:UIControlStateNormal];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} forState:UIControlStateSelected];
    [segment addTarget:self action:@selector(changeIndexAction:) forControlEvents:UIControlEventValueChanged];
    [header_view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(238, 238, 238, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.bottom.equalTo(header_view.mas_bottom);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
}

//高度为50
- (void)setOtherHeaderView:(UIView *)header_view AndTitle:(NSString *)title {
    header_view.backgroundColor = WhiteColor;
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(18);
    title_label.text = title;
    [header_view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
    }];
}

//高度为150
- (void)setFooterView:(UIView *)footer_view {
    footer_view.backgroundColor = WhiteColor;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(238, 238, 238, 1);
    [footer_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer_view.mas_top);
        make.left.equalTo(footer_view.mas_left).offset(20);
        make.right.equalTo(footer_view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.titleLabel.font = SetFont(14);
    [right_button setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [right_button setTitle:@"查看更多" forState:UIControlStateNormal];
    [right_button addTarget:self action:@selector(pushMoreAction) forControlEvents:UIControlEventTouchUpInside];
    [footer_view addSubview:right_button];
    [right_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer_view.mas_top).offset(10);
        make.right.equalTo(footer_view.mas_right).offset(-20);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = SetColor(238, 238, 238, 1);
    [footer_view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(right_button.mas_bottom).offset(5);
        make.left.equalTo(footer_view.mas_left).offset(20);
        make.right.equalTo(footer_view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionview.backgroundColor = WhiteColor;
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [collectionview registerClass:[DrillCollectionViewCell class] forCellWithReuseIdentifier:@"collectionviewCell"];
    [footer_view addSubview:collectionview];
    [collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(right_button.mas_bottom).offset(10);
        make.left.equalTo(footer_view.mas_left).offset(0);
        make.right.equalTo(footer_view.mas_right).offset(0);
        make.bottom.equalTo(footer_view.mas_bottom).offset(0);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CourseHome_MyCourseModel *model = self.dataDic[@"my_course_data"][indexPath.row];
        if ([model.my_course_type isEqualToString:@"1"]) {
            //直播
            
        }else {
            //点播
//            PlayVideoViewController *play_video = [[PlayVideoViewController alloc] init];
//            [self.navigationController pushViewController:play_video animated:YES];
            
            //微吼  ID ： 612077993
            PlayerViewController *player = [[PlayerViewController alloc] init];
            [self.navigationController pushViewController:player animated:YES];
        }
        
    }else  if (indexPath.section == 2) {
        CourseHome_CourseShopModel *model = self.shop_data_array[indexPath.row];
        NSLog(@"%@", model);
        ShoppigDetailsViewController *details = [[ShoppigDetailsViewController alloc] init];
        details.shop_id = model.course_shop_id;
        [self.navigationController pushViewController:details animated:YES];
    }
}

//播放宣传片  方法未调用
- (void)touchPlayVideoAction {
    PlayVideoViewController *play_video = [[PlayVideoViewController alloc] init];
    [self.navigationController pushViewController:play_video animated:YES];
}

//推荐课程
- (void)touchBottomAction {
    RecommendCourseViewController *recommend = [[RecommendCourseViewController alloc] init];
    [self.navigationController pushViewController:recommend animated:YES];
}

//选择我的课程    课后作业
- (void)changeIndexAction:(UISegmentedControl *)segment {
    self.my_index = segment.selectedSegmentIndex;
    [self.tableview reloadData];
}

//选择 课程    班级
- (void)changeTypeIndexAction:(UISegmentedControl *)segment {
    self.type_index = segment.selectedSegmentIndex;
    [self.tableview reloadData];
}

//查看更多
- (void)pushMoreAction {
    if (self.my_index) {
        //课后作业    更多
        AfterClassWork_MoreViewController *afterClass = [[AfterClassWork_MoreViewController alloc] init];
        afterClass.title = @"我的课程";
        afterClass.isSelectCourse = NO;
        [self.navigationController pushViewController:afterClass animated:YES];
    }else {
        //我的课程更多
        My_CourseViewController *my_course = [[My_CourseViewController alloc] init];
        my_course.isSelectCourse = NO;
        [self.navigationController pushViewController:my_course animated:YES];
    }
}

//进入商城
- (void)pushStoreHomeAction {
    StoreHomeViewController *store = [[StoreHomeViewController alloc] init];
    [self.navigationController pushViewController:store animated:YES];
}

#pragma mark ------ collectionview delegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 30, 10, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 40.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREENBOUNDS.width - 60 - 40 * 3) / 4;
    return CGSizeMake(width, width + 25);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataDic[@"shop_category_data"] count];//self.category_image_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.dataDic[@"shop_category_data"][indexPath.row];
    DrillCollectionViewCell *oneCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionviewCell" forIndexPath:indexPath];
    [oneCell.imageV sd_setImageWithURL:[NSURL URLWithString:data[@"shop_category_path"]] placeholderImage:[UIImage imageNamed:@"date"]];
    oneCell.label.text = data[@"shop_category_content"]; //self.category_image_array[indexPath.row][1];
    return oneCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryShopViewController *shopVC = [[CategoryShopViewController alloc] init];
//    shopVC.category_id = [NSString stringWithFormat:@"%ld", indexPath.row + 3];
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
