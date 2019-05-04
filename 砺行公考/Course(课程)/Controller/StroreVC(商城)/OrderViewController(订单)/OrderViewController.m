//
//  OrderViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderHeaderView.h"
//#import "OrderFooterView.h"
#import "OrderTwoFooterView.h"
#import "OrderTableViewCell.h"
#import "OrderTwoTableViewCell.h"
#import "ChooseAddressViewController.h"
#import "SubmitOrderView.h"
//优惠券
#import "OrderPreferentialTableViewCell.h"
#import "UseDiscountViewController.h"

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, ChooseAddressFinishDelegate, SubmitOrderViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIView *address_view;

@property (nonatomic, strong) UILabel *top_label;

@property (nonatomic, strong) UILabel *bottom_label;

//默认地址数据
@property (nonatomic, strong) NSDictionary *default_address_dic;

//选择的收货地址的ID
@property (nonatomic, strong) NSString *address_id;

//支付方式   1 === 支付宝支付   2  === 微信支付
@property (nonatomic, assign) NSInteger pay_type;

@end

@implementation OrderViewController

//查询收货地址  （默认地址）
- (void)getDefaultAddressFromHttp {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_receiving_address" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"default address === %@", responseObject);
            //count == 0 表示接口请求成功    但是没有数据
            if ([responseObject[@"data"] count] == 0) {
                return;
            }
            weakSelf.default_address_dic = responseObject[@"data"][0];
            weakSelf.top_label.text = [NSString stringWithFormat:@"收货人：%@    %@", weakSelf.default_address_dic[@"name_"], weakSelf.default_address_dic[@"phone_"]];
            weakSelf.bottom_label.text = weakSelf.default_address_dic[@"address_"];
            weakSelf.address_id = weakSelf.default_address_dic[@"id_"];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    //初始化支付方式  默认支付宝支付
    self.pay_type = 1;
    
    [self setAddressView];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[OrderPreferentialTableViewCell class] forCellReuseIdentifier:@"securitiesCell"];
    [self.tableview registerClass:[OrderTwoTableViewCell class] forCellReuseIdentifier:@"twoCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(80, 0, 60, 0));
    }];
    [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    SubmitOrderView *submit_view = [[SubmitOrderView alloc] init];
    submit_view.delegate = self;
    [self.view addSubview:submit_view];
    [submit_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom);
        make.left.equalTo(weakSelf.tableview.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.tableview.mas_right);
    }];
    
    //查询收货地址
    [self getDefaultAddressFromHttp];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.content_label.text = self.shopDetailsModel.title_string;
        [cell.image_view sd_setImageWithURL:[NSURL URLWithString:self.small_tag_dic[@"path_"]] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.category_label.text = [NSString stringWithFormat:@"分类：%@", self.small_tag_dic[@"name"]];
        cell.price_label.text = [NSString stringWithFormat:@"￥%ld", [self.small_tag_dic[@"price"] integerValue]];
        cell.pay_peoples_label.text = self.shopDetailsModel.pay_numbers_string;
        return cell;
    }else if (indexPath.section == 1) {
        OrderPreferentialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"securitiesCell"];
        
        return cell;
    }
    OrderTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
    NSString *image_named = @[@"zhifubao", @"weixin"][indexPath.row];
    cell.image_view.image = [UIImage imageNamed:image_named];
    cell.content_label.text = @[@"支付宝", @"微信"][indexPath.row];
    cell.tag_label.text = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ORDER_CELL_HEIGHT;
    }
    return ORDER_TWO_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.0;
    }else if (section == 1) {
        return 10.0;
    }
    return 90.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 100.0;
    }else if (section == 1) {
        return 10.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        OrderHeaderView *header_view = [[OrderHeaderView alloc] init];
        header_view.tag_array = self.shopDetailsModel.tag_array;//@[@"距离停售12天", @"库存紧张"];
        return header_view;
    }else if (section == 1) {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = SetColor(246, 246, 246, 1);
        return header;
    }
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    [self setSecondHeaderView:header_view];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        OrderTwoFooterView *footer_view = [[OrderTwoFooterView alloc] init];
        return footer_view;
    }
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = SetColor(246, 246, 246, 1);
    return footer;
}

//选择支付方式
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //跳转选择优惠券
        UseDiscountViewController *useDiscount = [[UseDiscountViewController alloc] init];
        useDiscount.title = @"优惠券";
        [self.navigationController pushViewController:useDiscount animated:YES];
        
    }else if (indexPath.section == 2) {
        self.pay_type = indexPath.row + 1;
    }
}

