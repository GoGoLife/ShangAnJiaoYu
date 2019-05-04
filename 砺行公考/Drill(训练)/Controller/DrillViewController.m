//
//  DrillViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DrillViewController.h"
#import "ScheduleViewController.h"
#import "DrillCollectionViewCell.h"
#import "BannerView.h"
#import "ScrollTextView.h"
//解题训练
#import "SolveQuestionViewController.h"
#import "ShortcutViewController.h"
#import "ShortcutModel.h"
#import "ChatViewController.h"
//#import "ThinkHomeViewController.h"
#import "RefiningViewController.h"
#import "SearchQuestionViewController.h"
//摘记本
#import "DigestBookViewController.h"

#import "DealViewController.h"
#import "BannerDetailsViewController.h"
#import "ProvinceTestViewController.h"

@interface DrillViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, BannerViewDelegate, ScrollTextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

//放在section
@property (nonatomic, strong) UICollectionView *collectionV;

//日期按钮
@property (nonatomic, strong) UIButton *pushScheduleVC;

@property (nonatomic, assign) BOOL firstIn;

@property (nonatomic, strong) NSMutableArray *showDataArray;

/** 只有image数据 */
@property (nonatomic, strong) NSArray *show_banner_image_url_array;

/** 轮播图原始数据 */
@property (nonatomic, strong) NSArray *bannerData;

/** 解题训练背景图 */
@property (nonatomic, strong) NSString *one_image_url;

/** 日思万里背景图 */
@property (nonatomic, strong) NSString *two_image_url;

/** 重大通知数据 */
@property (nonatomic, strong) NSArray *scrollTextData;

@property (nonatomic, strong) ScrollTextView *scrollT;

@end

@implementation DrillViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getShortcutVCFromDataBase];
    
    if (self.firstIn) {
        self.firstIn = NO;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
    self.showDataArray = [NSMutableArray arrayWithCapacity:1];
    [self setUI];
}

- (void)getShowImageData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_home" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"home image == %@", responseObject);
            
            weakSelf.scrollTextData = responseObject[@"data"][@"training_message_list"];
            
            //第一张图片
            NSString *one_image = [responseObject[@"data"][@"training_home_banner_down_one_list"] count] == 0 ? @"" : responseObject[@"data"][@"training_home_banner_down_one_list"][0][@"path_"];
            
            NSString *two_image = [responseObject[@"data"][@"training_home_banner_down_two_list"] count] == 0 ? @"" : responseObject[@"data"][@"training_home_banner_down_two_list"][0][@"path_"];
            
            weakSelf.bannerData = responseObject[@"data"][@"training_home_banner_list"];
            weakSelf.one_image_url = one_image;//responseObject[@"data"][@"training_home_banner_down_one_list"][0][@"path_"];
            weakSelf.two_image_url = two_image;//responseObject[@"data"][@"training_home_banner_down_two_list"][0][@"path_"];
            NSMutableArray *banner_url_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *imageDic in responseObject[@"data"][@"training_home_banner_list"]) {
                [banner_url_array addObject:imageDic[@"path_"]];
            }
            weakSelf.show_banner_image_url_array = [banner_url_array copy];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        }else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    } FailureBlock:^(id error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)setUI {
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.font = SetFont(32);
    label.text = @"训练";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(40);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    self.pushScheduleVC = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pushScheduleVC setImage:[UIImage imageNamed:@"richeng"] forState:UIControlStateNormal];
    [self.pushScheduleVC addTarget:self action:@selector(pushSchedule) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pushScheduleVC];
    [self.pushScheduleVC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UISearchBar *search = [[UISearchBar alloc] init];
    search.delegate = self;
    search.tintColor = [UIColor whiteColor];
    search.barTintColor = [UIColor whiteColor];
    UIImage *backImage = [self GetImageWithColor:[UIColor whiteColor] andHeight:32.0];
    search.backgroundImage = backImage;
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    searchTextField = [[[search.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = SetColor(246, 246, 246, 1);
    search.placeholder = @"输入题目关键词...";
    [self.view addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.mas_equalTo(52);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableview"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(search.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getShowImageData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ----- tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableview"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setTableviewCellContent:cell IndexPath:indexPath];
    return cell;
}

- (void)setTableviewCellContent:(UITableViewCell *)cell IndexPath:(NSIndexPath *)indexPath {
    NSData *one_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.one_image_url]];
    NSData *two_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.two_image_url]];
    UIView *back_view = [[UIView alloc] init];
    if (self.one_image_url && self.two_image_url) {
        UIImage *image_named = @[[UIImage imageWithData:one_data], [UIImage imageWithData:two_data]][indexPath.row];
        back_view.layer.contents = (id)image_named.CGImage;
    }
    [cell.contentView addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    
//    UILabel *top_label = [[UILabel alloc] init];
//    top_label.font = SetFont(26);
//    top_label.textColor = WhiteColor;
//    top_label.text = @[@"解题训练", @"日思万里"][indexPath.row];
//    [back_view addSubview:top_label];
//    [top_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(back_view.mas_top).offset(20);
//        make.left.equalTo(back_view.mas_left).offset(20);
//    }];
//
//    UILabel *detail_label = [[UILabel alloc] init];
//    detail_label.font = SetFont(14);
//    detail_label.textColor = SetColor(221, 221, 221, 1);
//    detail_label.text = @"一句话介绍解题训练特点";
//    [back_view addSubview:detail_label];
//    [detail_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(top_label.mas_bottom).offset(10);
//        make.left.equalTo(back_view.mas_left).offset(20);
//    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backgroundView = [[UIView alloc] init];
    if (section == 0) {
        BannerView *banner = [BannerView initWithFrame:FRAME(20, 0, SCREENBOUNDS.width - 40, 150) withArray:self.show_banner_image_url_array hasTimer:YES interval:2.0 isLocal:NO];
        banner.delegate = self;
        ViewRadius(banner, 8.0);
        [backgroundView addSubview:banner];
        return backgroundView;
    }else {
        //添加collectionview
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30);
        layout.minimumLineSpacing = 40;
        layout.minimumInteritemSpacing = 40.0;
        CGFloat width = (SCREENBOUNDS.width - 180 - 80) / 4;
        layout.itemSize = CGSizeMake(width, width + 25);
        
        self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionV.backgroundColor = [UIColor whiteColor];
        self.collectionV.pagingEnabled = YES;
        /// 设置此属性为yes 不满一屏幕 也能滚动
        self.collectionV.alwaysBounceHorizontal = YES;
        self.collectionV.showsHorizontalScrollIndicator = NO;
        self.collectionV.delegate = self;
        self.collectionV.dataSource = self;
        [self.collectionV registerClass:[DrillCollectionViewCell class] forCellWithReuseIdentifier:@"drill"];
        [backgroundView addSubview:self.collectionV];
        [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(backgroundView).insets(UIEdgeInsetsMake(0, 0, 20, 0));
        }];
        return backgroundView;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    
