//
//  BigEssayWriteMeasuresViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigEssayWriteMeasuresViewController.h"
#import "BigTrainingTableViewCell.h"
#import "CustomBigTrainingModel.h"
#import "ChooseDefaultContentViewController.h"

@interface BigEssayWriteMeasuresViewController ()<UITableViewDelegate, UITableViewDataSource, BigTrainingTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation BigEssayWriteMeasuresViewController

- (void)formatterData {
    self.dataArr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 3; i++) {
        CustomBigTrainingModel *model = [[CustomBigTrainingModel alloc] init];
        model.content = @"";
        model.content_height = 60.0;
        [self.dataArr addObject:model];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(puchNextVC)];
    
    [self formatterData];
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"对策段示范";
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
    content_label.text = @"请写下对策段的总括句";
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

- (void)puchNextVC {
    [self.view endEditing:YES];
    
    [NSKeyedArchiver archiveRootObject:self.dataArr toFile:BigTraining_DuiCe_File_Data];
    
    ChooseDefaultContentViewController *choose = [[ChooseDefaultContentViewController alloc] init];
    choose.type = ChooseContentType_JieWei;
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
