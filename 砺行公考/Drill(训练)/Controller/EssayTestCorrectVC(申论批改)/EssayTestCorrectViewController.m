//
//  EssayTestCorrectViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/21.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "EssayTestCorrectViewController.h"
#import "OptionSetting_TwoTableViewCell.h"
#import "SystemAnswerTableViewCell.h"
#import "CustomSelectFuntionPicker.h"
#import "OrderTwoTableViewCell.h"

@interface EssayTestCorrectViewController ()<UITableViewDelegate, UITableViewDataSource, touchChooseButtonDelegate, CustomSelectFunctionPickerDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) CustomSelectFuntionPicker *picker;

@property (nonatomic, strong) NSMutableArray *select_search_data;

//用户自己需要输入的标题
@property (nonatomic, strong) UITextField *field;

@end

@implementation EssayTestCorrectViewController

- (void)getSearchData {
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_correcting_conditions" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf hidden];
            weakSelf.testType = responseObject[@"data"][@"test_type_"];
            weakSelf.testProvice = responseObject[@"data"][@"provinces"];
            weakSelf.testYear = responseObject[@"data"][@"years"];
            NSLog(@"testType === %@", weakSelf.testType);
        }
        [weakSelf hidden];
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[OptionSetting_TwoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[SystemAnswerTableViewCell class] forCellReuseIdentifier:@"answerCell"];
    [self.tableview registerClass:[OrderTwoTableViewCell class] forCellReuseIdentifier:@"payCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 64, 0));
    }];
    [self getSearchData];
    
    self.select_search_data = [NSMutableArray arrayWithArray:@[@"", @"", @"", @""]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.select_search_data.count;
    }else if (section == 1) {
        return self.user_answer_array.count;
    }else if (section == 2) {
        return 0;
    }
    return self.payWay_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OptionSetting_TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.isShowLeftImage = NO;
        cell.isShowFunctionButton = YES;
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.titleLabel.text = @[@"试题来源", @"考试省份", @"考试年份", @"试卷名称"][indexPath.row];
        cell.FunctionLabel.text = self.select_search_data[indexPath.row];
        return cell;
    }else if (indexPath.section == 1) {
        SystemAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerCell"];
        cell.top_label.text = [NSString stringWithFormat:@"第%ld题", indexPath.row + 1];
        cell.content_label.text = self.user_answer_array[indexPath.row][@"content_"];
        return cell;
    }else if (indexPath.section == 2) {
        OptionSetting_TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.isShowLeftImage = NO;
        cell.isShowFunctionButton = YES;
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.titleLabel.text = @"批改类型";
        return cell;
    }else {
        OrderTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
        NSString *image_named = @[@"zhifubao", @"weixin"][indexPath.row];
        cell.image_view.image = [UIImage imageNamed:image_named];
        cell.content_label.text = self.payWay_array[indexPath.row][@"content"];
        cell.tag_label.text = @"";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 220.0;
    }
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.0;
    }else if (section == 2) {
        return 0.0;
    }else if (section == 3) {
        if (!self.isShowTestInfo) {
            return 0.0;
        }
        return 40.0;
    }else {
        if (!self.isShowTestInfo) {
            return 0.0;
        }
        return 140.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        if (!self.isShowTestInfo) {
            return 0.0;
        }
        return 100.0;
    }else if (section == 3) {
        if (!self.isShowTestInfo) {
            return 0.0;
        }
        return 120.0;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    if (section == 0) {
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(14);
        label.textColor = DetailTextColor;
        label.text = @"请选择您要批改的申论";
        [header_view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
        }];
    }else if (section == 1) {
        if (!self.isShowTestInfo) {
            return nil;
        }
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(14);
        label.textColor = DetailTextColor;
        label.text = @"您即将批改的申论为：";
        [header_view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(header_view.mas_top).offset(10);
            make.left.equalTo(header_view.mas_left).offset(20);
        }];
        
        UILabel *title_label = [[UILabel alloc] init];
        title_label.font = SetFont(18);
        title_label.text = @"浙江省 2017年 副省级 A卷";
        [header_view addSubview:title_label];
        [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(20);
            make.centerX.equalTo(header_view.mas_centerX);
        }];
        
        self.field = [[UITextField alloc] init];
        self.field.backgroundColor = SetColor(246, 246, 246, 1);
        self.field.textColor = DetailTextColor;
        self.field.font = SetFont(14);
        
        UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 20, 0)];
        self.field.leftView = left_label;
        self.field.leftViewMode = UITextFieldViewModeAlways;
        
        self.field.placeholder = @"请填写批改标题";
        ViewRadius(self.field, 8.0);
        [header_view addSubview:self.field];
        [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title_label.mas_bottom).offset(10);
            make.left.equalTo(label.mas_left);
            make.right.equalTo(header_view.mas_right).offset(-20);
            make.height.mas_equalTo(40);
        }];
    }else if (section == 3) {
        if (!self.isShowTestInfo) {
            return nil;
        }
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(14);
        label.textColor = DetailTextColor;
        label.text = @"支付方式";
        [header_view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
        }];
    }
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    if (section == 2) {
        if (!self.isShowTestInfo) {
            return nil;
        }
        footer_view.backgroundColor = WhiteColor;
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = SetColor(246, 246, 246, 1);
        [footer_view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footer_view.mas_top);
            make.left.equalTo(footer_view.mas_left);
            make.right.equalTo(footer_view.mas_right);
            make.height.mas_equalTo(10);
        }];
        
        UILabel *title = [[UILabel alloc] init];
        title.font = SetFont(14);
        title.textColor = DetailTextColor;
        title.text = @"订单信息";
        [footer_view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(10);
            make.left.equalTo(line.mas_left).offset(20);
        }];
        
        //批改信息
        UITextField *field = [[UITextField alloc] init];
        field.font = SetFont(14);
        field.text = @"2017年浙江省副省级真题";
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 80, 20)];
        leftLabel.font = SetFont(14);
        leftLabel.textColor = DetailTextColor;
        leftLabel.text = @"批改信息";
        field.leftViewMode = UITextFieldViewModeAlways;
        field.leftView = leftLabel;
        
        [footer_view addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(10);
            make.left.equalTo(footer_view.mas_left).offset(20);
            make.right.equalTo(footer_view.mas_right).offset(-20);
            make.height.mas_equalTo(40.0);
        }];
