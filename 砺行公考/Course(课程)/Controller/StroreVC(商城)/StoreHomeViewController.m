//
//  StoreHomeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "StoreHomeViewController.h"
#import "BannerView.h"
#import "DrillCollectionViewCell.h"
#import "StoreHomeCollectionViewCell.h"
#import "ScrollTextView.h"
#import "VideoDetailViewController.h"
#import "SearchViewController.h"
#import "CategoryShopViewController.h"
#import "ShoppigDetailsViewController.h"

#import "CourseHome_CourseShopModel.h"

#import "CartHomeViewController.h"

@interface StoreHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) UISearchBar *searchBar;

//砺行快讯数据
@property (nonatomic, strong) NSArray *message_array;

@property (nonatomic, strong) NSArray *course_data_array;

@property (nonatomic, strong) UISearchBar *search;

//八大分类
@property (nonatomic, strong) NSArray *category_image_array;

//banner 所有数据   包含链接+跳转链接+title
@property (nonatomic, strong) NSArray *banner_array;

@property (nonatomic, strong) NSArray *banner_image_url_array;



@end

@implementation StoreHomeViewController

//获取砺行快报数据
- (void)getHttpDataForMessage {
    NSDictionary *parma = @{};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/store/find_message" Dic:parma SuccessBlock:^(id responseObject) {
//        NSLog(@"response === %@", responseObject);
        __weak typeof(self) weakSelf = self;
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.message_array = responseObject[@"data"];
            [weakSelf.collectionview reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//获取砺行推荐课程数据
- (void)getHttpDataForCourseData {
    NSDictionary *parma = @{};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/find_mall_home" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"course data response === %@", responseObject);
        __weak typeof(self) weakSelf = self;
        NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:1];
        if ([responseObject[@"state"] integerValue] == 1) {
            //砺行推荐商品
            for (NSDictionary *dic in responseObject[@"data"][@"course_list"][@"commodity_course_result"]) {
                CourseHome_CourseShopModel *model = [[CourseHome_CourseShopModel alloc] init];
                model.course_shop_id = dic[@"id_"];
//                model.image_url_string = [dic[@"url_"] isEqual:[NSNull null]] ? @"" : dic[@"url_"];
                model.course_title_string = dic[@"title_"];
                model.tag_array = dic[@"content_"];
                model.price_string = [NSString stringWithFormat:@"￥%ld", [dic[@"price_"] integerValue]];
                model.good_evaluate_string = [NSString stringWithFormat:@"%@%%好评率", @"80"]; //dic[@"praisenumber"]
                model.pay_numbers_string = [NSString stringWithFormat:@"%@人已付款", dic[@"payment_number_"]];
                [mutable addObject:model];
            }
            weakSelf.course_data_array = [mutable copy];
            
            //砺行快报
            weakSelf.message_array = responseObject[@"data"][@"mall_message_list"];
            
            //banner 图片数组
            weakSelf.banner_array = responseObject[@"data"][@"mall_home_banner_list"];
            
            NSMutableArray *bannerImage = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *bannerDic in weakSelf.banner_array) {
                [bannerImage addObject:bannerDic[@"path_"]];
            }
            weakSelf.banner_image_url_array = [bannerImage copy];
            [weakSelf.collectionview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.category_image_array = @[@[@"category_1", @"思维训练"],
                                  @[@"category_2", @"言语"],
                                  @[@"category_3", @"数量"],
                                  @[@"category_4", @"资料"],
                                  @[@"category_1", @"文化产品"],
                                  @[@"category_2", @"判断"],
                                  @[@"category_3", @"申论"],
                                  @[@"category_4", @"面试"]];
    
    
//    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"购物车" target:self action:@selector(pushShoppingCartAction)];
    [self setleftOrRight:@"right" BarButtonItemWithImage:[UIImage imageNamed:@"cart"] target:self action:@selector(pushShoppingCartAction)];
    
    UIView *titleV = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width - 50, 40)];
    titleV.backgroundColor = WhiteColor;//[UIColor colorWithRed:233/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
    titleV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navigationItem.titleView = titleV;
    
    self.search = [[UISearchBar alloc] initWithFrame:FRAME(0, 5, titleV.bounds.size.width - 60, 30)];
    self.search.delegate = self;
    self.search.tintColor = [UIColor whiteColor];
    self.search.barTintColor = [UIColor clearColor];
    UIImage *backImage = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0];
    self.search.backgroundImage = backImage;
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    searchTextField = [[[self.search.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = SetColor(246, 246, 246, 1);
    self.search.placeholder = @"输入关键词...";
    [self.navigationItem.titleView addSubview:self.search];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[DrillCollectionViewCell class] forCellWithReuseIdentifier:@"oneCell"];
    [self.collectionview registerClass:[StoreHomeCollectionViewCell class] forCellWithReuseIdentifier:@"twoCell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    [self getHttpDataForMessage];
    [self getHttpDataForCourseData];
}

#pragma mark ---- search delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self touchSearchBarAction];
    return NO;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.category_image_array.count;
    }
    return self.course_data_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DrillCollectionViewCell *oneCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"oneCell" forIndexPath:indexPath];
        oneCell.imageV.image = [UIImage imageNamed:self.category_image_array[indexPath.row][0]];
        oneCell.label.text = self.category_image_array[indexPath.row][1];
        return oneCell;
    }
    CourseHome_CourseShopModel *model = self.course_data_array[indexPath.row];
    StoreHomeCollectionViewCell *twoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"twoCell" forIndexPath:indexPath];