//设置收货地址view
- (void)setAddressView {
    __weak typeof(self) weakSelf = self;
    self.address_view = [[UIView alloc] init];
    self.address_view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushChooseAddress)];
    [self.address_view addGestureRecognizer:tap];
    [self.view addSubview:self.address_view];
    [self.address_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    UIImageView *left_image = [[UIImageView alloc] init];
    left_image.image = [UIImage imageNamed:@"dingwei"];
    [self.address_view addSubview:left_image];
    [left_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.address_view.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.address_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 25));
    }];
    
    self.top_label = [[UILabel alloc] init];
    self.top_label.font = SetFont(14);
    self.top_label.text = @"暂无收货地址，请立即添加";
    [self.address_view addSubview:self.top_label];
    [self.top_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.address_view.mas_top).offset(20);
        make.left.equalTo(left_image.mas_right).offset(10);
        make.right.equalTo(weakSelf.address_view.mas_right).offset(-20);
    }];
    
    self.bottom_label = [[UILabel alloc] init];
    self.bottom_label.font = SetFont(12);
    self.bottom_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 20 - 22 - 10 - 20;
    self.bottom_label.numberOfLines = 2;
    self.bottom_label.text = @"无详细地址";
    [self.address_view addSubview:self.bottom_label];
    [self.bottom_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.top_label.mas_left);
        make.right.equalTo(weakSelf.top_label.mas_right);
    }];
    
    UIImageView *bottom_image = [[UIImageView alloc] init];
    bottom_image.image = [UIImage imageNamed:@"order_1"];
    [self.address_view addSubview:bottom_image];
    [bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.address_view.mas_left);
        make.right.equalTo(weakSelf.address_view.mas_right);
        make.bottom.equalTo(weakSelf.address_view.mas_bottom);
        make.height.mas_equalTo(2);
    }];
}

//跳转选择地址
- (void)pushChooseAddress {
    ChooseAddressViewController *address = [[ChooseAddressViewController alloc] init];
    address.delegate = self;
    [self.navigationController pushViewController:address animated:YES];
}

//修改addressView布局  并填上数据
- (void)selectFinishAction:(NSString *)nameStrng AddressConten:(NSString *)addressString AddressID:(nonnull NSString *)address_id {
    self.top_label.text = nameStrng;
    self.bottom_label.text = addressString;
    self.address_id = address_id;
}

- (void)setSecondHeaderView:(UIView *)header_view {
    UILabel *price_label = [[UILabel alloc] init];
    price_label.font = SetFont(14);
    price_label.text = @"商品金额";
    [header_view addSubview:price_label];
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    UILabel *price_content_label = [[UILabel alloc] init];
    price_content_label.font = SetFont(14);
    price_content_label.textColor = SetColor(242, 68, 89, 1);
    price_content_label.text = self.shopDetailsModel.price_string;
    [header_view addSubview:price_content_label];
    [price_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.centerY.equalTo(price_label.mas_centerY);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price_label.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left);
        make.right.equalTo(header_view.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *pay_mode_label = [[UILabel alloc] init];
    pay_mode_label.font = SetFont(14);
    pay_mode_label.textColor = DetailTextColor;
    pay_mode_label.text = @"支付方式";
    [header_view addSubview:pay_mode_label];
    [pay_mode_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(price_label.mas_left);
    }];
}

//提交订单数据接口
/**    购物车的接口
 "is_recommend_" = 1;
 "select_type_" = 1;
 "show_price_" = 9;
 "title_" = wencong;
 */
- (void)touchSubmitButtonAction {
    if (!self.address_id) {
        [self showHUDWithTitle:@"请选择收货地址"];
        return;
    }
    
    NSLog(@"pay_type === %ld", self.pay_type);
    
    //整理商品列表数据
    NSArray *shop_list = @[@{
                               @"is_recommend_":@(1),
                               @"select_type_":@(1),
                               @"show_price_":@(9),
                               @"title_":@"wencong"
                               }];
    NSDictionary *parma = @{
                            @"shopping_address_id_":self.address_id,
                            @"commodity_information_list":shop_list,
                            @"distribution_":@"快递 免邮",
                            @"buyer_message_":@"买家留言",
                            @"pay_type_":@"支付方式",
                            @"actual_payment_":@"实际付款"
                            };
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
