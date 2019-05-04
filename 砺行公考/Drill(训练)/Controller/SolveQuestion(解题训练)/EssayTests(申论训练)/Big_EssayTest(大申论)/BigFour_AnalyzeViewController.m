//
//  BigFour_ AnalyzeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BigFour_AnalyzeViewController.h"
#import "Classify_sectionView.h"
#import "ChooseMaterialsTableViewCell.h"
#import "input_SumUpTableViewCell.h"
#import "ClassifyModel.h"
#import "CustomMaterialsModel.h"
#import "SumUpModel.h"

#import "BigFour_chooseViewController.h"

@interface BigFour_AnalyzeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *top_tableview;

@property (nonatomic, strong) UITableView *bottom_tableview;

//默认输入5条总括句
@property (nonatomic, strong) NSArray *default_sum_up_array;

@end

@implementation BigFour_AnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    //从文件中读取采点数据
    self.top_array = [NSKeyedUnarchiver unarchiveObjectWithFile:Materials_data_file];
    
    
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < 5; index++) {
        SumUpModel *model = [[SumUpModel alloc] init];
        model.sum_up_string = @"在此输入总括句";
        model.refine_string = @"请完整作答";
        [mutableArr addObject:model];
    }
    self.default_sum_up_array = [mutableArr copy];
    
    [self setViewUI];
}

- (void)setViewUI {
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    if (self.type == SUPER_VC_TYPE_ANALYZE) {
        label.text = @"第四步：布局总括-分析";
    }else if (self.type == SUPER_VC_TYPE_COUNTERMEASURE) {
        label.text = @"第四步：布局总括-对策";
    }
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    self.top_tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.top_tableview.backgroundColor = WhiteColor;
    //隐藏tableview的分割线
    self.top_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.top_tableview.tag = 100;
    self.top_tableview.delegate = self;
    self.top_tableview.dataSource = self;
    [self.top_tableview registerClass:[ChooseMaterialsTableViewCell class] forCellReuseIdentifier:@"topCell"];
    [self.view addSubview:self.top_tableview];
    [self.top_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(SCREENBOUNDS.height / 4);
    }];
    
    
    self.bottom_tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.bottom_tableview.backgroundColor = WhiteColor;
    //隐藏tableview的分割线
    self.bottom_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bottom_tableview.tag = 200;
    self.bottom_tableview.delegate = self;
    self.bottom_tableview.dataSource = self;
    [self.bottom_tableview registerClass:[input_SumUpTableViewCell class] forCellReuseIdentifier:@"bottomCell"];
    [self.view addSubview:self.bottom_tableview];
    [self.bottom_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top_tableview.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 100) {
        return self.top_array.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        ClassifyModel *model = self.top_array[section];
        return model.materialsArray.count;
    }
    return self.default_sum_up_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        ClassifyModel *model = self.top_array[indexPath.section];
        CustomMaterialsModel *materialsModel = model.materialsArray[indexPath.row];
        ChooseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        cell.isHiddenRightImage = YES;
        cell.content_label.text = materialsModel.content_string;
        cell.tag_label.text = materialsModel.tag_string;
        return cell;
    }else if(tableView.tag == 200){
        SumUpModel *model = self.default_sum_up_array[indexPath.row];
        input_SumUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
        cell.input_field.delegate = self;
        cell.input_field.tag = indexPath.row;
        cell.input_field.text = model.sum_up_string;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        ClassifyModel *model = self.top_array[indexPath.section];
        CustomMaterialsModel *materialsModel = model.materialsArray[indexPath.row];
        return materialsModel.content_string_height + 50;
    }
    return INPUT_SUM_UP_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        ClassifyModel *model = self.top_array[section];
        Classify_sectionView *header_view = [[Classify_sectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 60) withIndexPath:section];
        header_view.backgroundColor = WhiteColor;
        header_view.section = section;
        header_view.isBlock = model.isBlock;
        return header_view;
    }else {
        UIView *header_view = [[UIView alloc] init];
        header_view.backgroundColor = WhiteColor;
        [self setHeader_view:header_view];
        return header_view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = WhiteColor;
    return footer_view;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 200) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark ----- customAction
- (void)setHeader_view:(UIView *)back_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    if (self.type == SUPER_VC_TYPE_ANALYZE) {
        label.text = @"请写下分析段的总括句";
    }else {
        label.text = @"请写下对策段的总括句";
    }
    [back_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back_view.mas_left).offset(20);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.titleLabel.font = SetFont(14);
    [addButton setTitleColor:ButtonColor forState:UIControlStateNormal];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
    
    UILabel *string_number_label = [[UILabel alloc] init];
    string_number_label.font = SetFont(14);
    string_number_label.textColor = DetailTextColor;
    string_number_label.text = @"100/3000";
    [back_view addSubview:string_number_label];
    [string_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addButton.mas_left).offset(-10);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
}

- (void)addButtonAction {
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.default_sum_up_array];
    SumUpModel *model = [[SumUpModel alloc] init];
    model.sum_up_string = @"在此输入总括句";
    model.refine_string = @"请完整作答";
    [mutableArr addObject:model];
    self.default_sum_up_array = [mutableArr copy];
    [self.bottom_tableview reloadData];
}

#pragma mark ---- textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSInteger index = textView.tag;
    SumUpModel *model = self.default_sum_up_array[index];
    model.sum_up_string = textView.text;
}

//下一步
- (void)nextAction {
    //隐藏键盘   确保数据存入到model中了
    [self.view endEditing:YES];
    
    NSMutableArray *data_arr = [NSMutableArray arrayWithCapacity:1];
    for (SumUpModel *model in self.default_sum_up_array) {
        if (![model.sum_up_string isEqualToString:@"在此输入总括句"]) {
            //将输入的总括句添加到数组中
            [data_arr addObject:model.sum_up_string];
        }
    }
    switch (self.type) {
        case SUPER_VC_TYPE_ANALYZE:
        {
            //将分析数据存入文件
            [data_arr  writeToFile:FenXi_data_file atomically:YES];
            //填写完分析总括句   跳转到选择系统给的最佳分析段选择页面
            BigFour_chooseViewController *choose = [[BigFour_chooseViewController alloc] init];
            choose.type = SUPER_VIEW_TYPE_ANALYZE;
            [self.navigationController pushViewController:choose animated:YES];
        }
            break;
        case SUPER_VC_TYPE_COUNTERMEASURE:
        {
            //将对策数据存入文件
            [data_arr writeToFile:DuiCe_data_file atomically:YES];
            //填写完对策总括句   跳转到选择系统给的最佳对策段选择页面
            BigFour_chooseViewController *choose = [[BigFour_chooseViewController alloc] init];
            choose.type = SUPER_VIEW_TYPE_COUNTERMEASURE;
            [self.navigationController pushViewController:choose animated:YES];
        }
            break;
            
        default:
            break;
    }
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
