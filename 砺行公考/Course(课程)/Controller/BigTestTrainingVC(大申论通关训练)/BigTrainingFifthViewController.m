//
//  BigTrainingFifthViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigTrainingFifthViewController.h"
#import "BigTrainingTableViewCell.h"
#import "CustomBigTrainingModel.h"
#import "BigTrainingSixthViewController.h"
#import "CustomTitleView.h"
#import "BottomShowMaterialsView.h"
#import "QuanZhenTestModel.h"
#import "CurrentQuestionInfoView.h"

@interface BigTrainingFifthViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, BigTrainingTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation BigTrainingFifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"布局总括--分析";
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushSixthVC)];
    
    [self setTitleView];
    
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 2; i++) {
        CustomBigTrainingModel *bigModel = [[CustomBigTrainingModel alloc] init];
        bigModel.content = @"";
        bigModel.content_height = 60.0;
        NSMutableArray *small_array = [NSMutableArray arrayWithCapacity:1];
        for (int j = 0; j < 3; j++) {
            SmallContentModel *smallModel = [[SmallContentModel alloc] init];
            smallModel.small_content = @"";
            smallModel.small_content_height = 60.0;
            [small_array addObject:smallModel];
        }
        bigModel.small_content_array = [small_array copy];
        [data addObject:bigModel];
    }
    self.dataArr = [data copy];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"请写下分析段的分析句和总括句";
    [self.view addSubview:label];
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[BigTrainingTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
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
    user_title.placeholder = @"请输入分析内容";
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
 获取细分点的内容

 @param content 具体内容
 @param indexPath indexPath
 */
- (void)reloadTableviewCellTextView:(UITextView *)textView withIndexPath:(NSIndexPath *)indexPath withContentHieght:(CGFloat)height {
    CustomBigTrainingModel *bigModel = self.dataArr[indexPath.section];
    SmallContentModel *model = bigModel.small_content_array[indexPath.row];
    model.small_content = textView.text;
    model.small_content_height = height + 20.0;
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [textView becomeFirstResponder];
}

/**
 跳转到第六步
 */
- (void)pushSixthVC {
    [self.view endEditing:YES];
    [NSKeyedArchiver archiveRootObject:self.dataArr toFile:BigTraining_FenXi_File_Data];
    BigTrainingSixthViewController *six = [[BigTrainingSixthViewController alloc] init];
    [self.navigationController pushViewController:six animated:YES];
}

- (void)setTitleView {
    CustomTitleView *titleView = [[CustomTitleView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40.0)];
    self.navigationItem.titleView = titleView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = SetFont(14);
    button.backgroundColor = SetColor(246, 246, 246, 1);
    [button setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [button setTitle:@"材料" forState:UIControlStateNormal];
    ViewRadius(button, 8.0);
    [titleView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(titleView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake((SCREENBOUNDS.width - 70 - 110) / 2, 30.0));
    }];
    [button addTarget:self action:@selector(touchShowMaterialsAction) forControlEvents:UIControlEventTouchUpInside];
    //题目按钮
    UIButton *showQuestionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showQuestionButton.titleLabel.font = SetFont(14);
    showQuestionButton.backgroundColor = SetColor(246, 246, 246, 1);
    [showQuestionButton setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [showQuestionButton setTitle:@"题目" forState:UIControlStateNormal];
    ViewRadius(showQuestionButton, 8.0);
    [titleView addSubview:showQuestionButton];
    [showQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(button.mas_right).offset(30);
        make.size.equalTo(button);
    }];
    [showQuestionButton addTarget:self action:@selector(showQuestionAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchShowMaterialsAction {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"exam_id_":[[NSUserDefaults standardUserDefaults] objectForKey:@"bigTestTrainingExamID"],
                            @"order_":@"1"};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_material_list" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"]) {
                EssayTestQuanZhenMaterialsModel *model = [[EssayTestQuanZhenMaterialsModel alloc] init];
                model.materials_id = @"";
                model.materials_content = dic[@"content_"];
                model.materials_image_array = @[];
                [data addObject:model];
            }
            [weakSelf showMaterialsView:[data copy]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)showMaterialsView:(NSArray *)array {
    AppDelegate *delegate_app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BottomShowMaterialsView *materials_view = [[BottomShowMaterialsView alloc] initWithFrame:delegate_app.window.bounds];
    materials_view.dataArray = array;
    [delegate_app.window addSubview:materials_view];
}

//显示题目数据
- (void)showQuestionAction {
    NSString *info_string = [NSString  stringWithContentsOfFile:CurrentTestTraining_QuestionInfo_File_Data encoding:NSUTF8StringEncoding error:nil];
    AppDelegate *current_window = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CurrentQuestionInfoView *questionInfo_view = [[CurrentQuestionInfoView alloc] initWithFrame:current_window.window.bounds withInfoString:info_string];
    [current_window.window addSubview:questionInfo_view];
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
