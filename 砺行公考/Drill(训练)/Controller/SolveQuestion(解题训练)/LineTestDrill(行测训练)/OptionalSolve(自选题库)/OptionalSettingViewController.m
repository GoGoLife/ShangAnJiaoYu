//
//  OptionalSettingViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OptionalSettingViewController.h"
#import "OptionalSettingTableViewCell.h"
#import "OptionSetting_TwoTableViewCell.h"
#import "OptionalSettingModel.h"
#import "CustomSelectFuntionPicker.h"

@interface OptionalSettingViewController ()<UITableViewDelegate, UITableViewDataSource, touchChooseButtonDelegate, CustomSelectFunctionPickerDelegate, OptionalSettingTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

//cell中点击选择方法   下拉框
@property (nonatomic, strong) UITableView *downTableview;

/**
 当前的indexPath
 */
@property (nonatomic, strong) NSIndexPath *current_indexPath;

@end

@implementation OptionalSettingViewController

- (void)getHttpData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/optional_settings" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"setting data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf formatData:responseObject[@"data"]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)formatData:(NSDictionary *)dic {
    //数量配比
    NSMutableArray *numbers_mutable = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *numberDic in dic[@"choice_serial_list"]) {
        OptionalSettingModel *model = [[OptionalSettingModel alloc] init];
        model.isShowOperateButton = NO;
        model.big_id = numberDic[@"serial_number_"];
        model.titleString = numberDic[@"content_"];
        model.numberString = [NSString stringWithFormat:@"%ld", [numberDic[@"number_"] integerValue]];
        model.functionSelectArray = @[];
        model.user_select_function = @"";
        [numbers_mutable addObject:model];
    }
    
    //方法选择
    NSMutableArray *function_mutable = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *functionDic in dic[@"method_list"]) {
        OptionalSettingModel *model = [[OptionalSettingModel alloc] init];
        model.big_id = functionDic[@"id_"];
        model.titleString = functionDic[@"name_"];
        model.numberString = @"";
        model.user_select_function = @"";
        model.isShowOperateButton = NO;
        if ([[functionDic allKeys] containsObject:@"children"]) {
            //方法数组
            NSMutableArray *children_mutable = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *childrenDic in functionDic[@"children"]) {
                functionModel *funcModel = [[functionModel alloc] init];
                funcModel.parent_id = [NSString stringWithFormat:@"%ld", [childrenDic[@"parent_id_"] integerValue]];
                funcModel.function_id = [NSString stringWithFormat:@"%ld", [childrenDic[@"id_"] integerValue]];
                funcModel.function_name = childrenDic[@"name_"];
                [children_mutable addObject:funcModel];
            }
            model.functionSelectArray = [children_mutable copy];
        }else {
            model.functionSelectArray = @[];
        }
        [function_mutable addObject:model];
    }
    
    //来源选择
    NSMutableArray *source_mutable = [NSMutableArray arrayWithCapacity:1];
    OptionalSettingModel *model = [[OptionalSettingModel alloc] init];
    model.big_id = @"";
    model.titleString = @"来源选择";
    model.numberString = @"";
    model.user_select_function = @"";
    model.isShowOperateButton = NO;
    NSMutableArray *source_function = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *sourceDic in dic[@"source_list"]) {
        functionModel *funcModel = [[functionModel alloc] init];
        funcModel.function_id = [NSString stringWithFormat:@"%ld", [sourceDic[@"key"] integerValue]];
        funcModel.parent_id = @"";
        funcModel.function_name = sourceDic[@"value"];
        [source_function addObject:funcModel];
    }
    model.functionSelectArray = [source_function copy];
    [source_mutable addObject:model];
    
    self.dataArray = @[[numbers_mutable copy], [function_mutable copy], [source_mutable copy]];
    [self.tableview reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveUserSetting)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self setBack];
    [self setViewUI];
//    [self getData];
    
    [self getHttpData];
}