//    for (UIView *vv in footer.subviews) {
//        [vv removeFromSuperview];
//    }
    
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:FRAME(20, 0, SCREENBOUNDS.width - 40, 1)];
    line.backgroundColor = LineColor;
    [footer addSubview:line];
    
    //重大通知
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:FRAME(20, 15, 0, 30)];
    leftLabel.font = SetFont(18);
    leftLabel.textColor = [UIColor blueColor];
    leftLabel.text  = @"重大通知";
    [leftLabel sizeToFit];
    [footer addSubview:leftLabel];
    
    //文本滚动视图
    CGFloat width = CGRectGetMaxX(self.view.frame) - CGRectGetMaxX(leftLabel.frame) - 25;
//<<<<<<< HEAD
    self.scrollT = [[ScrollTextView alloc] initWithFrame:FRAME(CGRectGetMaxX(leftLabel.frame), 10, width, 30) whitTextArray:nil];
    self.scrollT.titleArray = self.scrollTextData;
    self.scrollT.delegate = self;
    [footer addSubview:self.scrollT];
    
//    //向右箭头
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:FRAME(CGRectGetMaxX(self.scrollT.frame) + 5, 15, 10, 20)];
////=======
//    ScrollTextView *scrollT = [[ScrollTextView alloc] initWithFrame:FRAME(CGRectGetMaxX(leftLabel.frame), 10, width, 30) whitTextArray:nil];
//    scrollT.delegate = self;
//    scrollT.titleArray = self.scrollTextData ?: @[];
//    [footer addSubview:scrollT];
    
    //向右箭头
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:FRAME(CGRectGetMaxX(self.scrollT.frame) + 5, 15, 10, 20)];
//>>>>>>> 2ee33111534adcaf044fff913e5325f7bb6f7fdf
    imageV.image = [UIImage imageNamed:@"right"];
    [footer addSubview:imageV];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat width = (SCREENBOUNDS.width - 180) / 4;
    return section == 0 ? 150.0 : width + 25 + 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 60.0 : 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        //解题训练
        SolveQuestionViewController *solve = [[SolveQuestionViewController alloc] init];
        solve.vc_title = @"解题训练";
        [self.navigationController pushViewController:solve animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
//        ThinkHomeViewController *think = [[ThinkHomeViewController alloc] init];
//        think.title = @"日思万里";
//        [self.navigationController pushViewController:think animated:YES];
        RefiningViewController *refining = [[RefiningViewController alloc] init];
        refining.title = @"精炼时评";
        [self.navigationController pushViewController:refining animated:YES];
    }
}

