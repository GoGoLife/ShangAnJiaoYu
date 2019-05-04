//
//  BigFour_WriteViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BigFour_WriteViewController.h"
#import "ChooseMaterialsTableViewCell.h"
#import "ClassifyModel.h"
#import "CustomMaterialsModel.h"
#import "Big_SectionView.h"
#import "BigFour_chooseViewController.h"

@interface BigFour_WriteViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation BigFour_WriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self creatViewUI];
    
    //将上级页面获取的采点数据   保存到文件中
    [NSKeyedArchiver archiveRootObject:self.top_array toFile:Materials_data_file];
}

- (void)creatViewUI {
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //隐藏tableview的分割线
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ChooseMaterialsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, SCREENBOUNDS.height / 2, 0));
    }];
    
    [self setBottomView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.top_array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ClassifyModel *model = self.top_array[section];
    return model.materialsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyModel *classifyModel = self.top_array[indexPath.section];
    CustomMaterialsModel *model = classifyModel.materialsArray[indexPath.row];
    ChooseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.content_label.text = model.content_string;
    cell.tag_label.text = model.tag_string;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyModel *classifyModel = self.top_array[indexPath.section];
    CustomMaterialsModel *model = classifyModel.materialsArray[indexPath.row];
    return model.content_string_height + 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Big_SectionView *header_view = [[Big_SectionView alloc] init];
    header_view.leftLabel.text = self.section_left_array[section];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = WhiteColor;
    return footer_view;
}

#pragma mark ----- bottom view
- (void)setBottomView {
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"引言段";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    UITextView *textV = [[UITextView alloc] init];
    textV.delegate = self;
    textV.font = SetFont(14);
    textV.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(textV, 8.0);
    [self.view addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
    }];
}

- (void)nextAction {
    BigFour_chooseViewController *choose = [[BigFour_chooseViewController alloc] init];
    choose.type = SUPER_VIEW_TYPE_WRITE_INTRODUCTION;
    [self.navigationController pushViewController:choose animated:YES];
}

//引言框   完成之后  存入文件  方便读取
- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    NSString *string = textView.text;
    [string writeToFile:YinYan_data_file atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
