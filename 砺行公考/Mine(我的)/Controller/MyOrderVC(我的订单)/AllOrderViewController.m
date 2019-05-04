//
//  AllOrderViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "AllOrderViewController.h"
#import "OrderTableViewCell.h"
#import "MyOrderFooterView.h"
#import "MyOrderDetailsViewController.h"
#import "MyOrderModel.h"
#import "MyOrderHeaderView.h"

@interface AllOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AllOrderViewController

/** 获取代付款数据 */
- (void)getDataWithStatus:(NSInteger)index {
    if (index == 1) {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *param = @{@"status_":@"5",
                            @"page_number":[NSString stringWithFormat:@"%ld", index],
                            @"page_size":@"20"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/find_user_mall_order_list" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *orderDic in responseObject[@"data"][@"rows"]) {
                MyOrderModel *orderModel = [[MyOrderModel alloc] init];
                orderModel.order_id = orderDic[@"id_"];
                orderModel.order_status = orderDic[@"status_"];
                orderModel.order_real_payment = [NSString stringWithFormat:@"￥%ld", [orderDic[@"real_payment_"] integerValue]];
                orderModel.order_send_cost = [NSString stringWithFormat:@"￥%ld", [orderDic[@"send_cost"] integerValue]];
                orderModel.order_commodity_total = [NSString stringWithFormat:@"￥%ld", [orderDic[@"commodity_total"] integerValue]];
                NSMutableArray *shop_array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *shopDic in orderDic[@"commodity_list"]) {
                    OrderUnderShopModel *shopModel = [[OrderUnderShopModel alloc] init];
                    shopModel.order_shop_id = shopDic[@"commodity_id_"];
                    shopModel.order_shop_tyep_id = shopDic[@"commodity_type_id_"];
                    shopModel.order_shop_label = shopDic[@"lable"];
                    shopModel.order_shop_title = shopDic[@"title_"];
                    shopModel.order_shop_price = [NSString stringWithFormat:@"￥%ld", [shopDic[@"price_"] integerValue]];
                    shopModel.order_shop_number = [NSString stringWithFormat:@"%ld", [shopDic[@"number_"] integerValue]];
                    shopModel.order_shop_imageUrl = shopDic[@"commodity_type_path_"];
                    shopModel.order_shop_type_title = shopDic[@"commodity_type_title_"];
                    [shop_array addObject:shopModel];
                }
                orderModel.order_commodity_list = [shop_array copy];
                [weakSelf.dataArray addObject:orderModel];
            }
            [weakSelf.tableview reloadData];
        }
        [weakSelf.tableview.mj_header endRefreshing];
        if (weakSelf.dataArray.count <= [responseObject[@"data"][@"records"] integerValue]) {
            [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
        }else {
            [weakSelf.tableview.mj_footer endRefreshing];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 64, 0));
    }];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithStatus:1];
    }];
    [self.tableview.mj_header beginRefreshing];
    
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithStatus:weakSelf.index++];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MyOrderModel *orderModel = self.dataArray[section];
    return orderModel.order_commodity_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderModel *orderModel = self.dataArray[indexPath.section];
    OrderUnderShopModel *shopModel = orderModel.order_commodity_list[indexPath.row];
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    [cell.image_view sd_setImageWithURL:[NSURL URLWithString:shopModel.order_shop_imageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.content_label.text = shopModel.order_shop_title;
    cell.category_label.text = [NSString stringWithFormat:@"分类：%@", shopModel.order_shop_type_title];
    cell.price_label.text = shopModel.order_shop_price;
    cell.pay_peoples_label.text = @"";
    cell.number_label.text = [NSString stringWithFormat:@"x%@", shopModel.order_shop_number];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 93.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MyOrderModel *model = self.dataArray[section];
    MyOrderHeaderView *header_view = [[MyOrderHeaderView alloc] init];
    header_view.backgroundColor = WhiteColor;
    header_view.order_status_label.text = model.order_status;
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MyOrderModel *model = self.dataArray[section];
    NSArray *footer_array = @[@{@"title":@"付款",
                                @"R":@"48",
                                @"G":@"132",
                                @"B":@"252"},
                              @{@"title":@"取消订单",
                                @"R":@"155",
                                @"G":@"155",
                                @"B":@"155"}];
    MyOrderFooterView *footer_view = [[MyOrderFooterView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 93) withActionButtonTitlesArray:footer_array];
    footer_view.shop_finish_content.text = [NSString stringWithFormat:@"共%@件商品 合计：%@（含运费：%@）", model.order_commodity_total, model.order_real_payment, model.order_send_cost];//@"共3件商品 合计：￥349.00（含运费：￥5.00）";
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MyOrderDetailsViewController *details = [[MyOrderDetailsViewController alloc] init];
//    [self.navigationController pushViewController:details animated:YES];
}

#pragma mark --- 懒加载
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"order"];
    }
    return _tableview;
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
