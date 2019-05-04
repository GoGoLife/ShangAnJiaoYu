//
//  ShowPersonalInfoViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShowPersonalInfoViewController.h"
#import "ShowPersonalInfoTableViewCell.h"

#import "EditPersonalMessageViewController.h"

#import <QBImagePickerController.h>

#import <UIImageView+WebCache.h>

@interface ShowPersonalInfoViewController ()<UITableViewDelegate, UITableViewDataSource, QBImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIImage *header_image;

@property (nonatomic, strong) NSMutableArray *info_data_array;

@property (nonatomic, strong) UIView *back_view;

//个性签名
@property (nonatomic, strong) NSString *personalMessage;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ShowPersonalInfoViewController

- (void)getHttpData {
    NSDictionary *parma = @{@"im_name_":self.im_name};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_user_message" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"personal information === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            NSString *sex = @"";
            if ([responseObject[@"data"][@"sex_"] integerValue] == 1) {
                sex = @"男";
            }else if ([responseObject[@"data"][@"sex_"] integerValue] == 2) {
                sex = @"女";
            }else {
                sex = @"未设置";
            }
            
            NSString *nick_name = responseObject[@"data"][@"nickname"] ?: [NSString stringWithFormat:@"默认:%@", responseObject[@"data"][@"name_"]];
            
            
            [weakSelf.dataArray replaceObjectAtIndex:0 withObject:responseObject[@"data"][@"picture"]];
            NSMutableArray *info_data_array = weakSelf.dataArray[1];
            [info_data_array replaceObjectAtIndex:0 withObject:nick_name];
            [info_data_array replaceObjectAtIndex:1 withObject:responseObject[@"data"][@"name_"]];
            [info_data_array replaceObjectAtIndex:2 withObject:sex];
            [weakSelf.dataArray replaceObjectAtIndex:2 withObject:responseObject[@"data"][@"signature_"]];
            [weakSelf.dataArray replaceObjectAtIndex:3 withObject:responseObject[@"data"][@"level_"]];
            self.personalMessage = responseObject[@"data"][@"signature_"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.title = @"编辑信息";
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.info_data_array = [NSMutableArray arrayWithArray:@[@"默认：18268865135", @"15158874572", @"未设置"]];
    //头像
    [self.dataArray addObject:@""];
    //昵称 考伴号码  性别
    [self.dataArray addObject:self.info_data_array];
    //签名
    [self.dataArray addObject:@""];
    //等级
    [self.dataArray addObject:@""];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"保存" target:self action:@selector(submitInfoAction)];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowPersonalHeaderTableViewCell class] forCellReuseIdentifier:@"header"];
    [self.tableview registerClass:[ShowPersonalInfoTableViewCell class] forCellReuseIdentifier:@"info"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getHttpData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShowPersonalHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header"];
        if (self.header_image) {
            cell.header_image.image = self.header_image;
        }else {
            NSString *url_string = self.dataArray[0];
            [cell.header_image sd_setImageWithURL:[NSURL URLWithString:url_string] placeholderImage:[UIImage imageNamed:@"date"]];
        }
        return cell;
    }else if (indexPath.section == 1) {
        NSMutableArray *array = self.dataArray[1];
        ShowPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
        cell.name_label.text = @[@"昵称：", @"考伴号：", @"性别："][indexPath.row];
        cell.content_label.text = array[indexPath.row];
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else {
        ShowPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.name_label.text = @"等级";
        cell.content_label.text = @"LV 28";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return HEADER_CELL_HEIGHT;
    }
    return INFO_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 10.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        CGFloat height = [self calculateRowHeight:self.personalMessage fontSize:14 withWidth:SCREENBOUNDS.width - 40];
        return 50.0 + height + 10.0;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = SetColor(246, 246, 246, 1);
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    if (section == 1) {
        footer_view.backgroundColor = WhiteColor;
        [self setFooterView:footer_view];
        footer_view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushEditPersonalMessageAction)];
        [footer_view addGestureRecognizer:tap];
        return footer_view;
    }
    footer_view.backgroundColor = SetColor(246, 246, 246, 1);
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self presentSelectImageVC];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        //昵称
        [self setNickName];
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        //性别
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"性别修改" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.info_data_array replaceObjectAtIndex:2 withObject:@"男"];
            [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.info_data_array replaceObjectAtIndex:2 withObject:@"女"];
            [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//设置昵称界面
- (void)setNickName {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.back_view = [[UIView alloc] initWithFrame:app.window.bounds];
    self.back_view.backgroundColor = SetColor(151, 151, 151, 0.8);
    [app.window addSubview:self.back_view];
    
    UIView *content_view = [[UIView alloc] init];
    content_view.backgroundColor = WhiteColor;
    [self.back_view addSubview:content_view];
    __weak typeof(self) weakSelf = self;
    [content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.back_view.mas_centerX);
        make.centerY.equalTo(weakSelf.back_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(280, 230));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"设置昵称";
    [content_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content_view.mas_top).offset(10);
        make.centerX.equalTo(content_view.mas_centerX);
    }];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.backgroundColor = DetailTextColor;
    [cancel addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [content_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(content_view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UITextField *field = [[UITextField alloc] init];
    field.placeholder = @"给自己取个名字吧";
    field.delegate = self;
    field.font = SetFont(14);
    field.clearButtonMode = UITextFieldViewModeAlways;
    UILabel *left_view = [[UILabel alloc] initWithFrame:FRAME(0, 0, 20, 10)];
    field.leftView = left_view;
    field.leftViewMode = UITextFieldViewModeAlways;
    ViewBorderRadius(field, 5.0, 1.0, DetailTextColor);
    [content_view addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(30);
        make.left.equalTo(content_view.mas_left).offset(20);
        make.right.equalTo(content_view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *confirme_button = [UIButton buttonWithType:UIButtonTypeCustom];
    confirme_button.titleLabel.font = SetFont(18);
    confirme_button.backgroundColor = ButtonColor;
    [confirme_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [confirme_button setTitle:@"确认" forState:UIControlStateNormal];
    [confirme_button addTarget:self action:@selector(confirmeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(confirme_button, 22.0);
    [content_view addSubview:confirme_button];
    [confirme_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(field.mas_bottom).offset(30);
        make.centerX.equalTo(content_view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(140, 44));
    }];
    
}

//跳转选择图片页面
- (void)presentSelectImageVC {
    QBImagePickerController *imagePicker = [[QBImagePickerController alloc] init];
    imagePicker.maximumNumberOfSelection = 1;
    imagePicker.allowsMultipleSelection = YES;
    imagePicker.showsNumberOfSelectedAssets = YES;
    imagePicker.mediaType = QBImagePickerMediaTypeImage;
    imagePicker.delegate = self;
    imagePicker.automaticallyAdjustsScrollViewInsets = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark --- QBImagePickerController delegate
//选取图片完成回调
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    [self dismissViewControllerAnimated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    for (PHAsset *asset in assets) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakSelf.header_image = result;
            [weakSelf submitPersonalHeaderImage:@[result]];
        }];
    }
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

//点击取消回调
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//删除设置昵称界面
- (void)cancelButtonAction {
    [self.back_view removeFromSuperview];
}

//确认修改昵称
- (void)confirmeButtonAction {
    [self cancelButtonAction];
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.info_data_array replaceObjectAtIndex:0 withObject:textField.text];
    NSLog(@"info data == %@", self.info_data_array);
}

- (void)submitInfoAction {
    __weak typeof(self) weakSelf = self;
    NSString *sex_string = [self.info_data_array[2] isEqualToString:@"男"] ? @"1" : @"2";
    NSDictionary *parma = @{
                            @"sex_":sex_string,
                            @"signature_":self.personalMessage,
                            @"name_":self.info_data_array[0]
                            };
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/edit_user_message" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"修改信息成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeUserInfoNotifacation" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//编辑用户头像
- (void)submitPersonalHeaderImage:(NSArray *)imageArray {
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/upload_picture" Dic:@{} imageArray:imageArray SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"编辑成功！！！！！！");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeUserInfoNotifacation" object:nil];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//设置个性签名
- (void)setFooterView:(UIView *)footer_view {
    UILabel *left = [[UILabel alloc] init];
    left.font = SetFont(16);
    left.text = @"个性签名";
    [footer_view addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer_view.mas_top).offset(10);
        make.left.equalTo(footer_view.mas_left).offset(20);
    }];
    
    UILabel *right = [[UILabel alloc] init];
    right.font = SetFont(16);
    right.textColor = DetailTextColor;
    right.text = @"未设置";
    [footer_view addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footer_view.mas_right).offset(-20);
        make.centerY.equalTo(left.mas_centerY);
    }];
    //如果有值的话就隐藏
    if (![self.personalMessage isEqualToString:@""]) {
        right.hidden = YES;
    }
    
    UILabel *content_label = [[UILabel alloc] init];
    content_label.font = SetFont(14);
    content_label.textColor = DetailTextColor;
    content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    content_label.numberOfLines = 0;
    content_label.text = self.personalMessage;
    [footer_view addSubview:content_label];
    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(left.mas_bottom).offset(10);
        make.left.equalTo(footer_view.mas_left).offset(20);
        make.bottom.equalTo(footer_view.mas_bottom).offset(-10);
        make.right.equalTo(footer_view.mas_right).offset(-20);
    }];
}

//跳转编辑个性签名
- (void)pushEditPersonalMessageAction {
    EditPersonalMessageViewController *edit = [[EditPersonalMessageViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    edit.returnMessageString = ^(NSString * _Nonnull message) {
        weakSelf.personalMessage = message;
        [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:edit animated:YES];
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