//        for (NSInteger index = 0; index < 1; index++) {
//            UITextField *field = [[UITextField alloc] init];
//            field.font = SetFont(14);
//            field.text = @[@"2017年浙江省副省级真题", @"所有题目（包括大小申论）", @"普通修改"][index];
//
//            UILabel *leftLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 80, 20)];
//            leftLabel.font = SetFont(14);
//            leftLabel.textColor = DetailTextColor;
//            leftLabel.text = @[@"批改信息", @"批改范围", @"批改类型"][index];
//            field.leftViewMode = UITextFieldViewModeAlways;
//            field.leftView = leftLabel;
//
//            [footer_view addSubview:field];
//            [field mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(title.mas_bottom).offset(10 + (40 + 10) * index);
//                make.left.equalTo(footer_view.mas_left).offset(20);
//                make.right.equalTo(footer_view.mas_right).offset(-20);
//                make.height.mas_equalTo(40.0);
//            }];
//        }
    }else if (section == 3) {
        if (!self.isShowTestInfo) {
            return nil;
        }
        footer_view.backgroundColor = WhiteColor;
        UILabel *title = [[UILabel alloc] init];
        title.font = SetFont(14);
        title.textColor = SetColor(48, 132, 252, 1);
        title.text = @"预计将在 1月29日 前收到批改结果";
        [footer_view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footer_view.mas_top).offset(10);
            make.centerX.equalTo(footer_view.mas_centerX);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(18);
        button.backgroundColor = ButtonColor;
        [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        [button setTitle:@"确认订单" forState:UIControlStateNormal];
        ViewRadius(button, 25.0);
        [button addTarget:self action:@selector(submitCorrectOrderAction) forControlEvents:UIControlEventTouchUpInside];
        [footer_view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(10);
            make.left.equalTo(footer_view.mas_left).offset(40);
            make.right.equalTo(footer_view.mas_right).offset(-40);
            make.height.mas_equalTo(50);
        }];
    }
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark -------- optionalSetting two cell  delegate
- (void)touchChooseButtonAndShowList:(NSIndexPath *)indexPath {
    self.current_indexPath = indexPath;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //考试类型
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *dic in self.testType) {
                    [array addObject:dic[@"content_"]];
                }
                self.picker = [[CustomSelectFuntionPicker alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 64 - 240, SCREENBOUNDS.width, 240)];
                self.picker.delegate = self;
                self.picker.dataArray = array;
                [self.view addSubview:self.picker];
            }
                break;
            case 1:
            {
                //考卷省份
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *dic in self.testProvice) {
                    [array addObject:dic[@"name_"]];
                }
                self.picker = [[CustomSelectFuntionPicker alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 64 - 240, SCREENBOUNDS.width, 240)];
                self.picker.delegate = self;
                self.picker.dataArray = array;
                [self.view addSubview:self.picker];
            }
                break;
            case 2:
            {
                //考卷年份
                self.picker = [[CustomSelectFuntionPicker alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 64 - 240, SCREENBOUNDS.width, 240)];
                self.picker.delegate = self;
                self.picker.dataArray = self.testYear;
                [self.view addSubview:self.picker];
            }
                break;
            case 3:
            {
                //需要先判断是否选择的搜索信息    都必选
                if (self.test_type_string && self.test_provice_string && self.test_year_string) {
                    [self getTestInfo];
                }else {
                    [self showHUDWithTitle:@"请选择完整的搜索信息"];
                    return;
                }
                
            }
                break;
                
            default:
                break;
        }
        
    }
}