//    [twoCell.left_view sd_setImageWithURL:[NSURL URLWithString:model.image_url_string] placeholderImage:[UIImage imageNamed:@"no_image"]];
    twoCell.left_view.image = [UIImage imageNamed:@"no_image"];
    twoCell.title_label.text = model.course_title_string;
    twoCell.tag_array = model.tag_array;
    twoCell.price_label.text = model.price_string;
    twoCell.number_label.text = model.pay_numbers_string;
    twoCell.good_label.text = model.good_evaluate_string;
    return twoCell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(10, 30, 10, 30);
    }
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 40.0;
    }
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat width = (SCREENBOUNDS.width - 60 - 40 * 3) / 4;
        return CGSizeMake(width, width + 25);
    }
    return CGSizeMake(SCREENBOUNDS.width - 40, 130);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CategoryShopViewController *shopVC = [[CategoryShopViewController alloc] init];
        shopVC.category_id = [NSString stringWithFormat:@"%ld", indexPath.row + 3];
        [self.navigationController pushViewController:shopVC animated:YES];
        
    }else if (indexPath.section == 1) {
        CourseHome_CourseShopModel *model = self.course_data_array[indexPath.row];
        ShoppigDetailsViewController *details = [[ShoppigDetailsViewController alloc] init];
        details.shop_id = model.course_shop_id;
        [self.navigationController pushViewController:details animated:YES];
    }
}

#pragma mark ---- header footer view collectionview
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(SCREENBOUNDS.width, 40.0);
    }
    return CGSizeMake(SCREENBOUNDS.width, 240.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 40.0);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        for (UIView *vv in header_view.subviews) {
            [vv removeFromSuperview];
        }
        if (indexPath.section == 0) {
            BannerView *banner = [BannerView initWithFrame:FRAME(20, 10, SCREENBOUNDS.width - 40, 140) withArray:self.banner_image_url_array hasTimer:YES interval:2.0 isLocal:NO];
            [header_view addSubview:banner];
            
            UIImageView *bottom_image = [[UIImageView alloc] init];
            bottom_image.image = [UIImage imageNamed:@"storeHome_1"];
            ViewRadius(bottom_image, 30.0);
            [header_view addSubview:bottom_image];
            [bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(header_view.mas_bottom).offset(-10);
                make.left.equalTo(header_view.mas_left).offset(20);
                make.right.equalTo(header_view.mas_right).offset(-20);
                make.height.mas_equalTo(60);
            }];
            return header_view;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(18);
        label.text = @"砺行推荐";
        [header_view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header_view.mas_left).offset(20);
            make.centerY.equalTo(header_view.mas_centerY);
        }];
        return header_view;
    }
    
    UICollectionReusableView *footer_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    for (UIView *vv in footer_view.subviews) {
        [vv removeFromSuperview];
    }
    //砺行快报
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:FRAME(20, 15, 0, 30)];
    leftLabel.font = SetFont(18);
    leftLabel.textColor = [UIColor blueColor];
    leftLabel.text  = @"砺行快报";
    [leftLabel sizeToFit];
    [footer_view addSubview:leftLabel];
    
    //文本滚动视图
    CGFloat width = CGRectGetMaxX(self.view.frame) - CGRectGetMaxX(leftLabel.frame) - 25;
    ScrollTextView *scrollT = [[ScrollTextView alloc] initWithFrame:FRAME(CGRectGetMaxX(leftLabel.frame), 10, width, 30) whitTextArray:self.message_array];
    scrollT.titleArray = self.message_array;
    [footer_view addSubview:scrollT];
    
    //向右箭头
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:FRAME(CGRectGetMaxX(scrollT.frame) + 5, 15, 10, 20)];
    imageV.backgroundColor = RandomColor;
    [footer_view addSubview:imageV];
    
    footer_view.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetailsAction)];
    [footer_view addGestureRecognizer:ges];
    
    return footer_view;
}

//点击砺行快报  跳转详情界面
- (void)pushDetailsAction {
    VideoDetailViewController *details = [[VideoDetailViewController alloc] init];
    [self.navigationController pushViewController:details animated:YES];
}

//跳转购物车页面
- (void)pushShoppingCartAction {
    CartHomeViewController *cartHome = [[CartHomeViewController alloc] init];
    [self.navigationController pushViewController:cartHome animated:YES];
}

- (void)touchSearchBarAction {
    [self.search resignFirstResponder];
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
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
