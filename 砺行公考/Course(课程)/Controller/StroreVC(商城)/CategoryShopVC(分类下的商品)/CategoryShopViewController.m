//
//  CategoryShopViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/21.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CategoryShopViewController.h"
#import "Course_TwoTableViewCell.h"
#import "SortView.h"
#import "CourseHome_CourseShopModel.h"
#import "ShoppigDetailsViewController.h"

@interface CategoryShopViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) SortView *sort_view;

@property (nonatomic, strong) UISearchBar *search;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CategoryShopViewController

/**
 {id: '1', title: '超值课程'},
 {id: '2', title: '精品课程'},
 {id: '3', title: '思维训练'},
 {id: '4', title: '言语'},
 {id: '5', title: '数量'},
 {id: '6', title: '资料'},
 {id: '7', title: '文化产品'},
 {id: '8', title: '判断'},
 {id: '9', title: '申论'},
 {id: '10', title: '面试'}
 */

//通过分类ID  获取商品数据
- (void)getShoppingDataFromCategroyID {
//    NSDictionary *parma = @{@"commodity_type_":self.category_id};
//    __weak typeof(self) weakSelf = self;
//    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/store/find_commodity_recommended_list" Dic:parma SuccessBlock:^(id responseObject) {
//        NSLog(@"category shop data === %@", responseObject);
//        NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:1];
//        if ([responseObject[@"state"] integerValue] == 1) {
//            for (NSDictionary *dic in responseObject[@"data"]) {
//                CourseHome_CourseShopModel *model = [[CourseHome_CourseShopModel alloc] init];
//                model.course_shop_id = dic[@"id_"];
//                model.image_url_string = dic[@"url_"];
//                model.course_title_string = dic[@"title_"];
//                model.tag_array = dic[@"content_"];
//                model.price_string = [NSString stringWithFormat:@"￥%ld", [dic[@"show_price_"] integerValue]];
//                model.pay_numbers_string = [NSString stringWithFormat:@"%ld人已付款", [dic[@"paynumber"] integerValue]];
//                model.good_evaluate_string = [NSString stringWithFormat:@"%ld%%好评率", [dic[@"praisenumber"] integerValue]];
//                [mutable addObject:model];
//            }
//            weakSelf.dataArray = [mutable copy];
//            [weakSelf.tableview reloadData];
//        }
//    } FailureBlock:^(id error) {
//
//    }];
    
    NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:1];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/search_commodity" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"shop data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
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
                [mutable addObject:model];
            }
            weakSelf.dataArray = [mutable copy];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    UIView *titleV = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width - 60, 40)];
    titleV.backgroundColor = WhiteColor;
    titleV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navigationItem.titleView = titleV;
    
    self.search = [[UISearchBar alloc] initWithFrame:FRAME(0, 5, titleV.bounds.size.width, 30)];
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
    
    __weak typeof(self) weakSelf = self;
    self.sort_view = [SortView creatSortViewWithFrame:CGRectZero withTitleArray:@[@"综合", @"直播", @"录播"]];
    [self.view addSubview:self.sort_view];
    [self.sort_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    self.tableview = [[UITableView alloc] init];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[Course_TwoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    
    [self getShoppingDataFromCategroyID];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseHome_CourseShopModel *model = self.dataArray[indexPath.row];
    Course_TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    return Course_Two_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseHome_CourseShopModel *model = self.dataArray[indexPath.row];
    ShoppigDetailsViewController *shopDetails = [[ShoppigDetailsViewController alloc] init];
    shopDetails.shop_id = model.course_shop_id;
    [self.navigationController pushViewController:shopDetails animated:YES];
}

//searchbar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
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
