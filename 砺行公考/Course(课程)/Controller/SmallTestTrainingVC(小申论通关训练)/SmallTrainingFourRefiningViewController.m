//
//  SmallTrainingFourRefiningViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SmallTrainingFourRefiningViewController.h"
#import "BigTrainingTableViewCell.h"
#import "SmallTrainingFourthViewController.h"
#import "CustomBigTrainingModel.h"
#import "CustomTitleView.h"
#import "BottomShowMaterialsView.h"
#import "QuanZhenTestModel.h"
#import "ShowMaterialsView.h"
#import "CurrentQuestionInfoView.h"

@interface SmallTrainingFourRefiningViewController ()<UITableViewDelegate, UITableViewDataSource, BigTrainingTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation SmallTrainingFourRefiningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextAction)];
    
    [self setTitleView];
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"提炼作答";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CustomBigTrainingModel *bigModel = self.dataArray[section];
    return bigModel.small_content_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomBigTrainingModel *bigModel = self.dataArray[indexPath.section];
    SmallContentModel *model = bigModel.small_content_array[indexPath.row];
    BigTrainingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.indexPath = indexPath;
    cell.isShowLeftImage = YES;
    cell.delegate = self;
    cell.content_textview.text = model.small_content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomBigTrainingModel *bigModel = self.dataArray[indexPath.section];
    SmallContentModel *model = bigModel.small_content_array[indexPath.row];
    return model.small_content_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CustomBigTrainingModel *model = self.dataArray[section];
    return [self calculateRowHeight:model.content fontSize:16 withWidth:SCREENBOUNDS.width - 80] + 40.0;
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

- (void)setHeaderView:(UIView *)header_view withSection:(NSInteger)section {
    CustomBigTrainingModel *model = self.dataArray[section];
    header_view.backgroundColor = WhiteColor;
    UITextView *section_textview = [[UITextView alloc] init];
    section_textview.editable = NO;
    section_textview.font = SetFont(16);
    section_textview.textColor = SetColor(74, 74, 74, 1);
    section_textview.backgroundColor = SetColor(246, 246, 246, 1);
    section_textview.textContainerInset = UIEdgeInsetsMake(10, 20, 10, 20);
    section_textview.text = model.content;
    [header_view addSubview:section_textview];
    [section_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(5, 20, 5, 20));
    }];
}

- (void)pushNextAction {
    
    NSString *finish = @"";
    for (CustomBigTrainingModel *model in self.dataArray) {
        if (![model.content isEqualToString:@""]) {
            finish = [NSString stringWithFormat:@"%@%@\n\n", finish, model.content];
            for (SmallContentModel *smallModel in model.small_content_array) {
                if (![smallModel.small_content isEqualToString:@""]) {
                    finish = [NSString stringWithFormat:@"%@提炼：%@\n\n", finish, smallModel.small_content];
                }
            }
        }
    }
    SmallTrainingFourthViewController *fourth = [[SmallTrainingFourthViewController alloc] init];
    fourth.my_answer = finish;
    [self.navigationController pushViewController:fourth animated:YES];
}

- (void)reloadTableviewCellTextView:(UITextView *)textView withIndexPath:(NSIndexPath *)indexPath withContentHieght:(CGFloat)height {
    CustomBigTrainingModel *bigModel = self.dataArray[indexPath.section];
    SmallContentModel *model = bigModel.small_content_array[indexPath.row];
    model.small_content = textView.text;
    model.small_content_height = height + 20.0;
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [textView becomeFirstResponder];
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
