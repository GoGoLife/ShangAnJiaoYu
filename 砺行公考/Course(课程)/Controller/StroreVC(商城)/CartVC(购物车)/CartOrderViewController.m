//
//  CartOrderViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/19.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CartOrderViewController.h"
#import "OrderHeaderView.h"
#import "OrderTwoFooterView.h"
#import "SubmitOrderView.h"
#import "OrderTableViewCell.h"
#import "OrderTwoTableViewCell.h"
#import "ChooseAddressViewController.h"
#import "CartShopModel.h"
#import "OrderPreferentialTableViewCell.h"
#import "ShopDisCountViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface CartOrderViewController ()<UITableViewDelegate, UITableViewDataSource, ChooseAddressFinishDelegate, SubmitOrderViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIView *address_view;

@property (nonatomic, strong) UILabel *top_label;

@property (nonatomic, strong) UILabel *bottom_label;

//默认地址
@property (nonatomic, strong) NSDictionary *default_address_dic;

//地址ID
@property (nonatomic, strong) NSString *address_id;

@property (nonatomic, assign) NSInteger pay_type;

//优惠券数据
@property (nonatomic, strong) NSDictionary *user_coupon_dic;

//付款总价
@property (nonatomic, assign) CGFloat shop_sum_price;

@property (nonatomic, strong) SubmitOrderView *submit_view;

/** 实际付款金额 */
@property (nonatomic, assign) CGFloat real_price;

@end

@implementation CartOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.title = @"确认订单";
    
    //初始化  支付方式
    self.pay_type = 0;
    
    [self setAddressView:self.data_dic[@"user_address"]];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[OrderPreferentialTableViewCell class] forCellReuseIdentifier:@"preferentialCell"];
    [self.tableview registerClass:[OrderTwoTableViewCell class] forCellReuseIdentifier:@"twoCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(80, 0, 60, 0));
    }];
    [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    //计算总价
    self.shop_sum_price = 0.0;
    for (NSDictionary *shop_dic in self.data_dic[@"commodity_list"]) {
        //商品单价
        NSInteger shop_price_index = [shop_dic[@"price_"] integerValue];
        //商品数量
        NSInteger shop_number = [shop_dic[@"number_"] integerValue];
        //总价格
        self.shop_sum_price += shop_price_index * shop_number;
    }
    //赋值实际付款金额
    self.real_price = self.shop_sum_price / 100.0;
    
    self.submit_view = [[SubmitOrderView alloc] init];
    self.submit_view.price_label.text = [NSString stringWithFormat:@"￥%.2f", self.real_price];
    self.submit_view.delegate = self;
    [self.view addSubview:self.submit_view];
    [self.submit_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom);
        make.left.equalTo(weakSelf.tableview.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.tableview.mas_right);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }else if (section == 2) {
        return [self.data_dic[@"method_payment"] count];
    }
    return [self.data_dic[@"commodity_list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //优惠券
        OrderPreferentialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"preferentialCell"];
        cell.right_content_label.text = self.user_coupon_dic ? self.user_coupon_dic[@"title_"] : @"无";
        return cell;
    }else if (indexPath.section == 2) {
        //支付方式
        NSDictionary *pay_type_dic = self.data_dic[@"method_payment"][indexPath.row];
        OrderTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
        [cell.image_view sd_setImageWithURL:[NSURL URLWithString:pay_type_dic[@"path_"]] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.content_label.text = pay_type_dic[@"content_"];
        cell.tag_label.text = @"";
        return cell;
    }
    NSDictionary *shop_dic = self.data_dic[@"commodity_list"][indexPath.row];
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.image_view sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.content_label.text = shop_dic[@"title_"];
    cell.category_label.text = [NSString stringWithFormat:@"分类：%@", shop_dic[@"type_name_"]];
    cell.price_label.text = [NSString stringWithFormat:@"￥%.2f", [shop_dic[@"price_"] floatValue] / 100.0];
    cell.pay_peoples_label.text = [NSString stringWithFormat:@"%ld人已付款", [shop_dic[@"payment_number_"] integerValue]];
    cell.number_label.text = [NSString stringWithFormat:@"x%ld", [shop_dic[@"number_"] integerValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ORDER_CELL_HEIGHT;
    }
    return ORDER_TWO_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10.0;
    }else if (section == 2) {
        return 140.0;
    }else {
        return 40.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 100.0;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header_view = [[UIView alloc] init];
        header_view.backgroundColor = SetColor(246, 246, 246, 1);
        return header_view;
    }else if (section == 2) {
        UIView *header_view = [[UIView alloc] init];
        header_view.backgroundColor = WhiteColor;
        [self setSecondHeaderView:header_view];
        return header_view;
    }
    OrderHeaderView *header_view = [[OrderHeaderView alloc] init];
    header_view.tag_array = @[@"距离停售12天", @"库存紧张"];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        OrderTwoFooterView *footer_view = [[OrderTwoFooterView alloc] init];
        return footer_view;
    }
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = SetColor(246, 246, 246, 1);
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //选择优惠券
        __weak typeof(self) weakSelf = self;
        ShopDisCountViewController *shopDiscount = [[ShopDisCountViewController alloc] init];
        shopDiscount.disCount_array = self.data_dic[@"user_coupon"];
        shopDiscount.returnUserChoosedDisCount = ^(NSDictionary * _Nonnull data_dic) {
            weakSelf.user_coupon_dic = data_dic;
            [weakSelf.tableview reloadData];
            [weakSelf.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.pay_type inSection:2] animated:YES scrollPosition:UITableViewScrollPositionNone];
            weakSelf.real_price = weakSelf.shop_sum_price / 100.0 - [data_dic[@"amount_"] floatValue] / 100.0;
            weakSelf.submit_view.price_label.text = [NSString stringWithFormat:@"%.2f", weakSelf.real_price];
            //赋值实际付款金额
            
        };
        [self.navigationController pushViewController:shopDiscount animated:YES];
    }else if (indexPath.section == 2) {
        self.pay_type = indexPath.row;
    }
}

