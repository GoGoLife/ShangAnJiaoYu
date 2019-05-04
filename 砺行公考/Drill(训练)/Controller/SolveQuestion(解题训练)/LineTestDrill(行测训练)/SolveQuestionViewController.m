//
//  SolveQuestionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SolveQuestionViewController.h"
#import "FirstCollectionViewCell.h"
#import "SecondCollectionViewCell.h"
#import "VideoDetailViewController.h"
#import "BasicsHomeViewController.h"
#import "SolveFunctionViewController.h"
//全真题库
#import "ProvinceTestViewController.h"
//自选训练
#import "OptionalSolveViewController.h"
//申论Home
#import "EssayTests_HomeViewController.h"
#import "EssayTest_QuanZhenViewController.h"
#import "SpecializedViewController.h"
#import "LYSSlideMenuController.h"
//#import "EssayTestCorrectViewController.h"
//#import "CorrectHistoryViewController.h"
//#import "MyCorrectHistoryController.h"
#import "EssayCorrectSliderViewController.h"
#import "SearchTestsViewController.h"
#import "SimulationTestViewController.h"

@interface SolveQuestionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) LYSSlideMenuController *correctSlider;

@end

@implementation SolveQuestionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
    [self setBack];
}

- (void)setUI {
    __weak typeof(self) weakSelf = self;
    //解题训练
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(32);
    label.text = self.vc_title;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
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
    search.placeholder = @"输入试卷关键词...";
    [self.view addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.mas_equalTo(52);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = SetColor(246, 246, 246, 1);
    self.collectionview.showsVerticalScrollIndicator = NO;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[FirstCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionview registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:@"second"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(search.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
        {
            FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            NSString *imageNamed = @[@"drill_1", @"drill_2"][indexPath.row];
            cell.leftImageV.image = [UIImage imageNamed:imageNamed];
            cell.topLabel.text = @[@"公考基础能力训练", @"公考解题方法训练"][indexPath.row];
            cell.bottomLabel.text = @[@"一句话介绍基础训练库特点", @"一句话介绍解题方法训练库特点"][indexPath.row];
            cell.rightImageV.image = [UIImage imageNamed:@"right"];
            return cell;
        }
            break;
        case 2:
        {
            SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
            NSString *imageNamed = @[@"drill_3", @"drill_3", @"drill_4"][indexPath.row];
            cell.topImageV.image = [UIImage imageNamed:imageNamed];
            cell.centerLabel.text = @[@"全真题库", @"模拟考试", @"自选题库"][indexPath.row];
            cell.bottomLabel.text = @"";
            return cell;
        }
            break;
        case 3:
        {
            FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            NSString *imageNamed = @[@"drill_5", @"drill_6"][indexPath.row];
            cell.leftImageV.image = [UIImage imageNamed:imageNamed];
            cell.topLabel.text = @[@"小申论解题能力训练", @"大申论解题能力训练"][indexPath.row];
            cell.bottomLabel.text = @[@"一句话介绍基础训练库特点", @"一句话介绍解题方法训练库特点"][indexPath.row];
            cell.rightImageV.image = [UIImage imageNamed:@"right"];
            return cell;
        }
            break;
        case 4:
        {
            SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
            NSString *imageNamed = @[@"drill_7", @"drill_8"][indexPath.row];
            cell.topImageV.image = [UIImage imageNamed:imageNamed];
            cell.centerLabel.text = @[@"全真题库", @"专项训练"][indexPath.row];
            cell.bottomLabel.text = @"";
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    view.backgroundColor = WhiteColor;
    for (UIView *vv in view.subviews) {
        [vv removeFromSuperview];
    }
    
    if (indexPath.section == 0) {
        //题库使用指南
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:@"drill_9"];
        ViewRadius(imageV, 5.0);
        
        //添加点击事件
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetail)];
        [imageV addGestureRecognizer:tap];
        
        [view addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(10, 20, 10, 20));
        }];
        return view;
    }else if (indexPath.section == 1) {
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(22);
        label.text = @"行测解题训练";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(20);
        }];
        return view;
    }else if (indexPath.section == 3) {
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(22);
        label.text = @"申论解题训练";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(20);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:SetColor(48, 132, 252, 1)];
        button.titleLabel.font = SetFont(14);
        [button setTitle:@"申论批改" forState:UIControlStateNormal];
        ViewRadius(button, 15.0);
        [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(-20);
            make.centerY.equalTo(view.mas_centerY);
            make.width.mas_equalTo(80);
        }];
        //绑定方法
        [button addTarget:self action:@selector(pushEssayTestCorrectVC) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
    
    return view;
}

