//
//  MineViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderViewCollectionReusableView.h"
#import "MineCollectionViewCell.h"
#import "DrillCollectionViewCell.h"
//总结本
#import "SummarizeBookViewController.h"
//摘记本
#import "DigestBookViewController.h"
//优题本
#import "ExcellentBookViewController.h"
//错题本
//#import "ErrorQuestionBookViewController.h"
//#import "NewErrorQuestionBookViewController.h"
#import "ErrorBookThreeViewController.h"
#import "MyPartnerDynamicViewController.h"
#import "UseDiscountViewController.h"
#import "NoUseDiscountViewController.h"
//我的订单
#import "MyOrderLYSSliderVC.h"
#import "CartHomeViewController.h"
#import "ProveViewController.h"
#import "HelpAndAboutViewController.h"
#import "SettingViewController.h"
#import "InvatationViewController.h"

@interface MineViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionview;

//优惠券
@property (nonatomic, strong) LYSSlideMenuController *discountsSlider;

@property (nonatomic, strong) NSDictionary *user_data_dic;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

/** 根据环信ID  去查询用户信息 */
- (void)getUserInfoData {
    NSDictionary *parma = @{@"im_name_":[[NSUserDefaults standardUserDefaults] objectForKey:@"huanxinID"]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_user_message" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.user_data_dic = @{@"user_name":[responseObject[@"data"][@"nickname"] isEqualToString:@""] ? responseObject[@"data"][@"name_"] : responseObject[@"data"][@"nickname"],
                                       @"user_sex":responseObject[@"data"][@"sex_"],
                                       @"ability_points_":[NSString stringWithFormat:@"%ld", [responseObject[@"data"][@"ability_points_"] integerValue]],
                                       @"picture":responseObject[@"data"][@"picture"],
                                       @"user_phone" : responseObject[@"data"][@"name_"]
                                       };
            [weakSelf.collectionview reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
//    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = [UIColor whiteColor];
//    label.font = SetFont(32);
//    label.text = @"我的";
//    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view.mas_top).offset(20);
//        make.left.equalTo(weakSelf.view.mas_left).offset(10);
//    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[MineHeaderViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"oneHeader"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"twoHeader"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionview registerClass:[DrillCollectionViewCell class] forCellWithReuseIdentifier:@"oneCell"];
    [self.collectionview registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:@"twoCell"];
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    [self getUserInfoData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo) name:@"ChangeUserInfoNotifacation" object:nil];
}

- (void)changeUserInfo {
    [self getUserInfoData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 5;
            break;
        case 3:
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
                DrillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"oneCell" forIndexPath:indexPath];
                cell.imageV.image = [UIImage imageNamed:@[@"book_1", @"book_2", @"book_3", @"book_4"][indexPath.row]];
                cell.label.text = @[@"错题本", @"优题本", @"总结本", @"摘记本"][indexPath.row];
                return cell;
            }
            break;
        case 2:
            {
                MineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"twoCell" forIndexPath:indexPath];
                
                cell.content_textfield.text = @[@"  优惠券", @"  我的订单", @"  购物车", @"  经济困难学生认证服务", @"  邀请好友加入砺行"][indexPath.row];
                cell.left_image_name = @[@"mine_disCounts",@"mine_order",@"mine_cars",@"mine_certification",@"mine_invitation"][indexPath.row];
                return cell;
            }
            break;
        case 3:
            {
                MineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"twoCell" forIndexPath:indexPath];
                cell.content_textfield.text = @[@"  设置", @"  帮助与关于"][indexPath.row];
                cell.left_image_name = @[@"mine_setting",@"mine_help"][indexPath.row];
                return cell;
            }
            break;
            
        default:
            return nil;
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return UIEdgeInsetsMake(0, 30, 20, 30);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 64.0;
    }
    return 0.0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CGFloat width = (SCREENBOUNDS.width - 64 * 3 - 30 * 2) / 4;
        return CGSizeMake(width, width + 25);
    }else {
        return CGSizeMake(SCREENBOUNDS.width, 56);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 120.0);
    }else if (section == 1) {
        return CGSizeMake(SCREENBOUNDS.width, 56.0);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREENBOUNDS.width, 10.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            MineHeaderViewCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"oneHeader" forIndexPath:indexPath];
            header.name_label.text = self.user_data_dic[@"user_name"];
            header.sex_image.image = [UIImage imageNamed:@"date"];
            [header.header_image sd_setImageWithURL:[NSURL URLWithString:self.user_data_dic[@"picture"]] placeholderImage:[UIImage imageNamed:@"date"]];
            
            //头像添加点击事件
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHeaderImageAction)];
            header.header_image.userInteractionEnabled = YES;
            [header.header_image addGestureRecognizer:tapGes];
            
            return header;
        }else if (indexPath.section == 1) {
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"twoHeader" forIndexPath:indexPath];
            for (UIView *vv in header.subviews) {
                [vv removeFromSuperview];
            }
            UILabel *label = [[UILabel alloc] init];
            label.font = SetFont(16);
            label.text = @"我的笔记本";
            [header addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(header.mas_left).offset(20);
                make.centerY.equalTo(header.mas_centerY);
            }];
            return header;
        }
        return nil;
    }
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    footer.backgroundColor = SetColor(238, 238, 238, 1);
    return footer;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                //错题本