//设置收货地址view
- (void)setAddressView:(NSDictionary *)address_dic {
    //保存地址ID
    self.address_id = [address_dic allKeys].count == 0 ? @"" : address_dic[@"id_"];
    
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
    self.top_label.text = [address_dic allKeys].count == 0 ? @"暂无收货地址，请立即添加" : [NSString stringWithFormat:@"收货人：%@    %@", address_dic[@"name_"], address_dic[@"phone_"]];
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
    self.bottom_label.text = [address_dic allKeys].count == 0 ? @"无详细地址" : address_dic[@"address_"];
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
    price_content_label.text = [NSString stringWithFormat:@"￥%.2f", self.shop_sum_price / 100.0];
    [header_view addSubview:price_content_label];
    [price_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.centerY.equalTo(price_label.mas_centerY);
    }];
    
    //运费
    UITextField *freight_field = [[UITextField alloc] init];
    freight_field.font = SetFont(14);
    freight_field.textAlignment = NSTextAlignmentRight;
    freight_field.textColor = SetColor(242, 68, 89, 1);
    freight_field.text = @"+￥0.00";
    
    UILabel *freight_left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 80, 20)];
    freight_left_label.font = SetFont(14);
    freight_left_label.text = @"运费";
    freight_field.leftView = freight_left_label;
    freight_field.leftViewMode = UITextFieldViewModeAlways;
    
    [header_view addSubview:freight_field];
    [freight_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price_label.mas_bottom).offset(10);
        make.left.equalTo(price_label.mas_left);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    //立减
    NSString *knock_string = self.user_coupon_dic ? [NSString stringWithFormat:@"-￥%.2f", [self.user_coupon_dic[@"amount_"] floatValue] / 100.0] : @"-￥0.0";
    UITextField *knock_field = [[UITextField alloc] init];
    knock_field.font = SetFont(14);
    knock_field.textAlignment = NSTextAlignmentRight;
    knock_field.textColor = SetColor(242, 68, 89, 1);
    knock_field.text = knock_string;
    
    UILabel *knock_left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 80, 20)];
    knock_left_label.font = SetFont(14);
    knock_left_label.text = @"立减";
    knock_field.leftView = knock_left_label;
    knock_field.leftViewMode = UITextFieldViewModeAlways;
    
    [header_view addSubview:knock_field];
    [knock_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(freight_field.mas_bottom).offset(10);
        make.left.equalTo(price_label.mas_left);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(knock_field.mas_bottom).offset(10);
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

//去支付
- (void)touchSubmitButtonAction {
    if ([self.address_id isEqualToString:@""]) {
        [self showHUDWithTitle:@"请选择地址"];
        return;
    }
    
    NSMutableArray *shop_array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *shop_dic in self.data_dic[@"commodity_list"]) {
        NSDictionary *service_dic = @{@"commodity_id_":shop_dic[@"commodity_id_"],
                                      @"commodity_type_id_":shop_dic[@"contingency_type_id_"],
                                      @"number_":@([shop_dic[@"number_"] integerValue])
                                      };
        [shop_array addObject:service_dic];
    }
    
    //组建需要上传后台的数据
    NSDictionary *param = @{@"commodity_list":[shop_array copy],
                            @"address_id_":self.address_id,
                            @"user_coupon_id_":self.user_coupon_dic ? self.user_coupon_dic[@"id_"] : @"",
                            @"real_payment":@(self.real_price * 100),
                            @"match_send_type_":@"1",
                            @"pay_type_":self.data_dic[@"method_payment"][self.pay_type][@"serial_number_"],
                            @"discount_amount":self.user_coupon_dic ? self.user_coupon_dic[@"amount_"] : @"0",
                            @"leave_message_":@"买家留言",
                            @"promo_code_":@""
                            };
    
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/save_commodity_order" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"保存订单成功!!!");
            //调起支付宝支付
            [[AlipaySDK defaultService] payOrder:responseObject[@"data"] fromScheme:@"lixingPay" callback:^(NSDictionary *resultDic) {
                NSLog(@"AliPaySDK result == %@", resultDic);
            }];
        }else {
            NSLog(@"保存订单失败!!!");
        }
    } FailureBlock:^(id error) {
        NSLog(@"保存订单失败!!!");
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
