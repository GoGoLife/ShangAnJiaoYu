//
//  BigTrainingSeventhViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigTrainingSeventhViewController.h"
#import "BigTrainingTableViewCell.h"
#import "CustomBigTrainingModel.h"
#import "BigTrainingEighthViewController.h"
#import "CustomTitleView.h"
#import "BottomShowMaterialsView.h"
#import "QuanZhenTestModel.h"
#import "CurrentQuestionInfoView.h"

@interface BigTrainingSeventhViewController ()<UITableViewDelegate, UITableViewDataSource, BigTrainingTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation BigTrainingSeventhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"布局总括--对策";
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushEightVC)];
    
    [self setTitleView];
    
    self.dataArr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 3; i++) {
        CustomBigTrainingModel *model = [[CustomBigTrainingModel alloc] init];
        model.content = @"";
        [self.dataArr addObject:model];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"请写下对策段的总括句";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomBigTrainingModel *model = self.dataArr[indexPath.row];
    BigTrainingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.isShowLeftImage = NO;
    cell.content_textview.text = model.content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60.0;
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
    button.frame = FRAME(20, 5, SCREENBOUNDS.width - 40, 50.0);
    button.backgroundColor = WhiteColor;
    button.titleLabel.font = SetFont(16);
    [button setTitleColor:SetColor(191, 191, 191, 1) forState:UIControlStateNormal];
    [button setTitle:@"新建总括句" forState:UIControlStateNormal];
    ViewRadius(button, 8.0);
    [self setBorderLine:button];
    [footer_view addSubview:button];
    [button addTarget:self action:@selector(addNewContentAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBorderLine:(UIButton *)label {
//    label.bounds = FRAME(0, 10, SCREENBOUNDS.width - 40, 40);
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

//- (void)returnFieldContent:(NSString *)content withIndexPath:(NSIndexPath *)indexPath {
//    CustomBigTrainingModel *model = self.dataArr[indexPath.row];
//    model.content = content;
//}

- (void)reloadTableviewCellTextView:(UITextView *)textView withIndexPath:(NSIndexPath *)indexPath withContentHieght:(CGFloat)height {
    CustomBigTrainingModel *bigModel = self.dataArr[indexPath.row];
    bigModel.content = textView.text;
    bigModel.content_height = height + 20.0;
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [textView becomeFirstResponder];
}

/**
 添加一个新的总括句
 */
- (void)addNewContentAction {
    CustomBigTrainingModel *model = [[CustomBigTrainingModel alloc] init];
    model.content = @"";
    model.content_height = 60.0;
    [self.dataArr addObject:model];
    [self.tableview reloadData];
}

- (void)pushEightVC {
    [self.view endEditing:YES];
    [NSKeyedArchiver archiveRootObject:self.dataArr toFile:BigTraining_DuiCe_File_Data];
    BigTrainingEighthViewController *eight = [[BigTrainingEighthViewController alloc] init];
    [self.navigationController pushViewController:eight animated:YES];
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