- (void)getData {
    //题量选择
    NSArray *numbersTitles = @[@{@"title":@"言语理解配比",@"numbers":@"10"},
                               @{@"title":@"数量关系配比",@"numbers":@"10"},
                               @{@"title":@"逻辑判断配比",@"numbers":@"10"},
                               @{@"title":@"资料分析配比",@"numbers":@"1"},
                               @{@"title":@"常识判断配比",@"numbers":@"10"},
                               @{@"title":@"综合分析配比",@"numbers":@"1"}];
    NSMutableArray *numbers_mutable = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in numbersTitles) {
        OptionalSettingModel *questionNumbersModel = [[OptionalSettingModel alloc] init];
        questionNumbersModel.titleString = dic[@"title"];
        questionNumbersModel.numberString = dic[@"numbers"];
        questionNumbersModel.isShowOperateButton = NO;
        [numbers_mutable addObject:questionNumbersModel];
    }
    
    //方法选择
    NSArray *function_titles = @[@{
                                     @"title":@"砺行常识方法",
                                     @"functions":@[@"关键词法", @"绝对性词语排除法", @"信息对应点法", @"共性排除法", @"矛盾排除法", @"逻辑分析法", @"命题者意图法", @"道德制高点法", @"常识积累法",]
                                     
                                     },
                                 @{
                                     @"title":@"砺行言语方法",
                                     @"functions":@[@"解释关系的信息对应点法", @"并列关系的信息对应点法", @"递进关系的信息对应点法", @"转折关系的信息对应点法", @"因果关系的信息对应点法", @"对比关系的信息对应点法", @"假设关系的信息对应点法", @"指代关系的信息对应点法", @"其他关系的信息对应点法", @"感情色彩的信息对应点法", @"重心信息的信息对应点法", @"加减量判断型的信息对应点法", @"观点提炼型的信息对应点法", @"程度维度法", @"具体抽象维度法", @"时间空间维度法", @"状态过程维度法", @"质量维度法", @"行为态度维度法", @"感官维度法", @"主被动（主客观）维度法", @"表里维度法", @"深广高维度法", @"深远与现实维度法", @"个体与整体维度法", @"属性维度法", @"信息关系类型判断法", @"信息重心判断法", @"信息关系变化判断法", @"信息对应点法", @"支撑信息法", @"问题问法法", @"逻辑排序法", @"留二排除法", @"意识化法"]
                                     
                                     },
                                 @{
                                     @"title":@"砺行资料方法",
                                     @"functions":@[@"图层分析法", @"信息定位法", @"综合分析法", @"公式求解法", @"尾数法", @"高位叠加法", @"拆分法", @"十字交叉法", @"百化分法", @"乘除转化法", @"假设法", @"直除法", @"估算法"]
                                     
                                     },
                                 @{
                                     @"title":@"砺行判断方法",
                                     @"functions":@[@"图形类别筛选法（对称性）", @"图形类别筛选法（曲直性）", @"图形类别筛选法（一笔画）", @"图形类别筛选法（封闭性）", @"图形类别筛选法（数量规律）", @"图形类别筛选法（位置规律）", @"图形类别筛选法（样式规律）", @"高阶类别分层法", @"特殊规律法", @"逻辑关系比较法", @"高阶逻辑分层法", @"纵向逻辑法", @"词性法", @"定义结构解析法", @"焦点信息筛选法", @"定义归纳法", @"逻辑断层秒杀术", @"逻辑符号抽象法", @"起点信息筛选法", @"点据明晰法", @"点据搭桥法", @"主题明晰法", @"矛盾信息挖掘法", @"加强削弱秒杀术", @"留二排除秒杀术", @"逻辑断层秒杀术"]
                                     
                                     },
                                 @{
                                     @"title":@"砺行数量方法",
                                     @"functions":@[@"作差法", @"作商法", @"数字特性法", @"通分法", @"递推法", @"特殊数列法", @"要素分析法", @"方程求解法", @"十字交叉法", @"代入排除法", @"条件具象法", @"纵横分析法", @"数字特性法", @"特值法", @"分类分步法", @"逆推法", @"公式求解法"]
                                     }
                                 ];
    NSMutableArray *function_mutable = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in function_titles) {
        OptionalSettingModel *model = [[OptionalSettingModel alloc] init];
        model.titleString = dic[@"title"];
        model.numberString = @"0";
        model.functionSelectArray = dic[@"functions"];
        [function_mutable addObject:model];
    }
    
    //来源选择
    NSArray *sourceArray = @[@{@"title":@"选择来源", @"source":@[@"错题本", @"优题本", @"全题库"]}];
    NSMutableArray *source_mutable = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in sourceArray) {
        OptionalSettingModel *model = [[OptionalSettingModel alloc] init];
        model.titleString = dic[@"title"];
        model.numberString = @"0";
        model.functionSelectArray = dic[@"source"];
        [source_mutable addObject:model];
    }
    
    self.dataArray = @[[numbers_mutable copy], [function_mutable copy], [source_mutable copy]];
    [self.tableview reloadData];
}

