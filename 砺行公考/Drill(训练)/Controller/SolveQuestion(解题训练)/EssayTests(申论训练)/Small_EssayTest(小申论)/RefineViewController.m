//
//  RefineViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "RefineViewController.h"
#import "Classify_sectionView.h"
#import "ChooseMaterialsTableViewCell.h"
#import "RefineTableViewCell.h"
#import "ClassifyModel.h"
#import "CustomMaterialsModel.h"
#import "SumUpModel.h"
#import "CompareStudyViewController.h"
#import "FormatterAnswerViewController.h"

@interface RefineViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *top_tableview;

@property (nonatomic, strong) UITableView *bottom_tableview;

@end

@implementation RefineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self setViewUI];
}

- (void)setViewUI {
    __weak typeof(self) weakSelf = self;
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(16);
    title_label.text = @"第五步：精炼写作";
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
    [self.bottom_tableview registerClass:[RefineTableViewCell class] forCellReuseIdentifier:@"bottomCell"];
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
    return self.bottom_array.count;
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
        SumUpModel *model = self.bottom_array[indexPath.row];
        RefineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
        cell.bottom_text_view.delegate = self;
        cell.bottom_text_view.tag = indexPath.row;
        cell.top_text_label.text = model.sum_up_string;
        cell.bottom_text_view.text = model.refine_string;
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
    SumUpModel *model = self.bottom_array[indexPath.row];
    return model.sum_up_string_height + 100;
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
    
    UILabel *string_number_label = [[UILabel alloc] init];
    string_number_label.font = SetFont(14);
    string_number_label.textColor = DetailTextColor;
    string_number_label.text = @"100/3000";
    [back_view addSubview:string_number_label];
    [string_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.centerY.equalTo(back_view.mas_centerY);
    }];
}

#pragma mark ---- textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSInteger index = textView.tag;
    SumUpModel *model = self.bottom_array[index];
    model.refine_string = textView.text;
}

//完成
- (void)finishAction {
    //拼接我的答案
    NSString *my_answer = @"";
    for (SumUpModel *model in self.bottom_array) {
        if (![model.refine_string isEqualToString:@"请完整作答"]) {
            my_answer = [my_answer stringByAppendingString:model.refine_string];
        }
    }
    FormatterAnswerViewController *formatter = [[FormatterAnswerViewController alloc] init];
    formatter.my_answer_string = my_answer;
    [self.navigationController pushViewController:formatter animated:YES];
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
