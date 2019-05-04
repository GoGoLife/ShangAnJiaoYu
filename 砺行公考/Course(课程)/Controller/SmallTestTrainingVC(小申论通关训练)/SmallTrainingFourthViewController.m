//
//  SmallTrainingFourthViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SmallTrainingFourthViewController.h"
#import "ShowAndWriteTableViewCell.h"
#import "SmallTrainingFifthViewController.h"
#import "CustomTitleView.h"
#import "BottomShowMaterialsView.h"
#import "QuanZhenTestModel.h"
#import "ShowMaterialsView.h"
#import "CurrentQuestionInfoView.h"

@interface SmallTrainingFourthViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSString *default_answer;

//@property (nonatomic, strong) NSString *my_answer;

@end

@implementation SmallTrainingFourthViewController

- (void)getDefaultAnswer {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"exam_id_":[[NSUserDefaults standardUserDefaults] objectForKey:@"smallTestTrainingID"],
                            @"order_":[[NSUserDefaults standardUserDefaults] objectForKey:@"current_smallTest_index"]};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_idol" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.default_answer = responseObject[@"data"][@"parsing_list_"][0];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"第四步：对比答案";
    [self setBack];
    
//    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushFifthVC)];
    
    [self setTitleView];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowAndWriteTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getDefaultAnswer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowAndWriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textview.tag = indexPath.section;
    cell.textview.delegate = self;
    if (indexPath.section == 0) {
        cell.textview.editable = NO;
        cell.textview.scrollEnabled = NO;
        cell.textview.text = self.default_answer;
    }else {
        cell.textview.scrollEnabled = NO;
        cell.textview.text = self.my_answer;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self calculateRowHeight:self.default_answer fontSize:14 withWidth:SCREENBOUNDS.width - 80.0] + 80.0;
    }
    return [self calculateRowHeight:self.my_answer fontSize:14 withWidth:SCREENBOUNDS.width - 80.0] + 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 70.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    [self setHeader_view:header_view withSection:section];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    if (section == 1) {
        [self setFooterView:footer_view];
    }
    return footer_view;
}

- (void)setHeader_view:(UIView *)header_view withSection:(NSInteger)section {
    header_view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @[@"参考答案",@"我的答案"][section];
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
}

- (void)setFooterView:(UIView *)footer_view {
    footer_view.backgroundColor = WhiteColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = ButtonColor;
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    ViewRadius(button, 25.0);
    [footer_view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer_view.mas_left).offset(90);
        make.right.equalTo(footer_view.mas_right).offset(-90);
        make.bottom.equalTo(footer_view.mas_bottom).offset(-10);
        make.height.mas_equalTo(50.0);
    }];
    [button addTarget:self action:@selector(pushFifthVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pushFifthVC {
    [self.view endEditing:YES];
    SmallTrainingFifthViewController *fifth = [[SmallTrainingFifthViewController alloc] init];
    fifth.my_answer = self.my_answer;
    [self.navigationController pushViewController:fifth animated:YES];
}

#pragma mark ---- textview delegate ----
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.tag == 1) {
        self.my_answer = textView.text;
    }
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
        make.size.mas_equalTo(CGSizeMake((SCREENBOUNDS.width - 100 - 110) / 3, 30.0));
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
    
    //题目按钮
    UIButton *showPointsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showPointsButton.titleLabel.font = SetFont(14);
    showPointsButton.backgroundColor = SetColor(246, 246, 246, 1);
    [showPointsButton setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [showPointsButton setTitle:@"采点" forState:UIControlStateNormal];
    ViewRadius(showPointsButton, 8.0);
    [titleView addSubview:showPointsButton];
    [showPointsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(showQuestionButton.mas_right).offset(30);
        make.size.equalTo(button);
    }];
    [showPointsButton addTarget:self action:@selector(touchPointsAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchShowMaterialsAction {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{
                            @"exam_id_":[[NSUserDefaults standardUserDefaults] objectForKey:@"smallTestTrainingID"],
                            @"order_":[[NSUserDefaults standardUserDefaults] objectForKey:@"current_smallTest_index"]
                            };
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
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BottomShowMaterialsView *materials_view = [[BottomShowMaterialsView alloc] initWithFrame:app_delegate.window.bounds];
    materials_view.dataArray = array;
    [app_delegate.window addSubview:materials_view];
}

/**
 显示采点
 */
- (void)touchPointsAction {
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ShowMaterialsView *show_view = [[ShowMaterialsView alloc] initWithFrame:app_delegate.window.bounds];
    NSArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:SmallTraining_Points_FIle_Data];
    show_view.points_array = dataArray;
    [app_delegate.window addSubview:show_view];
}

/**
 显示题目数据
 */
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
