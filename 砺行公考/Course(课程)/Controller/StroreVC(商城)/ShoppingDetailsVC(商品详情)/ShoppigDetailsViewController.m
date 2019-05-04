//
//  ShoppigDetailsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShoppigDetailsViewController.h"
#import "Shopping_CommentTableViewCell.h"
#import "DetailsImageTableViewCell.h"
//first header view
#import "DetailsHeaderView.h"
#import "LookAllCommentViewController.h"
#import "AddCartView.h"
#import "ShowShoppingCategoryView.h"
#import "OrderViewController.h"
#import "CartHomeViewController.h"
#import "ShopDetailsModel.h"
#import "KPDateTool.h"
#import "CartOrderViewController.h"
#import "UIButton+ButtonBadge.h"

@interface ShoppigDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, AddCartViewDelegate, ShowShoppingCategoryViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSDictionary *details_data_dic;

@property (nonatomic, strong) ShopDetailsModel *shopDetailsModel;

//所有的评价数据
@property (nonatomic, strong) NSMutableArray *all_shop_comment_array;

/** 当前商品数量 */
@property (nonatomic, assign) NSInteger current_shop_number;

@property (nonatomic, strong) AddCartView *add_cart_view;

@end

@implementation ShoppigDetailsViewController

//获取商品详情相关数据   除评价
- (void)getHttpData {
    [self showHUD];
    NSLog(@"id === %@", self.shop_id);
    NSDictionary *parma = @{@"commodity_id":self.shop_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/commodity_message" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"shop details == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.shopDetailsModel = [[ShopDetailsModel alloc] init];
            //商品介绍视频
            NSMutableArray *mp4_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *imageDic in responseObject[@"data"][@"commodity_file_list"][@"mp4_file_list"]) {
                [mp4_array addObject:imageDic[@"path_"]];
            }
            weakSelf.shopDetailsModel.shop_mp4_array = [mp4_array copy];
            
            //商品介绍图片
            NSMutableArray *image_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *imageDic in responseObject[@"data"][@"commodity_file_list"][@"png_file_list"]) {
                [image_array addObject:imageDic[@"path_"]];
            }
            weakSelf.shopDetailsModel.shop_intro_array = [image_array copy]; //responseObject[@"data"][@"commodity_file_list"];
            //商品ID
            weakSelf.shopDetailsModel.shop_id = responseObject[@"data"][@"commodity_basic_massage"][@"id_"];
            //商品标题
            weakSelf.shopDetailsModel.title_string = responseObject[@"data"][@"commodity_basic_massage"][@"title_"];
            //商品标签数组
            weakSelf.shopDetailsModel.tag_array = [responseObject[@"data"][@"commodity_basic_massage"][@"lable"] componentsSeparatedByString:@","];;
            //商品价格
            weakSelf.shopDetailsModel.price_string = [NSString stringWithFormat:@"￥%.2f", [responseObject[@"data"][@"commodity_basic_massage"][@"price_"] integerValue] / 100.0];
            //商品付款人数
            weakSelf.shopDetailsModel.pay_numbers_string = [NSString stringWithFormat:@"%ld人已付款", [responseObject[@"data"][@"commodity_basic_massage"][@"payment_number_"] integerValue]];
            //开始时间
            NSInteger start_time = [responseObject[@"data"][@"commodity_relevance_massage"][@"start_time_"] integerValue];
            //结束时间
            NSInteger end_time = [responseObject[@"data"][@"commodity_relevance_massage"][@"end_time_"] integerValue];
            
            NSString *start_dateStirng = [KPDateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%ld", (long)start_time] withFormatStr:@"yyyy-MM-dd"];
            NSString *end_dateStirng = [KPDateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%ld", (long)end_time] withFormatStr:@"yyyy-MM-dd"];
            weakSelf.shopDetailsModel.date_string = [NSString stringWithFormat:@"授课时间:%@ ~ %@", start_dateStirng, end_dateStirng];
            
            //商品详情
            weakSelf.shopDetailsModel.shop_details_array = responseObject[@"data"][@"commodity_details"][@"file_list"][@"png_file_list"];
            weakSelf.shopDetailsModel.shop_details_string = responseObject[@"data"][@"commodity_details"][@"content"];
            
            NSString *car_number = [NSString stringWithFormat:@"%ld", [responseObject[@"data"][@"user_shopping_cart_number"] integerValue]];
            //赋值购物车
            [weakSelf.add_cart_view.cart_button setBadgeString:car_number Font:12];
            
            
            [weakSelf.tableview reloadData];
            //获取商品评价
            [weakSelf getShopCommentData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//获取评论数据
- (void)getShopCommentData {
    NSDictionary *parma = @{
                            @"contingency_id_":@"debb2c42d2cc4137894dd67230576888",
                            @"page_number":@"1",
                            @"page_size":@"1"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_goods_comment" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"shop comment data === %@", responseObject);
        if ([responseObject[@"data"][@"comment_result_list_"] count] == 0) {
            //表示无评论数据
            [weakSelf.tableview reloadData];
            [weakSelf hidden];
            return;
        }
        
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *commentDic in responseObject[@"data"][@"comment_result_list_"]) {
                ShopCommentModel *model = [[ShopCommentModel alloc] init];
                model.shop_comment_id = commentDic[@"id_"];
                model.header_image_url = @"";
                model.name_string = [commentDic[@"name_"] isEqualToString:@""] ? commentDic[@"login_name_"] : commentDic[@"name_"];
                model.tag_string = @"言语大宗师";
                model.grade_string = @"LV 20";
                model.category_string = @"分类：纯网络班学员";
                model.comment_string = commentDic[@"content_"];
                model.image_array = commentDic[@"comment_picture_list_"];
                [weakSelf.all_shop_comment_array addObject:model];
            }
            weakSelf.shopDetailsModel.shop_comment_array = @[[weakSelf.all_shop_comment_array firstObject]];
//            [weakSelf.tableview reloadData];
            [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf hidden];
        }else {
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课程详情";
    [self setBack];
    self.current_shop_number = 1;
    
    //初始化
    self.all_shop_comment_array = [NSMutableArray arrayWithCapacity:1];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[DetailsImageTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[Shopping_CommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    
    self.add_cart_view = [[AddCartView alloc] init];
    self.add_cart_view.delegate = self;
    [self.view addSubview:self.add_cart_view];
    [self.add_cart_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom);
        make.left.equalTo(weakSelf.tableview.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.tableview.mas_right);
    }];
//    [self.add_cart_view.cart_button setBadgeString:@"1" Font:12];
    
    [self getHttpData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else if (section == 1) {
        //评价cell  暂时隐藏
        return self.shopDetailsModel.shop_comment_array.count;
    }
    //详情图片
    return [self.shopDetailsModel.shop_details_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //评论cell
        ShopCommentModel *model = self.shopDetailsModel.shop_comment_array[indexPath.row];
        Shopping_CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell.name_label.text = model.name_string;
        cell.tag_label.text = model.tag_string;
        cell.grade_label.text = model.grade_string;
        cell.category_label.text = model.category_string;
        cell.content_label.text = model.comment_string;
        cell.imageArray = model.image_array;
        return cell;
    }else if (indexPath.section == 2) {
        //详情cell
        DetailsImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        NSString *image_url = self.shopDetailsModel.shop_details_array[indexPath.row][@"path_"];
        [cell.image_view sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"date"]];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ShopCommentModel *model = self.shopDetailsModel.shop_comment_array[indexPath.row];
        return model.comment_cell_height;
    }else if (indexPath.section == 2) {
        NSString *image_url = self.shopDetailsModel.shop_details_array[indexPath.row][@"path_"];
        CGSize size = [self GetImageSizeWithURL:[NSURL URLWithString:image_url]];
        CGFloat scale = (SCREENBOUNDS.width - 40) / size.width;
        return size.height * scale;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 500.0;
    }else if (section == 1) {
        if (self.shopDetailsModel.shop_comment_array.count == 0) {
            return 0.0;
        }
        return 40.0;
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (self.shopDetailsModel.shop_comment_array.count == 0) {
            return 0.0;
        }
        return 50.0;
    }else if (section == 2) {
        return self.shopDetailsModel.shop_details_string_height + 40;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        //拼接数据   将视频和图片数据拼接到一起
        NSMutableArray *custom_data = [NSMutableArray arrayWithArray:self.shopDetailsModel.shop_intro_array];
        if (self.shopDetailsModel.shop_mp4_array.count == 0) {
            [custom_data insertObject:@"" atIndex:0];
        }else {
            [custom_data insertObject:self.shopDetailsModel.shop_mp4_array.firstObject atIndex:0];
        }
        DetailsHeaderView *header_view = [[DetailsHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 530.0)];
        header_view.title_string = self.shopDetailsModel.title_string;
        header_view.tag_array = self.shopDetailsModel.tag_array;
        header_view.price_string = self.shopDetailsModel.price_string;
        header_view.pay_numbers_string = self.shopDetailsModel.pay_numbers_string;
        header_view.date_string = self.shopDetailsModel.date_string;
        //简介视频 + 图片
        header_view.collectionview_data_array = [custom_data copy];
        return header_view;
    }
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @[@"【课程评价】", @"【课程详情】"][section - 1];
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footer_view = [[UIView alloc] init];
        footer_view.backgroundColor = WhiteColor;
        UIButton *look_more_button = [UIButton buttonWithType:UIButtonTypeCustom];
        look_more_button.titleLabel.font = SetFont(12);
        [look_more_button setTitleColor:ButtonColor forState:UIControlStateNormal];
        ViewBorderRadius(look_more_button, 13.0, 1.0, ButtonColor);
        [look_more_button setTitle:@"查看全部评价" forState:UIControlStateNormal];
        [look_more_button addTarget:self action:@selector(look_all_comment_action) forControlEvents:UIControlEventTouchUpInside];
        [footer_view addSubview:look_more_button];
        [look_more_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footer_view.mas_centerX);
            make.centerY.equalTo(footer_view.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 26));
        }];
        return footer_view;
    }else if (section == 2) {
        UIView *footer_view = [[UIView alloc] init];
        footer_view.backgroundColor = WhiteColor;
        UILabel *content = [[UILabel alloc] init];
        content.font = SetFont(14);
        content.textColor = DetailTextColor;
        content.numberOfLines = 0;
        content.text = self.shopDetailsModel.shop_details_string;
        [footer_view addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(10, 20, 10, 20));
        }];
        return footer_view;
    }
    return [[UIView alloc] init];
}

