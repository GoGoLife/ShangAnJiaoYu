//
//  CartHomeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CartHomeViewController.h"
#import "OrderTableViewCell.h"
#import "SubmitOrderView.h"
#import "OrderHeaderView.h"
#import "CartOrderViewController.h"
#import "CartShopModel.h"

@interface CartHomeViewController ()<UITableViewDelegate, UITableViewDataSource, SubmitOrderViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

//选择的商品数据
@property (nonatomic, strong) NSMutableArray *selected_array;

@end

@implementation CartHomeViewController

- (void)getShoppingFromCartsData {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:1];
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/find_shopping_cart" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"carts shopping === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *cartDic in responseObject[@"data"]) {
                CartShopModel *model = [[CartShopModel alloc] init];
                model.cart_shop_id = cartDic[@"commodity_id_"];
                model.cart_shop_type_id = cartDic[@"commodity_type_id_"];
                model.cart_shop_image_url = [cartDic[@"path_"] isKindOfClass:[NSNull class]] ? @"" : cartDic[@"path_"];
                model.lable_ = cartDic[@"lable"];
                model.cart_title = cartDic[@"title_"];
                model.cart_category_title = [NSString stringWithFormat:@"分类：%@", cartDic[@"name_"]];
                model.cart_price = [NSString stringWithFormat:@"￥%.2f", [cartDic[@"price_"] floatValue] / 100.0];
                model.cart_payNumbers = [NSString stringWithFormat:@"%ld人已付款", [cartDic[@"payment_number_"] integerValue]];
                model.cart_shop_numbers = [NSString stringWithFormat:@"%ld", [cartDic[@"number_"] integerValue]];
                model.isSelected = NO;
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
    self.title = @"购物车";
    
    //初始化
    self.selected_array = [NSMutableArray arrayWithCapacity:1];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    
    SubmitOrderView *submit_view = [[SubmitOrderView alloc] init];
    submit_view.delegate = self;
    submit_view.isUpdateLayout = YES;
    [self.view addSubview:submit_view];
    [submit_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [self getShoppingFromCartsData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartShopModel *model = self.dataArray[indexPath.row];
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isShowSelectButton = YES;
    cell.isSelected = model.isSelected;
    [cell.image_view sd_setImageWithURL:[NSURL URLWithString:model.cart_shop_image_url] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.content_label.text = model.cart_title;
    cell.category_label.text = model.cart_category_title;
    cell.price_label.text = model.cart_price;
    cell.pay_peoples_label.text = model.cart_payNumbers;
    cell.number_label.text = [@"x" stringByAppendingString:model.cart_shop_numbers];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ORDER_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = SetColor(246, 246, 246, 1);
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = SetColor(246, 246, 246, 1);
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CartShopModel *model = self.dataArray[indexPath.row];
    model.isSelected = !model.isSelected;
    [self.tableview reloadData];
    if (model.isSelected) {
        [self.selected_array addObject:model];
    }else {
        [self.selected_array removeObject:model];
    }
}

//tableview  编辑操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//编辑具体操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"删除成功");
}

//提交订单
- (void)touchSubmitButtonAction {
    if (self.selected_array.count == 0) {
        [self showHUDWithTitle:@"未选择商品"];
        return;
    }
    //保存订单到后台
    NSMutableArray *service_array = [NSMutableArray arrayWithCapacity:1];
    for (CartShopModel *model in self.selected_array) {
        NSDictionary *service_dic = @{@"commodity_id_":model.cart_shop_id,
                                      @"commodity_type_id_":model.cart_shop_type_id,
                                      @"number_":@([model.cart_shop_numbers integerValue])};
        [service_array addObject:service_dic];
    }
    
    NSDictionary *param = @{@"commodity_list":[service_array copy]};
    
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/show_commodity_order" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"订单保存成功！！！！");
            CartOrderViewController *cartOrder = [[CartOrderViewController alloc] init];
            cartOrder.data_dic = responseObject[@"data"];
            [self.navigationController pushViewController:cartOrder animated:YES];
        }else {
            NSLog(@"订单保存成功！！！！");
        }
    } FailureBlock:^(id error) {
        NSLog(@"订单保存成功！！！！");
    }];
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
