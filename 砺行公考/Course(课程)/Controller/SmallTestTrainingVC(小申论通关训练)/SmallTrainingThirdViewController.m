//
//  SmallTrainingThirdViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SmallTrainingThirdViewController.h"
#import "BigTrainingTableViewCell.h"
#import "CustomBigTrainingModel.h"
#import "SmallTrainingFourthViewController.h"
#import "SmallTrainingFourRefiningViewController.h"
#import "CustomTitleView.h"
#import "BottomShowMaterialsView.h"
#import "QuanZhenTestModel.h"
#import "ShowMaterialsView.h"
#import "CurrentQuestionInfoView.h"

@interface SmallTrainingThirdViewController ()<UITableViewDelegate, UITableViewDataSource, BigTrainingTableViewCellDelegate, ShowMaterialsViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 区分   分点作答   分块作答
 */
@property (nonatomic, assign) NSInteger type_index;

@end

@implementation SmallTrainingThirdViewController

- (void)formatterData {
    for (int i = 0; i < 5; i++) {
        CustomBigTrainingModel *model = [[CustomBigTrainingModel alloc] init];
        model.content = @"";
        model.content_height = 60.0;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < 3; i++) {
            SmallContentModel *smallModel = [[SmallContentModel alloc] init];
            smallModel.small_content = @"";
            smallModel.small_content_height = 60.0;
            [array addObject:smallModel];
        }
        model.small_content_array = [array copy];
        [self.dataArray addObject:model];
    }
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"第三步：选择分类";
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushFourthVC)];
    
    [self setTitleView];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.type_index = 0;
    
    __weak typeof(self) weakSelf = self;
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"分点",@"分块"]];
    segment.selectedSegmentIndex = 0;
    [self.view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(180, 30));
    }];
    [segment addTarget:self action:@selector(changeTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BigTrainingTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segment.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [self formatterData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomBigTrainingModel *model = self.dataArray[indexPath.row];
    BigTrainingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.isShowLeftImage = NO;
    cell.indexPath = indexPath;
    if (self.type_index == 0) {
//        cell.content_textfield.placeholder = @"提炼作答";
    }else {
//        cell.content_textfield.placeholder = @"在此输入总括句";
    }
    cell.content_textview.text = model.content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomBigTrainingModel *model = self.dataArray[indexPath.row];
    return model.content_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    [self setFooterView:footer_view];
    return footer_view;
}

- (void)setFooterView:(UIView *)footer_view {
    footer_view.backgroundColor = WhiteColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = FRAME(20, 10, SCREENBOUNDS.width - 40, 50.0);
    button.backgroundColor = WhiteColor;
    button.titleLabel.font = SetFont(16);
    [button setTitleColor:SetColor(191, 191, 191, 1) forState:UIControlStateNormal];
    if (self.type_index == 0) {
        [button setTitle:@"新建提炼作答" forState:UIControlStateNormal];
    }else {
        [button setTitle:@"新建总括句" forState:UIControlStateNormal];
    }
    ViewRadius(button, 8.0);
    [self setBorderLine:button];
    [footer_view addSubview:button];
    [button addTarget:self action:@selector(addNewContentAction) forControlEvents:UIControlEventTouchUpInside];
}

//action
- (void)addNewContentAction {
    CustomBigTrainingModel *model = [[CustomBigTrainingModel alloc] init];
    model.content = @"";
    model.small_content_array = @[];
    [self.dataArray addObject:model];
    [self.tableview reloadData];
    [self.tableview scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)setBorderLine:(UIButton *)label {
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = SetColor(201, 201, 201, 1).CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:label.bounds].CGPath;
    border.frame = label.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    //设置线条的样式
//    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    [label.layer addSublayer:border];
}

- (void)reloadTableviewCellTextView:(UITextView *)textView withIndexPath:(NSIndexPath *)indexPath withContentHieght:(CGFloat)height{
    CustomBigTrainingModel *model = self.dataArray[indexPath.row];
    model.content = textView.text;
    model.content_height = height + 20.0;
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [textView becomeFirstResponder];
}

- (void)changeTypeAction:(UISegmentedControl *)segment {
    self.type_index = segment.selectedSegmentIndex;
    [self.tableview reloadData];
}

- (void)pushFourthVC {
    [self.view endEditing:YES];
    
    if (self.type_index == 0) {
        NSString *finish = @"";
        for (CustomBigTrainingModel *model in self.dataArray) {
            if (![model.content isEqualToString:@""]) {
                finish = [finish stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", model.content]];
            }
        }
        //分点
        SmallTrainingFourthViewController *fourth = [[SmallTrainingFourthViewController alloc] init];
        fourth.my_answer = finish;
        [self.navigationController pushViewController:fourth animated:YES];
    }else {
        //分块 提炼作答
        SmallTrainingFourRefiningViewController *refining = [[SmallTrainingFourRefiningViewController alloc] init];
        refining.dataArray = [self.dataArray copy];
        [self.navigationController pushViewController:refining animated:YES];
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

/**
 显示材料

 @param array 材料数组  （model）
 */
- (void)showMaterialsView:(NSArray *)array {
    [self.view endEditing:YES];
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BottomShowMaterialsView *materials_view = [[BottomShowMaterialsView alloc] initWithFrame:app_delegate.window.bounds];
    materials_view.dataArray = array;
    [app_delegate.window addSubview:materials_view];
}

/**
 显示采点
 */
- (void)touchPointsAction {
    [self.view endEditing:YES];
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ShowMaterialsView *show_view = [[ShowMaterialsView alloc] initWithFrame:app_delegate.window.bounds];
    show_view.delegate = self;
    NSArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:SmallTraining_Points_FIle_Data];
    show_view.points_array = dataArray;
    [app_delegate.window addSubview:show_view];
}

//采点delegate
- (void)touchPointAction:(NSString *)pointString {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = pointString;
    [self showHUDWithTitle:@"已复制"];
}

/**
 显示题目数据
 */
- (void)showQuestionAction {
    [self.view endEditing:YES];
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
