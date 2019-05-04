//
//  BigTrainingEleventhViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigTrainingEleventhViewController.h"
#import "ShowAndWriteTableViewCell.h"
#import "EssayTests_HomeViewController.h"

@interface BigTrainingEleventhViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *defaultAnswer_array;

@end

@implementation BigTrainingEleventhViewController

- (void)getDefaultAnswer {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"exam_id_":[[NSUserDefaults standardUserDefaults] objectForKey:@"bigTestTrainingExamID"],
                            @"order_":@"1"};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_idol" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.defaultAnswer_array = responseObject[@"data"][@"parsing_list_"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"第五步：完整稿写作";
    [self setBack];
    
    CGFloat height_index = (SCREENBOUNDS.height - 64) / 2;
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowAndWriteTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(height_index);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DetailTextColor;
    label.font = SetFont(14);
    label.text = @"完整稿写作";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    UITextView *textview = [[UITextView alloc] init];
    ViewRadius(textview, 8.0);
    textview.font = SetFont(14);
    textview.textColor = SetColor(74, 74, 74, 1);
    textview.backgroundColor = SetColor(246, 246, 246, 1);
    textview.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-90);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = WhiteColor;
    [button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [button setTitle:@"申请人工批改1000分" forState:UIControlStateNormal];
    ViewBorderRadius(button, 25.0, 1.0, ButtonColor);
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(90);
        make.right.equalTo(weakSelf.view.mas_right).offset(-90);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
        make.height.mas_equalTo(50.0);
    }];
    [button addTarget:self action:@selector(touchCorrectAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self getDefaultAnswer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.defaultAnswer_array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowAndWriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textview.editable = NO;
    cell.textview.scrollEnabled = NO;
    cell.textview.text = self.defaultAnswer_array[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = self.defaultAnswer_array[indexPath.section];
    return [self calculateRowHeight:string fontSize:14 withWidth:SCREENBOUNDS.width - 80] + 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
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
    header_view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DetailTextColor;
    label.font = SetFont(14);
    label.text = [NSString stringWithFormat:@"范文%ld", section + 1];
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
}

/**
 申请人工批改
 */
- (void)touchCorrectAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入批改标题" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入批改标题";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //填写的标题
        NSString *string = alert.textFields.firstObject.text;
        [weakSelf submitCorrect:string];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)submitCorrect:(NSString *)title {
    NSDictionary *parma = @{@"exam_id_":[[NSUserDefaults standardUserDefaults] objectForKey:@"BigEssayQuestionID"],
                            @"title_":title};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/insert_correcting" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf showHUDWithTitle:@"提交成功！"];
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[EssayTests_HomeViewController class]]) {
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                }
            }
        }else {
            [weakSelf showHUDWithTitle:@"提交失败！"];
        }
    } FailureBlock:^(id error) {
        [weakSelf showHUDWithTitle:@"提交失败！"];
    }];
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