- (void)look_all_comment_action {
    LookAllCommentViewController *all = [[LookAllCommentViewController alloc] init];
    all.dataArray = [self.all_shop_comment_array copy];
    [self.navigationController pushViewController:all animated:YES];
}

#pragma mark --- addCartView delegate

/**
 点击加入购物车上面的按钮   绑定的方法

 @param index  100 === 客服
               200 === 购物车
               300 === 加入购物车
               400 === 立即购买
 */
- (void)touchButtonTargetAction:(NSInteger)index {
    if (index == 100) {
        [self showHUDWithTitle:@"暂无客服"];
    }else if (index == 200) {
        CartHomeViewController *cartHome = [[CartHomeViewController alloc] init];
        [self.navigationController pushViewController:cartHome animated:YES];
    }else if (index == 300) {
        
        AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIView *back_view = [[UIView alloc] initWithFrame:app_delegate.window.bounds];
        back_view.backgroundColor = SetColor(155, 155, 155, 0.5);
        [app_delegate.window addSubview:back_view];

        ShowShoppingCategoryView *showView = [[ShowShoppingCategoryView alloc] init];
        showView.delegate = self;
        showView.shop_id = self.shop_id;
        showView.numbers_string = @"1";
        showView.backgroundColor = WhiteColor;
        //点击取消
        showView.touchCancelAction = ^{
            [back_view removeFromSuperview];
        };
        //点击确定
        __weak typeof(self) weakSelf = self;
        showView.touchConfirmAction = ^(NSDictionary * _Nonnull small_tag_dic) {
            [back_view removeFromSuperview];
            //调用接口   添加商品到购物车
            [weakSelf addShoppingToCarts:self.shop_id small_tag_id:small_tag_dic[@"contingency_type_id_"]];
        };
        [back_view addSubview:showView];
        [showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(200, 0, 0, 0));
        }];
        
    }else if (index == 400) {
        AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIView *back_view = [[UIView alloc] initWithFrame:app_delegate.window.bounds];
        back_view.backgroundColor = SetColor(155, 155, 155, 0.5);
        [app_delegate.window addSubview:back_view];

        ShowShoppingCategoryView *showView = [[ShowShoppingCategoryView alloc] init];
        showView.delegate = self;
        showView.shop_id = self.shop_id;
        showView.numbers_string = @"1";
        showView.backgroundColor = WhiteColor;
        //点击取消
        showView.touchCancelAction = ^{
            [back_view removeFromSuperview];
        };
        //点击确定
        __weak typeof(self) weakSelf = self;
        showView.touchConfirmAction = ^(NSDictionary * _Nonnull small_tag_dic) {
            NSLog(@"small tag dic == %@", small_tag_dic);
            [back_view removeFromSuperview];
            [weakSelf immediatelyBuyShop:self.shopDetailsModel.shop_id Commodity_type_id_:small_tag_dic[@"contingency_type_id_"] Numbers:weakSelf.current_shop_number];
//            OrderViewController *order = [[OrderViewController alloc] init];
//            order.small_tag_dic = small_tag_dic;
//            order.shopDetailsModel = weakSelf.shopDetailsModel;
//            [weakSelf.navigationController pushViewController:order animated:YES];
        };
        [back_view addSubview:showView];
        [showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(200, 0, 0, 0));
        }];
    }
}

