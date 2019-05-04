//
//  SumUpViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//
//
//                  第四步   总括

#import "SumUpViewController.h"
#import "Classify_sectionView.h"
#import "ChooseMaterialsTableViewCell.h"
#import "input_SumUpTableViewCell.h"
#import "ClassifyModel.h"
#import "CustomMaterialsModel.h"
#import "SumUpModel.h"

//第五步
#import "RefineViewController.h"

@interface SumUpViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *top_tableview;

@property (nonatomic, strong) UITableView *bottom_tableview;

//默认输入5条总括句
@property (nonatomic, strong) NSArray *default_sum_up_array;

@end

@implementation SumUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    
    
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
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(16);
    title_label.text = @"第四步：布局总括";
    [self.view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"整理分类";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
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


#pragma mark ----- customAction
- (void)setHeader_view:(UIView *)back_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"分点";
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

#pragma mark ---- textfield delegate
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
    [self.view endEditing:YES];
    
    RefineViewController *refine = [[RefineViewController alloc] init];
    refine.top_array = self.top_array;
    refine.bottom_array = self.default_sum_up_array;
    [self.navigationController pushViewController:refine animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