#pragma mark ------- collectionview  delegate  flowlayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1 || section == 3) {
        return 10.0;
    }
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1 || section == 3) {
        return 0.0;
    }
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 3) {
        return CGSizeMake(SCREENBOUNDS.width - 42, 80);
    }else if (indexPath.section == 2) {
        CGFloat width = (SCREENBOUNDS.width - 62) / 3;
        return CGSizeMake(width, 105);
    }else {
        CGFloat width = (SCREENBOUNDS.width - 52) / 2;
        return CGSizeMake(width, 105);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 4) {
        return CGSizeZero;
    }else if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 180.0);
    }
    return CGSizeMake(SCREENBOUNDS.width, 70.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *class_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"class_name"] ?: @"";
    if (indexPath.section == 1 && indexPath.row == 0) {
        //公考基础能力训练
        BasicsHomeViewController *basicsHome = [[BasicsHomeViewController alloc] init];
        [self.navigationController pushViewController:basicsHome animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"21A46E_Z5Pt2mbUkz" eventLabel:@"公考基础能力入口点击" attributes:@{@"class":class_name}];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        //公考解题方法训练
        SolveFunctionViewController *solveFunc = [[SolveFunctionViewController alloc] init];
        [self.navigationController pushViewController:solveFunc animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"SolveFunction000" eventLabel:@"公考解题方法训练入口点击" attributes:@{@"class":class_name}];
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        //全真题库
        ProvinceTestViewController *province = [[ProvinceTestViewController alloc] init];
        province.type = 1;
        [self.navigationController pushViewController:province animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"LineTestBank000" eventLabel:@"行测全真题库入口点击" attributes:@{@"class":class_name}];
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        //模拟考试
        SimulationTestViewController *simulation = [[SimulationTestViewController alloc] init];
        [self.navigationController pushViewController:simulation animated:YES];
        
    }else if (indexPath.section == 2 && indexPath.row == 2) {
        //自选题库
        OptionalSolveViewController *optional = [[OptionalSolveViewController alloc] init];
        [self.navigationController pushViewController:optional animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"LineTestOption000" eventLabel:@"行测自选题库入口点击" attributes:@{@"class":class_name}];
    }else if (indexPath.section == 3 && indexPath.row == 0) {
        //小申论
        EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
        home.type = SMALL_ESSAY_TESTS_TYPE;
        [self.navigationController pushViewController:home animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"SmallEssayTest000" eventLabel:@"小申论巡林入口点击" attributes:@{@"class":class_name}];
    }else if (indexPath.section == 3 && indexPath.row == 1) {
        //大申论
        EssayTests_HomeViewController *home = [[EssayTests_HomeViewController alloc] init];
        home.type = BIG_ESSAY_TESTS_TYPE;
        [self.navigationController pushViewController:home animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"BigEssayTest000" eventLabel:@"大申论训练入口点击" attributes:@{@"class":class_name}];
    }else if (indexPath.section == 4 && indexPath.row == 0) {
        //申论全真
        ProvinceTestViewController *province = [[ProvinceTestViewController alloc] init];
        province.type = 2;
        [self.navigationController pushViewController:province animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"EssayTestBank000" eventLabel:@"申论全真题库入口点击" attributes:@{@"class":class_name}];
    }else if (indexPath.section == 4 && indexPath.row == 1) {
        //专项训练
        SpecializedViewController *specialized = [[SpecializedViewController alloc] init];
        [self.navigationController pushViewController:specialized animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"EssayTestSpecial000" eventLabel:@"申论专项训练入口点击" attributes:@{@"class":class_name}];
    }
}

//跳转题库使用指南
- (void)pushDetail {
    VideoDetailViewController *detail = [[VideoDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

////申论批改
//- (LYSSlideMenuController *)correctSlider {
//    if (!_correctSlider) {
//        _correctSlider = [[LYSSlideMenuController alloc] init];
//        _correctSlider.title = @"申论批改";
//
//        //申论批改
//        EssayTestCorrectViewController *correrct = [[EssayTestCorrectViewController alloc] init];
//        //佳作批改
//        CorrectHistoryViewController *history = [[CorrectHistoryViewController alloc] init];
//        //我的批改
//        MyCorrectHistoryController *myCorrect = [[MyCorrectHistoryController alloc] init];
//
//        _correctSlider.controllers = @[correrct, history, myCorrect];
//        _correctSlider.titles = @[@"新申论批改", @"佳作批改录", @"我的批改记录"];
//
//        _correctSlider.titleColor = [UIColor blackColor];
//        _correctSlider.titleSelectColor = ButtonColor;
//        _correctSlider.bottomLineColor = ButtonColor;
//        _correctSlider.pageNumberOfItem = 3;
//        _correctSlider.currentItem = 0;
//    }
//    return _correctSlider;
//}

/**
 跳转申论批改
 */
- (void)pushEssayTestCorrectVC {
//    CorrectViewController *correct = [[CorrectViewController alloc] init];
//    [self.navigationController pushViewController:correct animated:YES];
//    [self.navigationController pushViewController:self.correctSlider animated:YES];
    EssayCorrectSliderViewController *correctSlider = [[EssayCorrectSliderViewController alloc] init];
    [self.navigationController pushViewController:correctSlider animated:YES];
}

#pragma mark ******* 点击搜索   试卷 ********
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self showHUD];
    NSDictionary *param = @{@"title":searchBar.text};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_fuzzy_exam_list" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"search test data === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            searchBar.text = @"";
            [searchBar resignFirstResponder];
            [weakSelf hidden];
            SearchTestsViewController *tests = [[SearchTestsViewController alloc] init];
            tests.dataArray = responseObject[@"data"][@"rows"];
            [weakSelf.navigationController pushViewController:tests animated:YES];
        }else {
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