//添加商品到购物车
- (void)addShoppingToCarts:(NSString *)shop_id small_tag_id:(NSString *)small_tag_id {
    NSDictionary *parma = @{
                            @"commodity_id":shop_id,
                            @"type_id":small_tag_id,
                            @"number":@(self.current_shop_number)
                            };
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/save_shopping_cart" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf showHUDWithTitle:@"添加成功"];
            [weakSelf getHttpData];
            [weakSelf hidden];
        }else {
            [weakSelf showHUDWithTitle:@"添加失败"];
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        [weakSelf showHUDWithTitle:@"添加失败"];
        [weakSelf hidden];
    }];
}

- (void)touchAddButtonAction:(UIButton *)add_button Numbers:(UILabel *)number_label {
    number_label.text = @"";
    self.current_shop_number++;
    number_label.text = [NSString stringWithFormat:@"%ld", self.current_shop_number];
}

- (void)touchLessButtonAction:(UIButton *)add_button Numbers:(UILabel *)number_label {
    if (self.current_shop_number > 1) {
        self.current_shop_number--;
    }else {
        [self showHUDWithTitle:@"不能再减了"];
    }
    number_label.text = [NSString stringWithFormat:@"%ld", self.current_shop_number];
}

/**
 立即购买
 */
- (void)immediatelyBuyShop:(NSString *)commodity_id_ Commodity_type_id_:(NSString *)commodity_type_id_ Numbers:(NSInteger)number {
    NSDictionary *service_dic = @{@"commodity_id_":commodity_id_,
                                  @"commodity_type_id_":commodity_type_id_,
                                  @"number_":@(number)};
    NSDictionary *param = @{@"commodity_list":@[service_dic]};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/show_commodity_order" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"immediately data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"订单保存成功！！！！");
            CartOrderViewController *cartOrder = [[CartOrderViewController alloc] init];
            cartOrder.data_dic = responseObject[@"data"];
            [self.navigationController pushViewController:cartOrder animated:YES];
        }else {
            NSLog(@"订单保存失败！！！！");
        }
    } FailureBlock:^(id error) {
        NSLog(@"订单保存失败！！！！");
    }];
}

/**
 获取网络图片的宽高

 @param imageURL url
 @return size
 */
- (CGSize)GetImageSizeWithURL:(id)imageURL {
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]) {
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]) {
        URL = [NSURL URLWithString:imageURL];
    }
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];
    return CGSizeMake(image.size.width, image.size.height);
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
