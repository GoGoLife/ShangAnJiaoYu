//
//  ClassifyViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//
//
//                  整理分类

#import "ClassifyViewController.h"
#import "Classify_sectionView.h"
#import "ClassifyModel.h"
#import "ChooseMaterialsViewController.h"
#import "ChooseMaterialsTableViewCell.h"
#import "CustomMaterialsModel.h"
#import "SumUpViewController.h"

@interface ClassifyViewController ()<UITableViewDelegate, UITableViewDataSource, touchSectionDelegate>

@property (nonatomic, strong) UITableView *tableview;

//默认的分区数量
@property (nonatomic, assign) NSInteger defaultSection;

/**
 分点数据数组
 */
@property (nonatomic, strong) NSArray *dataArr;

/**
 分块数据数组
 */
@property (nonatomic, strong) NSArray *blockDataArray;

//用于区分当前是分点    还是分块
@property (nonatomic, assign) BOOL isBlock;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.defaultSection = 5;
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    //初始化分点数据
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < self.defaultSection; index++) {
        ClassifyModel *model = [[ClassifyModel alloc] init];
        model.isBlock = NO;
        model.materialsArray = [NSArray new];
        [mutableArr addObject:model];
    }
    self.dataArr = [mutableArr copy];
    
    
    //初始化分块数据
    NSMutableArray *blockMutableArr = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < self.defaultSection; index++) {
        ClassifyModel *model = [[ClassifyModel alloc] init];
        model.isBlock = YES;
        model.materialsArray = [NSArray new];
        [blockMutableArr addObject:model];
    }
    self.blockDataArray = [blockMutableArr copy];
    
    [self setViewUI];
}

- (void)setViewUI {
    __weak typeof(self) weakSelf = self;
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(16);
    title_label.text = @"第三步：整理分类";
    [self.view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"分点", @"分块"]];
    [segment setSelectedSegmentIndex:0];
    [segment addTarget:self action:@selector(changeClassifyStatus:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(170);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    //隐藏tableview的分割线
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ChooseMaterialsTableViewCell class] forCellReuseIdentifier:@"classifyCell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segment.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isBlock) {
        //分块
        return self.blockDataArray.count;
    }
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isBlock) {
        ClassifyModel *model = self.blockDataArray[section];
        return model.materialsArray.count;
    }
    ClassifyModel *model = self.dataArr[section];
    return model.materialsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isBlock) {
        ClassifyModel *model = self.blockDataArray[indexPath.section];
        CustomMaterialsModel *materialsModel = model.materialsArray[indexPath.row];
        ChooseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classifyCell"];
        cell.isHiddenRightImage = YES;
        cell.content_label.text = materialsModel.content_string;
        cell.tag_label.text = materialsModel.tag_string;
        return cell;
    }
    
    ClassifyModel *model = self.dataArr[indexPath.section];
    CustomMaterialsModel *materialsModel = model.materialsArray[indexPath.row];
    ChooseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classifyCell"];
    cell.isHiddenRightImage = YES;
    cell.content_label.text = materialsModel.content_string;
    cell.tag_label.text = materialsModel.tag_string;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isBlock) {
        ClassifyModel *model = self.blockDataArray[indexPath.section];
        CustomMaterialsModel *materialsModel = model.materialsArray[indexPath.row];
        return materialsModel.content_string_height + 50;
    }
    
    ClassifyModel *model = self.dataArr[indexPath.section];
    CustomMaterialsModel *materialsModel = model.materialsArray[indexPath.row];
    return materialsModel.content_string_height + 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isBlock) {
        if (section == self.blockDataArray.count - 1) {
            return 60.0;
        }
    }else {
        if (section == self.dataArr.count - 1) {
            return 60.0;
        }
    }
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isBlock) {
        ClassifyModel *model = self.blockDataArray[section];
        Classify_sectionView *header_view = [[Classify_sectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 60) withIndexPath:section];
        header_view.delegate = self;
        header_view.backgroundColor = WhiteColor;
        header_view.section = section;
        header_view.isBlock = model.isBlock;
        return header_view;
    }
    
    ClassifyModel *model = self.dataArr[section];
    Classify_sectionView *header_view = [[Classify_sectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 60) withIndexPath:section];
    header_view.delegate = self;
    header_view.backgroundColor = WhiteColor;
    header_view.section = section;
    header_view.isBlock = model.isBlock;
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = WhiteColor;
    if (self.isBlock) {
        if (section == self.blockDataArray.count - 1) {
            [self setLastSectionFooterContent:footer_view];
        }
    }else {
        if (section == self.dataArr.count - 1) {
            [self setLastSectionFooterContent:footer_view];
        }
    }
    return footer_view;
}

