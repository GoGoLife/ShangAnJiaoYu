//
//  ClassViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/25.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ClassViewController.h"
#import "ClassTableViewCell.h"

@interface ClassViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = @[@{@"title":@"一线多途综合班",@"desc":@"相当的不错哈哈哈哈～",@"path":@"class_1"},
                       @{@"title":@"一线多途全程笔试精英班",@"desc":@"相当的不错哈哈哈哈～",@"path":@"class_2"},
                       @{@"title":@"公考笔试长效综合班",@"desc":@"相当的不错哈哈哈哈～",@"path":@"class_3"},
                       @{@"title":@"小团队",@"desc":@"相当的不错哈哈哈哈～",@"path":@"class_4"},
                       @{@"title":@"长效班",@"desc":@"相当的不错哈哈哈哈～",@"path":@"class_5"}];
    
    
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ClassTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.back_view.layer.contents = (id)[UIImage imageNamed:dic[@"path"]].CGImage;
    cell.top_label.text = dic[@"title"];
    cell.bottom_label.text = dic[@"desc"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
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