//                ErrorQuestionBookViewController *errorBook = [[ErrorQuestionBookViewController alloc] init];
//                [self.navigationController pushViewController:errorBook animated:YES];
//                NewErrorQuestionBookViewController *new_error = [[NewErrorQuestionBookViewController alloc] init];
//                [self.navigationController pushViewController:new_error animated:YES];
                ErrorBookThreeViewController *errorBook = [[ErrorBookThreeViewController alloc] init];
                [self.navigationController pushViewController:errorBook animated:YES];
            }
                break;
            case 1:
            {
                //优题本
                ExcellentBookViewController *excellent = [[ExcellentBookViewController alloc] init];
                [self.navigationController pushViewController:excellent animated:YES];
            }
                break;
            case 2:
            {
                //总结本
                SummarizeBookViewController *summarize = [[SummarizeBookViewController alloc] init];
                [self.navigationController pushViewController:summarize animated:YES];
            }
                break;
            case 3:
            {
                //摘记本
                DigestBookViewController *digest = [[DigestBookViewController alloc] init];
                digest.isShowAddOrChangeCell = YES;
                [self.navigationController pushViewController:digest animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                //优惠券
                [self.navigationController pushViewController:self.discountsSlider animated:YES];
            }
                break;
            case 1:
            {
                MyOrderLYSSliderVC *myOrder = [[MyOrderLYSSliderVC alloc] init];
                [self.navigationController pushViewController:myOrder animated:YES];
            }
                break;
            case 2:
            {
                CartHomeViewController *cartHome = [[CartHomeViewController alloc] init];
                [self.navigationController pushViewController:cartHome animated:YES];
            }
                break;
            case 3:
            {
                ProveViewController *prove = [[ProveViewController alloc] init];
                [self.navigationController pushViewController:prove animated:YES];
            }
                break;
            case 4:
            {
                InvatationViewController *invatation = [[InvatationViewController alloc] init];
                [self.navigationController pushViewController:invatation animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            //设置
            SettingViewController *setting = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:setting animated:YES];
            
        }else {
            //帮助与关于
            HelpAndAboutViewController *help = [[HelpAndAboutViewController alloc] init];
            [self.navigationController pushViewController:help animated:YES];
        }
    }
}

//点击头像方法
- (void)touchHeaderImageAction {
    NSLog(@"-------");
    MyPartnerDynamicViewController *partner = [[MyPartnerDynamicViewController alloc] init];
    partner.phone = self.user_data_dic[@"user_phone"];
    [self.navigationController pushViewController:partner animated:YES];
}

#pragma mark ----- 懒加载
- (LYSSlideMenuController *)discountsSlider {
    if (!_discountsSlider) {
        _discountsSlider = [[LYSSlideMenuController alloc] init];
        _discountsSlider.title = @"优惠劵";
        
        UseDiscountViewController *use = [[UseDiscountViewController alloc] init];
        NoUseDiscountViewController *noUse = [[NoUseDiscountViewController alloc] init];
        
        _discountsSlider.controllers = @[use, noUse];
        _discountsSlider.titles = @[@"可用优惠券", @"不可用优惠券"];
        _discountsSlider.bottomLineWidth = SCREENBOUNDS.width / 4;
        _discountsSlider.titleColor = [UIColor blackColor];
        _discountsSlider.titleSelectColor = ButtonColor;
        _discountsSlider.bottomLineColor = ButtonColor;
        _discountsSlider.pageNumberOfItem = 2;
        _discountsSlider.currentItem = 0;
    }
    return _discountsSlider;
}


@end