- (void)setLastSectionFooterContent:(UIView *)footer_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = DetailTextColor;
    label.text = @"新建分点";
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAddSection)];
    [label addGestureRecognizer:tap];
    [footer_view addSubview:label];
    [self setBorderLine:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
}

#pragma mark --- Cell删除操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//删除的具体操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isBlock) {
        ClassifyModel *classifyModel = self.blockDataArray[indexPath.section];
        CustomMaterialsModel *model = classifyModel.materialsArray[indexPath.row];
        NSMutableArray *array = [NSMutableArray arrayWithArray:classifyModel.materialsArray];
        [array removeObject:model];
        classifyModel.materialsArray = [array mutableCopy];
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    ClassifyModel *classifyModel = self.dataArr[indexPath.section];
    CustomMaterialsModel *model = classifyModel.materialsArray[indexPath.row];
    NSMutableArray *array = [NSMutableArray arrayWithArray:classifyModel.materialsArray];
    [array removeObject:model];
    classifyModel.materialsArray = [array mutableCopy];
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark --- custom action
//改变分点    分块状态
- (void)changeClassifyStatus:(UISegmentedControl *)segment {
    NSInteger index = [segment selectedSegmentIndex];
    if (index == 0) {
        for (ClassifyModel *model in self.dataArr) {
            model.isBlock = NO;
        }
        self.isBlock = NO;
        [self.tableview reloadData];
    }else {
        for (ClassifyModel *model in self.dataArr) {
            model.isBlock = YES;
        }
        self.isBlock = YES;
        [self.tableview reloadData];
    }
}

//新建分点
- (void)touchAddSection {
    if (self.isBlock) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.blockDataArray];
        ClassifyModel *model = [[ClassifyModel alloc] init];
        model.isBlock = self.isBlock;
        model.materialsArray = [NSArray new];
        [array addObject:model];
        self.blockDataArray = [array copy];
        [self.tableview reloadData];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArr];
    ClassifyModel *model = [[ClassifyModel alloc] init];
    model.isBlock = self.isBlock;
    model.materialsArray = [NSArray new];
    [array addObject:model];
    self.dataArr = [array copy];
    [self.tableview reloadData];
}

//下一步
- (void)nextAction {
    SumUpViewController *sumUp = [[SumUpViewController alloc] init];
    if (self.isBlock) {
        sumUp.top_array = self.blockDataArray;
    }else {
        sumUp.top_array = self.dataArr;
    }
    [self.navigationController pushViewController:sumUp animated:YES];
}


#pragma mark ---- custom delegate

/**
 点击选择采点执行方法

 @param section 点击的section  index
 */
- (void)touchSectionAction:(NSInteger)section {
    __weak typeof(self) weakSelf = self;
    ClassifyModel *model = self.isBlock ? self.blockDataArray[section] : self.dataArr[section];
    ChooseMaterialsViewController *materials = [[ChooseMaterialsViewController alloc] init];
    materials.returnSelectedData = ^(NSArray *data_array) {
        model.materialsArray = data_array;
        [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:materials animated:YES];
}



- (void)setBorderLine:(UILabel *)label {
    label.bounds = FRAME(0, 10, SCREENBOUNDS.width - 40, 40);
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
