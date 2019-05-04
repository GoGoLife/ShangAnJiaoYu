//
//  CompareStudyViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CompareStudyViewController.h"
#import "First_AnalyzeQuestionViewController.h"
#import "EssayTests_HomeViewController.h"

@interface CompareStudyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

//系统答案
@property (nonatomic, strong) NSString *default_answer_string;

@property (nonatomic, strong) First_AnalyzeQuestionViewController *first;

@property (nonatomic, strong) UITextView *text_view;

@end

@implementation CompareStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.default_answer_string = [[NSUserDefaults standardUserDefaults] objectForKey:Small_EssayTests_Current_Question_Answer];
    
    [self setBack];
    
    
    NSInteger index = [[[NSUserDefaults standardUserDefaults] objectForKey:Small_EssayTests_All_Numbers] integerValue];
    NSInteger current_index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"current_index"] integerValue];
    if (current_index < index - 1) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一题" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
        self.navigationItem.rightBarButtonItem = right;
    }else {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
        self.navigationItem.rightBarButtonItem = right;
    }
    
    [self creatViewUI];
}

StringHeight()
- (void)creatViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = 10.0;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height1 = [self calculateRowHeight:self.my_answer_string fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    CGFloat height = [self calculateRowHeight:self.default_answer_string fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    return height + height1 + 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 350;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    [self setHeader_view:header_view];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = WhiteColor;
    [self setFooter_view:footer_view];
    return footer_view;
}


- (void)setHeader_view:(UIView *)header_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"我的答案";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    UILabel *my_answer_label = [[UILabel alloc] init];
    my_answer_label.font = SetFont(16);
    my_answer_label.textColor = SetColor(74, 74, 74, 1);
    my_answer_label.numberOfLines = 0;
    my_answer_label.text = self.my_answer_string;
    [header_view addSubview:my_answer_label];
    [my_answer_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(header_view.mas_right).offset(-20);
    }];
    
    UILabel *default_label = [[UILabel alloc] init];
    default_label.font = SetFont(14);
    default_label.textColor = DetailTextColor;
    default_label.text = @"参考答案";
    [header_view addSubview:default_label];
    [default_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(my_answer_label.mas_bottom).offset(30);
        make.left.equalTo(my_answer_label.mas_left);
    }];
    
    UILabel *default_answer_label = [[UILabel alloc] init];
    default_answer_label.font = SetFont(16);
    default_answer_label.textColor = SetColor(74, 74, 74, 1);
    default_answer_label.numberOfLines = 0;
    default_answer_label.text = self.default_answer_string;
    [header_view addSubview:default_answer_label];
    [default_answer_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(default_label.mas_bottom).offset(10);
        make.left.equalTo(my_answer_label.mas_left);
        make.right.equalTo(my_answer_label.mas_right);
    }];
}

- (void)setFooter_view:(UIView *)footer_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"总结提醒栏（将保存至您的 总结本-申论总结 中）";
    [footer_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer_view.mas_top).offset(10);
        make.left.equalTo(footer_view.mas_left).offset(20);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = DetailTextColor;
    [footer_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(15);
        make.left.equalTo(footer_view.mas_left);
        make.right.equalTo(footer_view.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.text_view = [[UITextView alloc] init];
    self.text_view.font = SetFont(16);
    self.text_view.textColor = SetColor(74, 74, 74, 1);
    self.text_view.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(self.text_view, 8.0);
    [footer_view addSubview:self.text_view];
    [self.text_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(15);
        make.left.equalTo(footer_view.mas_left).offset(20);
        make.right.equalTo(footer_view.mas_right).offset(-20);
        make.height.mas_equalTo(180);
    }];
    
    UILabel *number = [[UILabel alloc] init];
    number.font = SetFont(12);
    number.textColor = DetailTextColor;
    number.text = @"0/240";
    [footer_view addSubview:number];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.text_view.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.text_view.mas_right);
    }];
    
    CGFloat button_width = (SCREENBOUNDS.width - 40 - 10) / 3;
    //申请人工批改
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = SetFont(18);
    [button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [button setTitle:@"申请人工批改1000分" forState:UIControlStateNormal];
    ViewBorderRadius(button, 25.0, 1.0, ButtonColor);
    [footer_view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(number.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.text_view.mas_left);
        make.size.mas_equalTo(CGSizeMake(button_width * 2, 50.0));
    }];
    
    //提交并保存
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = ButtonColor;
    button1.titleLabel.font = SetFont(18);
    [button1 setTitleColor:WhiteColor forState:UIControlStateNormal];
    ViewRadius(button1, 25.0);
    [button1 setTitle:@"提交并保存" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(submitAndSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [footer_view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(number.mas_bottom).offset(10);
        make.left.equalTo(button.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(button_width, 50.0));
    }];
}

//提交并保存
- (void)submitAndSaveAction {
    //提交我的答案
    NSString *small_essayTest_id = [[NSUserDefaults standardUserDefaults] objectForKey:Small_EssayTests_Current_Question_ID];
    NSDictionary *parma = @{
                            @"id_":small_essayTest_id,
                            @"content_":self.my_answer_string};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/small_essay_user_answer" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"小申论答案提交完成");
            [weakSelf showHUDWithTitle:@"提交完成！！"];
            //删除采点信息
            [weakSelf deleteUserMaterials];
        }else {
            [weakSelf showHUDWithTitle:@"提交失败！！"];
        }
    } FailureBlock:^(id error) {
        [weakSelf showHUDWithTitle:@"提交失败！！"];
    }];
    
    //将填写的总结内容保存到总结本中
    if (![self.text_view.text isEqualToString:@""]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[small_essayTest_id] options:kNilOptions error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *parma = @{
                                @"content_":self.text_view.text,
                                @"question_id_":jsonString,
                                @"type_":@"4",
                                };
        NSLog(@"parma == %@", parma);
        [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_tips_total" Dic:parma imageArray:@[] SuccessBlock:^(id responseObject) {
            NSLog(@"save to book === %@", responseObject);
            if ([responseObject[@"state"] integerValue] == 1) {
                NSLog(@"保存到总结本成功");
            }else {
                NSLog(@"保存到总结本失败");
            }
        } FailureBlock:^(id error) {
            NSLog(@"save to book error === %@", error);
            NSLog(@"保存到总结本失败");
        }];
    }
}

//下一题
- (void)nextAction {
//    NSInteger index = [[[NSUserDefaults standardUserDefaults] objectForKey:Small_EssayTests_All_Numbers] integerValue];
    //返回到指定界面
    //该方法返回到小申论审题界面
    //执行下一题答题开始操作
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[First_AnalyzeQuestionViewController class]]) {
            self.first =(First_AnalyzeQuestionViewController *)controller;
            self.first.question_index += 1;
            self.first.isShowAnalysis = NO;
            [self.first getCurrentQuestionData:self.first.question_index];
            [self.navigationController popToViewController:self.first animated:YES];
        }
    }
}

/**
 完成
 */
- (void)finishAction {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[EssayTests_HomeViewController class]]) {
            EssayTests_HomeViewController *vc = (EssayTests_HomeViewController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}


/**
 删除用户做题时间的所有的采点信息
 */
- (void)deleteUserMaterials {
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_user_question_catch" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"材料采点删除成功");
        }else {
            NSLog(@"材料采点删除失败");
        }
    } FailureBlock:^(id error) {
        NSLog(@"材料采点删除失败");
    }];
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
