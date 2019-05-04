//
//  BigEssayWriteAnalysisViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigEssayWriteAnalysisViewController.h"
#import "BigTrainingTableViewCell.h"
#import "CustomBigTrainingModel.h"
#import "ChooseDefaultContentViewController.h"

@interface BigEssayWriteAnalysisViewController ()<UITableViewDelegate, UITableViewDataSource, BigTrainingTableViewCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation BigEssayWriteAnalysisViewController

- (void)formatterData {
    self.dataArr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 2; i++) {
        CustomBigTrainingModel *bigModel = [[CustomBigTrainingModel alloc] init];
        bigModel.content = @"";
        bigModel.content_height = 60.0;
        NSMutableArray *small_array = [NSMutableArray arrayWithCapacity:1];
        for (int j = 0; j < 3; j++) {
            SmallContentModel *smallModel = [[SmallContentModel alloc] init];
            smallModel.small_content = [NSString stringWithFormat:@"分论点%d", j + 1];
            smallModel.small_content_height = 60.0;
            [small_array addObject:smallModel];
        }
        bigModel.small_content_array = [small_array copy];
        [self.dataArr addObject:bigModel];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextVC)];
    
    [self formatterData];
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"分析段示范";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    UITextView *textview = [[UITextView alloc] init];
    textview.font = SetFont(14);
    textview.scrollEnabled = NO;
    textview.editable = NO;
    textview.contentInset = UIEdgeInsetsMake(10, 20, 10, 20);
    textview.text = self.default_content;
    [self.view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_greaterThanOrEqualTo(150);
    }];
    
    UILabel *content_label = [[UILabel alloc] init];
    content_label.font = SetFont(14);
    content_label.textColor = DetailTextColor;
    content_label.text = @"请写下分析段的分析句和总括句";
    [self.view addSubview:content_label];
    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textview.mas_bottom).offset(10);
        make.left.equalTo(textview.mas_left).offset(20);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[BigTrainingTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CustomBigTrainingModel *model = self.dataArr[section];
    return model.small_content_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomBigTrainingModel *bigModel = self.dataArr[indexPath.section];
    SmallContentModel *model = bigModel.small_content_array[indexPath.row];
    BigTrainingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.isShowLeftImage = YES;
    cell.content_textview.text = model.small_content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomBigTrainingModel *bigModel = self.dataArr[indexPath.section];
    SmallContentModel *model = bigModel.small_content_array[indexPath.row];
    return model.small_content_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    [self setHeaderView:header_view withSection:section];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)setHeaderView:(UIView *)header_view withSection:(NSInteger)section {
    header_view.backgroundColor = WhiteColor;
    CustomBigTrainingModel *bigModel = self.dataArr[section];
    
    UITextField *user_title = [[UITextField alloc] init];
    user_title.backgroundColor = SetColor(246, 246, 246, 1);
    user_title.font = SetFont(14);
    user_title.textColor = SetColor(74, 74, 74, 1);
    
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 20, 0)];
    user_title.leftView = left_label;
    user_title.leftViewMode = UITextFieldViewModeAlways;
    user_title.placeholder = [NSString stringWithFormat:@"总括句%ld", section + 1];
    user_title.text = bigModel.content;
    ViewRadius(user_title, 8.0);
    user_title.tag = section;
    user_title.delegate = self;
    [header_view addSubview:user_title];
    [user_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(5);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(50.0);
    }];
}

/**
 获取内容
 
 @param textField section上的textfield
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    CustomBigTrainingModel *model = self.dataArr[textField.tag];
    model.content = textField.text;
}


/**
 获取cell输入的内容并刷新高度

 @param textView textview
 @param indexPath indexPath
 @param height 输入内容的高度
 */
- (void)reloadTableviewCellTextView:(UITextView *)textView withIndexPath:(NSIndexPath *)indexPath withContentHieght:(CGFloat)height {
    CustomBigTrainingModel *bigModel = self.dataArr[indexPath.section];
    SmallContentModel *model = bigModel.small_content_array[indexPath.row];
    model.small_content = textView.text;
    model.small_content_height = height + 20.0;
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [textView becomeFirstResponder];
}

- (void)pushNextVC {
    [self.view endEditing:YES];
    
    [NSKeyedArchiver archiveRootObject:self.dataArr toFile:BigTraining_FenXi_File_Data];
    
    ChooseDefaultContentViewController *choose = [[ChooseDefaultContentViewController alloc] init];
    choose.type = ChooseContentType_ChengJie;
    [self.navigationController pushViewController:choose animated:YES];
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