- (void)setViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = OPTIONAL_CELL_HEIGHT;
    [self.tableview registerClass:[OptionalSettingTableViewCell class] forCellReuseIdentifier:@"settingOne"];
    [self.tableview registerClass:[OptionSetting_TwoTableViewCell class] forCellReuseIdentifier:@"settingTwo"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark ------ tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    OptionalSettingModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        OptionalSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingOne"];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.isShowOperateButton = model.isShowOperateButton;
        cell.titleLabel.text = model.titleString;
        cell.numberLabel.text = model.numberString;
        //点击左侧视图 block
        cell.touchLeftImageBlock = ^(NSIndexPath *indexPath) {
            model.isShowOperateButton = !model.isShowOperateButton;
            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
    OptionSetting_TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingTwo"];
    cell.isShowFunctionButton = model.isShowOperateButton;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.titleLabel.text = model.titleString;
    cell.FunctionLabel.text = model.user_select_function;
    cell.touchLeftImageBlock = ^(NSIndexPath *indexPath) {
        model.isShowOperateButton = !model.isShowOperateButton;
        [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return 0.0;
    }
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return 0.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    for (UIView *vv in header_view.subviews) {
        [vv removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"题量选择（默认10题，可不选择）";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
    }];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.current_indexPath = indexPath;
    NSLog(@"current_indexpath === %@", self.current_indexPath);
}

#pragma mark ---- optionalSetting delegate
- (void)touchAddbuttonAction:(NSIndexPath *)indexPath {
    OptionalSettingModel *model = self.dataArray[indexPath.section][indexPath.row];
    NSInteger number = [model.numberString integerValue];
    number++;
    model.numberString = [NSString stringWithFormat:@"%ld", number];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)touchLessbuttonAction:(NSIndexPath *)indexPath {
    OptionalSettingModel *model = self.dataArray[indexPath.section][indexPath.row];
    NSInteger number = [model.numberString integerValue];
    if (number == 0) {
        [self showHUDWithTitle:@"数量不能为负数"];
        return;
    }
    number--;
    model.numberString = [NSString stringWithFormat:@"%ld", number];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark ---- optionalSetting_two  delegate
- (void)touchChooseButtonAndShowList:(NSIndexPath *)indexPath {
    OptionalSettingModel *model = self.dataArray[indexPath.section][indexPath.row];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (functionModel *funModel in model.functionSelectArray) {
        [array addObject:funModel.function_name];
    }
    
    CustomSelectFuntionPicker *picker = [[CustomSelectFuntionPicker alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 64 - 240, SCREENBOUNDS.width, 240)];
    picker.delegate = self;
    picker.dataArray = [array copy];
    [self.view addSubview:picker];
    self.current_indexPath = indexPath;
}

- (void)returnSelectFunctionStringAtIndex:(NSInteger)row {
    NSLog(@"row === %ld", row);
    OptionalSettingModel *model = self.dataArray[self.current_indexPath.section][self.current_indexPath.row];
    NSLog(@"array === %ld", model.functionSelectArray.count);
    functionModel *funcModel = model.functionSelectArray[row];
    model.user_select_function_id = funcModel.function_id;
    model.user_select_function = funcModel.function_name;
    [self.tableview reloadRowsAtIndexPaths:@[self.current_indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

/**
 保存用户的设置  并传递出去
 */
- (void)saveUserSetting {
    //保存用户有效的选择
//    NSMutableArray *user_select = [NSMutableArray arrayWithCapacity:1];
    
    if ([self.dataArray[1] count] == 0) {
        [self showHUDWithTitle:@"请选择至少一个方法"];
        return;
    }
    
    //整理数量关系  用户选择
    NSMutableArray *choice_serial_list = [NSMutableArray arrayWithCapacity:1];
    for (OptionalSettingModel *model in self.dataArray[0]) {
        if (model.isShowOperateButton) {
            //表示选中了大类
            NSDictionary *dic = @{@"serial_number_":model.big_id,@"number_":model.numberString};
            [choice_serial_list addObject:dic];
        }
    }
    
    //整理方法选择数据
    NSMutableArray *method_list = [NSMutableArray arrayWithCapacity:1];
    for (OptionalSettingModel *model in self.dataArray[1]) {
        if (model.isShowOperateButton) {
            //表示选中了大类
            if (model.functionSelectArray != 0) {
                //表示选中的大类是有效的  ==== 有具体的值
                //将用户选择的方法的ID存储起来
                [method_list addObject:model.user_select_function_id];
            }
        }
    }
    
    //整理来源数据
    NSString *source_string = @"";
    //整理方法选择数据
    for (OptionalSettingModel *model in self.dataArray[2]) {
        if (model.isShowOperateButton) {
            //表示选中了大类
            if (model.functionSelectArray != 0) {
                //表示选中的大类是有效的  ==== 有具体的值
                //将用户选择的来源key值存储起来
                source_string = model.user_select_function_id;
            }
        }
    }
    
    //整合数据 并通过block传递
    NSArray *user_select = @[[choice_serial_list copy], [method_list copy], source_string];
//    NSLog(@"array == %@", user_select);
    self.returnUserSelectSetting(user_select);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
