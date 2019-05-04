//
//  Big_ChooseMaterialsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Big_ChooseMaterialsViewController.h"
#import "Big_SectionView.h"
#import "ChooseMaterialsTableViewCell.h"
#import "ChooseMaterialsViewController.h"
#import "ClassifyModel.h"
#import "CustomMaterialsModel.h"
#import "BigFour_WriteViewController.h"

@interface Big_ChooseMaterialsViewController ()<UITableViewDelegate, UITableViewDataSource, Big_touchSectionDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation Big_ChooseMaterialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < 5; index++) {
        ClassifyModel *model = [[ClassifyModel alloc] init];
        model.materialsArray = [NSArray new];
        [mutableArr addObject:model];
    }
    self.dataArray = [mutableArr copy];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self setBack];
    [self creatViewUI];
}

- (void)creatViewUI {
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"第三步：整理分类";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    //隐藏tableview的分割线
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ChooseMaterialsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ClassifyModel *model = self.dataArray[section];
    return model.materialsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyModel *classModel = self.dataArray[indexPath.section];
    CustomMaterialsModel *model = classModel.materialsArray[indexPath.row];
    ChooseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isHiddenRightImage = YES;
    cell.content_label.text = model.content_string;
    cell.tag_label.text = model.tag_string;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyModel *classModel = self.dataArray[indexPath.section];
    CustomMaterialsModel *model = classModel.materialsArray[indexPath.row];
    return model.content_string_height + 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *array;
    if(self.isType) {
        array = @[@"引", @"析", @"承", @"策", @"结"];
    }else {
        array = @[@"引", @"析", @"析", @"析", @"结"];
    }
    Big_SectionView *header_view = [[Big_SectionView alloc] init];
    header_view.leftLabel.text = array[section];
    header_view.delegate = self;
    header_view.section = section;
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = WhiteColor;
    return footer_view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- custom delegate
- (void)touchSectionPushVC:(NSInteger)section {
    __weak typeof(self) weakSelf = self;
    ClassifyModel *model = self.dataArray[section];
    ChooseMaterialsViewController *materials = [[ChooseMaterialsViewController alloc] init];
    materials.returnSelectedData = ^(NSArray *data_array) {
        NSLog(@"data_array == %@", data_array);
        model.materialsArray = data_array;
        [weakSelf.tableview reloadData];
    };
    [self.navigationController pushViewController:materials animated:YES];
}

- (void)nextAction {
    NSArray *array;
    if(self.isType) {
        array = @[@"引", @"析", @"承", @"策", @"结"];
    }else {
        array = @[@"引", @"析", @"析", @"析", @"结"];
    }
    BigFour_WriteViewController *four = [[BigFour_WriteViewController alloc] init];
    four.section_left_array = array;
    four.top_array = self.dataArray;
    [self.navigationController pushViewController:four animated:YES];
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
