//
//  BigEssaySecondViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigEssaySecondViewController.h"
#import "BigEssayTitleTableViewCell.h"
//撰写标题
#import "BigEssayThirdViewController.h"

@interface BigEssaySecondViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSString *choosed_default_title;

@end

@implementation BigEssaySecondViewController

- (void)getDefaultTitle {
    NSDictionary *parma = @{@"essay_id_":[[NSUserDefaults standardUserDefaults] objectForKey:@"bigEssayTest_essay_id"]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_big_essay_title" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"big essay test === %@", responseObject);
            weakSelf.dataArray = responseObject[@"data"][@"title_list_"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择标题";
    [self setBack];
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextAction)];
    
    //整理题目数据
    NSString *question_info = [NSString stringWithContentsOfFile:CurrentTestTraining_QuestionInfo_File_Data encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [question_info componentsSeparatedByString:@"++++++"];
    
    __weak typeof(self) weakSelf = self;
    //题干
    UILabel *topic = [[UILabel alloc] init];
    topic.font = SetFont(16);
    topic.numberOfLines = 0;
    topic.text = array[0];
    [self.view addSubview:topic];
    [topic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
    }];
    
    UILabel *require = [[UILabel alloc] init];
    require.font = SetFont(14);
    require.textColor = DetailTextColor;
    require.numberOfLines = 0;
    require.text = array[1];
    [self.view addSubview:require];
    [require mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topic.mas_bottom).offset(5);
        make.left.equalTo(topic.mas_left);
        make.right.equalTo(topic.mas_right);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(require.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(10.0);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"从下列标题中选出你觉得最合适的1项：";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(require.mas_left);
        make.right.equalTo(require.mas_right);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BigEssayTitleTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [self getDefaultTitle];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    BigEssayTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.title_label.text = dic[@"title_"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    self.choosed_default_title = dic[@"title_"];
}

- (void)pushNextAction {
    if (!self.choosed_default_title) {
        [self showHUDWithTitle:@"请选择一个标题进行作答"];
        return;
    }
    BigEssayThirdViewController *third = [[BigEssayThirdViewController alloc] init];
    third.default_title = self.choosed_default_title;
    [self.navigationController pushViewController:third animated:YES];
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
