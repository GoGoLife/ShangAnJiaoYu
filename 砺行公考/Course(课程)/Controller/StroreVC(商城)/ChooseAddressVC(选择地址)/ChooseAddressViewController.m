//
//  ChooseAddressViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ChooseAddressViewController.h"
#import "AddressTableViewCell.h"
#import "AddNewAddressViewController.h"

@interface ChooseAddressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ChooseAddressViewController

/**
 查询所有的收货地址
 */
- (void)getAllAddressList {
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_receiving_address" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"all address list == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"];
            [weakSelf.tableview reloadData];
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllAddressList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.title = @"选择收货地址";
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    
    UIButton *add_new_address = [UIButton buttonWithType:UIButtonTypeCustom];
    add_new_address.titleLabel.font = SetFont(14);
    add_new_address.backgroundColor = ButtonColor;
    [add_new_address setTitleColor:WhiteColor forState:UIControlStateNormal];
    [add_new_address setTitle:@"添加新地址" forState:UIControlStateNormal];
    [add_new_address addTarget:self action:@selector(pushAddNewAddress) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(add_new_address, 20.0);
    [self.view addSubview:add_new_address];
    [add_new_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.tableview.mas_left).offset(20);
        make.right.equalTo(weakSelf.tableview.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data_dic = self.dataArray[indexPath.section];
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.name_label.text = [NSString stringWithFormat:@"%@   %@", data_dic[@"name_"], data_dic[@"phone_"]];
    cell.address_label.text = data_dic[@"address_"];
    if ([data_dic[@"is_default_"] isEqualToString:@"1"]) {
        cell.default_label.hidden = NO;
    }else {
        cell.default_label.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ADDRESS_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = SetColor(246, 246, 246, 1);
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = SetColor(246, 246, 246, 1);
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data_dic = self.dataArray[indexPath.section];
    NSString *name_string = [NSString stringWithFormat:@"%@   %@", data_dic[@"name_"], data_dic[@"phone_"]];
    if ([_delegate respondsToSelector:@selector(selectFinishAction:AddressConten:AddressID:)]) {
        [_delegate selectFinishAction:name_string AddressConten:data_dic[@"address_"] AddressID:data_dic[@"id_"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

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
    NSDictionary *data_dic = self.dataArray[indexPath.section];
    NSDictionary *parma = @{@"id_":data_dic[@"id_"]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_receiving_address" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf getAllAddressList];
            [weakSelf showHUDWithTitle:@"删除成功"];
        }
    } FailureBlock:^(id error) {
        
    }];
}

/** 添加新地址 */
- (void)pushAddNewAddress {
    AddNewAddressViewController *add_new = [[AddNewAddressViewController alloc] init];
    [self.navigationController pushViewController:add_new animated:YES];
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
