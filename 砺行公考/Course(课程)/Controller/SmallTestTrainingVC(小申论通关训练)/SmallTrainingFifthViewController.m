//
//  SmallTrainingFifthViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SmallTrainingFifthViewController.h"
#import "ShowAndWriteTableViewCell.h"
#import "SmallTrainingFirstViewController.h"
#import "EssayTests_HomeViewController.h"

@interface SmallTrainingFifthViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSString *tips_string;

@end

@implementation SmallTrainingFifthViewController

- (void)nextOrFinishAction {
    //current_smallTest_index  当前处于第几个小申论
    //smallTest_question_count  每个小申论下有几题
    //current_question_index  当前正在做第几题
    //smallTestNumbers  试卷中有几个小申论
    
    NSInteger current_question_index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"current_question_index"] integerValue];
    NSInteger smallTest_question_count = [[[NSUserDefaults standardUserDefaults] objectForKey:@"smallTest_question_count"] integerValue];
    NSInteger current_smallTest_index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"current_smallTest_index"] integerValue];
    NSInteger smallTestNumbers = [[[NSUserDefaults standardUserDefaults] objectForKey:@"smallTestNumbers"] integerValue];
    
    if (current_question_index == smallTest_question_count - 1 && current_smallTest_index == smallTestNumbers) {
        //直接返回
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[EssayTests_HomeViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else {
        if (current_question_index == smallTest_question_count - 1 && current_smallTest_index < smallTestNumbers) {
            //请求下一个小申论
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SmallTrainingFirstViewController class]]) {
                    SmallTrainingFirstViewController *first = (SmallTrainingFirstViewController *)vc;
                    [first getDataWithOrder:[NSString stringWithFormat:@"%ld", current_smallTest_index+1]];
                    [self.navigationController popToViewController:first animated:YES];
                    return;
                }
            }
        }else {
            //请求下一个小题
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SmallTrainingFirstViewController class]]) {
                    SmallTrainingFirstViewController *first = (SmallTrainingFirstViewController *)vc;
                    [first getCurrentQuestionData:current_question_index++ withDataArray:@[]];
                    [self.navigationController popToViewController:first animated:YES];
                }
            }
        }
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    //current_smallTest_index  当前处于第几个小申论
    //smallTest_question_count  每个小申论下有几题
    //current_question_index  当前正在做第几题
    //smallTestNumbers  试卷中有几个小申论
    
    NSInteger current_question_index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"current_question_index"] integerValue];
    NSInteger smallTest_question_count = [[[NSUserDefaults standardUserDefaults] objectForKey:@"smallTest_question_count"] integerValue];
    NSInteger current_smallTest_index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"current_smallTest_index"] integerValue];
    NSInteger smallTestNumbers = [[[NSUserDefaults standardUserDefaults] objectForKey:@"smallTestNumbers"] integerValue];
    
    if (current_question_index == smallTest_question_count - 1 && current_smallTest_index == smallTestNumbers) {
        [self setleftOrRight:@"right" BarButtonItemWithTitle:@"完成" target:self action:@selector(nextOrFinishAction)];
    }else {
        if (current_question_index == smallTest_question_count - 1 && current_smallTest_index < smallTestNumbers) {
            //请求下一个小申论
            [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一题" target:self action:@selector(nextOrFinishAction)];
        }else {
            //请求下一个小题
            [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一题" target:self action:@selector(nextOrFinishAction)];
        }
    }
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowAndWriteTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowAndWriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textview.tag = indexPath.section;
    cell.textview.delegate = self;
    if (indexPath.section == 0) {
        cell.textview.editable = NO;
        cell.textview.text = self.my_answer;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self calculateRowHeight:self.my_answer fontSize:14 withWidth:SCREENBOUNDS.width - 80.0] + 80.0;
    }
    return 230.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 70.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    [self setHeader_view:header_view withSection:section];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    if (section == 1) {
        [self setFooterView:footer_view];
    }
    return footer_view;
}

- (void)setHeader_view:(UIView *)header_view withSection:(NSInteger)section {
    header_view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @[@"我的答案",@"添加Tips总结"][section];
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
}

- (void)setFooterView:(UIView *)footer_view {
    footer_view.backgroundColor = WhiteColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = ButtonColor;
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    ViewRadius(button, 25.0);
    [footer_view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer_view.mas_left).offset(90);
        make.right.equalTo(footer_view.mas_right).offset(-90);
        make.bottom.equalTo(footer_view.mas_bottom).offset(-10);
        make.height.mas_equalTo(50.0);
    }];
    [button addTarget:self action:@selector(submitTipsToBook) forControlEvents:UIControlEventTouchUpInside];
}

/**
 提交Tips总结
 */
- (void)submitTipsToBook {
    [self.view endEditing:YES];
    
    if (!self.tips_string) {
        [self showHUDWithTitle:@"请输入总结内容"];
        return;
    }
    
    NSString *question_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_question_ID"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[question_id] options:kNilOptions error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parma = @{
                            @"content_":self.tips_string,
                            @"question_id_":jsonString,
                            @"type_":@"4",
                            };
    NSLog(@"parma == %@", parma);
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_tips_total" Dic:parma imageArray:@[] SuccessBlock:^(id responseObject) {
        NSLog(@"save to book === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"保存到总结本成功");
            [weakSelf showHUDWithTitle:@"保存成功"];
        }else {
            NSLog(@"保存到总结本失败");
        }
    } FailureBlock:^(id error) {
        NSLog(@"save to book error === %@", error);
        NSLog(@"保存到总结本失败");
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.tips_string = textView.text;
}

@end