#pragma mark ---- costom select function delegate
- (void)returnSelectFunctionStringAtIndex:(NSInteger)row {
    if (self.current_indexPath.section == 0) {
        switch (self.current_indexPath.row) {
            case 0:
            {
                self.test_type_string = self.testType[row][@"serial_number_"];//[NSString stringWithFormat:@"%ld", [self.testType[row][@"serial_number_"] integerValue]];
                [self.select_search_data replaceObjectAtIndex:0 withObject:self.testType[row][@"content_"]];
            }
                break;
            case 1:
            {
                self.test_provice_string = [NSString stringWithFormat:@"%ld", [self.testProvice[row][@"id_"] integerValue]];
                [self.select_search_data replaceObjectAtIndex:1 withObject:self.testProvice[row][@"name_"]];
            }
                break;
            case 2:
            {
                self.test_year_string = self.testYear[row];
                [self.select_search_data replaceObjectAtIndex:2 withObject:self.test_year_string];
            }
                break;
            case 3:
            {
                if (self.testArray.count == 0) {
                    return;
                }
                //保存试卷id
                self.test_id_string = self.testArray[row][@"id_"];
                [self.select_search_data replaceObjectAtIndex:3 withObject:self.testArray[row][@"title_"]];
                [self getTestInfoWithTestID:self.test_id_string];
            }
                break;
                
            default:
                break;
        }
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}


/**
 根据搜索条件  获取到的试卷列表信息
 */
- (void)getTestInfo {
    NSDictionary *parma = @{@"test_type_":self.test_type_string,
                            @"area_id_":self.test_provice_string,
                            @"year_":self.test_year_string
                            };
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_exam_list" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.testArray = responseObject[@"data"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"]) {
                [array addObject:dic[@"title_"]];
            }
            weakSelf.picker = [[CustomSelectFuntionPicker alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 64 - 240, SCREENBOUNDS.width, 240)];
            weakSelf.picker.delegate = self;
            weakSelf.picker.dataArray = [array copy];
            [weakSelf.view addSubview:weakSelf.picker];
            [weakSelf hidden];
        }else {
            NSLog(@"======有错误======");
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        [weakSelf hidden];
        NSLog(@"======有错误======");
    }];
}

/**
 获取试卷答案相关信息   支付方式相关信息

 @param test_id 试卷ID
 */
- (void)getTestInfoWithTestID:(NSString *)test_id {
    NSDictionary *parma = @{@"examid":test_id};
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_answer_paper" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.payWay_array = responseObject[@"data"][@"method_payment"];
            weakSelf.user_answer_array = responseObject[@"data"][@"essay_answer"];
            weakSelf.isShowTestInfo = YES;
            [weakSelf.tableview reloadData];
            [weakSelf hidden];
        }else {
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
}

/** 提交用户订单 */
- (void)submitCorrectOrderAction {
    if ([self.field.text isEqualToString:@""]) {
        [self showHUDWithTitle:@"请输入标题"];
        return;
    }
    
    NSDictionary *parma = @{@"exam_id_":self.test_id_string,
                            @"title_":self.field.text};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/insert_correcting" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf showHUDWithTitle:@"提交成功！"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [weakSelf showHUDWithTitle:@"提交失败！"];
        }
    } FailureBlock:^(id error) {
        [weakSelf showHUDWithTitle:@"提交失败！"];
    }];
}


#pragma mark ---- 懒加载
//- (CustomSelectFuntionPicker *)picker {
//    if (!_picker) {
//        _picker = [[CustomSelectFuntionPicker alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 64 - 240, SCREENBOUNDS.width, 240)];
//        _picker.delegate = self;
//    }
//    return _picker;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