#pragma mark ---- collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showDataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DrillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"drill" forIndexPath:indexPath];
    if (indexPath.row == self.showDataArray.count) {
        cell.imageV.image = [UIImage imageNamed:@"drill_add_shortcut"];
        cell.label.text = @"添加";
    }else {
        ShortcutModel *model = self.showDataArray[indexPath.row];
        cell.imageV.image = [UIImage imageNamed:model.imageNamed];
        cell.label.text = model.title;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.showDataArray.count) {
        //跳转选择快捷入口
        ShortcutViewController *shortcut = [[ShortcutViewController alloc] init];
        [self.navigationController pushViewController:shortcut animated:YES];
    }else {
        ShortcutModel *model = self.showDataArray[indexPath.row];
        if ([model.categoryModel isEqualToString:@"3"]) {
            ChatViewController *push_vc = [(ChatViewController *)[NSClassFromString(model.targetVCNamed) alloc] initWithConversationChatter:model.targetData conversationType:EMConversationTypeGroupChat];
            push_vc.type = CHAT_TYPE_OFFICIAL_GROUP;
            [self.navigationController pushViewController:push_vc animated:YES];
        }else if ([model.title isEqualToString:@"摘记本"]) {
            DigestBookViewController *digestBookVC = (DigestBookViewController *)[[NSClassFromString(model.targetVCNamed) alloc] init];
            digestBookVC.isShowAddOrChangeCell = YES;
            [self.navigationController pushViewController:digestBookVC animated:YES];
        }else if ([model.title isEqualToString:@"申论全真题库"]) {
            ProvinceTestViewController *province = (ProvinceTestViewController *)[[NSClassFromString(model.targetVCNamed) alloc] init];
            province.type = 2;
            [self.navigationController pushViewController:province animated:YES];
        }else if ([model.title isEqualToString:@"行测全真题库"]) {
            ProvinceTestViewController *province = (ProvinceTestViewController *)[[NSClassFromString(model.targetVCNamed) alloc] init];
            province.type = 1;
            [self.navigationController pushViewController:province animated:YES];
        } else {
            UIViewController *push_vc = [[NSClassFromString(model.targetVCNamed) alloc] init];
            [self.navigationController pushViewController:push_vc animated:YES];
        }
    }
}

//跳转进入我的日程
- (void)pushSchedule {
    ScheduleViewController *schedule = [[ScheduleViewController alloc] init];
    [self.navigationController pushViewController:schedule animated:YES];
}

// 在view中重写以下方法，其中self.button就是那个希望被触发点击事件的按钮
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super.view hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.pushScheduleVC convertPoint:point fromView:self.view];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.pushScheduleVC.bounds, newPoint)) {
            view = self.pushScheduleVC;
        }
    }
    return view;
}

/**
 在数据库中查找需要显示的快捷入口
 快捷入口
 */
- (void)getShortcutVCFromDataBase {
    [self.showDataArray removeAllObjects];
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    //拼接SQL语句
    NSString *search_sql_string = [NSString stringWithFormat:@"select * from t_shortcut where isShow = '%@'", @"1"];
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:search_sql_string];
        while ([result next]) {
            ShortcutModel *model = [[ShortcutModel alloc] init];
            NSString *imageNamed = [result stringForColumn:@"imageNamed"];
            NSString *imageUrl = [result stringForColumn:@"imageUrl"];
            NSString *title = [result stringForColumn:@"title"];
            NSString *isShow = [result stringForColumn:@"isShow"];
            NSString *categoryModel = [result stringForColumn:@"categoryModel"];
            NSString *targetVCNamed = [result stringForColumn:@"targetVCNamed"];
            NSString *targetData = [result stringForColumn:@"targetData"];
            model.imageNamed = imageNamed;
            model.imageUrl = imageUrl;
            model.title = title;
            model.isShow = isShow;
            model.categoryModel = categoryModel;
            model.targetVCNamed = targetVCNamed;
            model.targetData = targetData;
            [self.showDataArray addObject:model];
        }
        [self.collectionV reloadData];
    }
    //关闭数据库
    [dataBase close];
}

#pragma mark ********* 搜索题目 ********
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self showHUD];
    NSDictionary *param = @{@"title":searchBar.text};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_all_topic_list" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"search question data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            searchBar.text = @"";
            [searchBar resignFirstResponder];
            [weakSelf hidden];
            SearchQuestionViewController *searchQuestionVC = [[SearchQuestionViewController alloc] init];
            searchQuestionVC.dataArray = responseObject[@"data"][@"rows"];
            [self.navigationController pushViewController:searchQuestionVC animated:YES];
        }else {
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
}

#pragma mark --- banner delegate ---
- (void)carouselTouch:(BannerView*)carousel atIndex:(NSUInteger)index {
    NSLog(@"index == %ld", index);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
