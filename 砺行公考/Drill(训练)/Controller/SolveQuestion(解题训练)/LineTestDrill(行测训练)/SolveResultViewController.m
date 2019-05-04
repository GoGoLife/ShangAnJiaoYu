//
//  SolveResultViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SolveResultViewController.h"
//答题卡View
#import "ChainReactionView.h"
#import "QuestionAnalysisViewController.h"
#import "CustomAnswerModel.h"
//解题训练页面  用于返回
#import "SolveQuestionViewController.h"
//错题本页面
#import "ErrorQuestionBookViewController.h"

@interface SolveResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

//存储正确答案和错误答案数组    用于展示正确  错误答案
@property (nonatomic, strong) NSArray *YESAndNO_array;

//全部解析数组
@property (nonatomic, strong) NSArray *all_analysis_array;

//错题解析数组
@property (nonatomic, strong) NSArray *error_analysis_array;

@property (nonatomic, strong) NSString *DoQuestionTime;

@end

@implementation SolveResultViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setleftOrRight:@"left" BarButtonItemWithImage:[UIImage imageNamed:@"back"] target:self action:@selector(backAction)];
    
    
    NSDate *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"StartTime"];
    NSDate *endTime = [NSDate date];
    NSDateComponents *components = [KPDateTool dateDiffFromDate:startTime toDate:endTime];
    
    self.DoQuestionTime = [NSString stringWithFormat:@"%02ld:%02ld", components.minute, components.second];
    
    [self setViewUI];
    
    
    NSMutableArray *all_analysis_mutable = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *error_analysis_mutable = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *correct_analysis_mutable = [NSMutableArray arrayWithCapacity:1];
    for (CustomAnswerModel *model in self.result_array) {
        [all_analysis_mutable addObject:model.question_id];
        if (!model.isCorrect) {
            //修改过
            NSDictionary *update_dic = @{@"question_id":model.question_id,@"material_id":model.question_materials_id_array};
            [error_analysis_mutable addObject:update_dic];
        }else {
            NSDictionary *update_dic = @{@"question_id":model.question_id,@"material_id":model.question_materials_id_array};
            [correct_analysis_mutable addObject:update_dic];
        }
    }
    self.all_analysis_array = [all_analysis_mutable copy];
    self.error_analysis_array = [error_analysis_mutable copy];
    
    NSLog(@"error question data == %@", self.error_analysis_array);
    //将错题添加到后台   保存至错题本
    if (self.error_analysis_array.count > 0 || correct_analysis_mutable.count > 0) {
        if (self.DoExerciseType == -1) {
            //从试卷添加错题到错题本
            NSDictionary *parma = @{@"question_list_":self.error_analysis_array};
            [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_pitfalls_question" Dic:parma SuccessBlock:^(id responseObject) {
                if ([responseObject[@"state"] integerValue] == 1) {
                    NSLog(@"新增错题成功");
                }else {
                    NSLog(@"新增错题失败");
                }
            } FailureBlock:^(id error) {
                NSLog(@"新增错题失败");
            }];
        }else {
            //从错题本添加错题到别的错题本
            //错误数据
            NSMutableArray *two_more_error_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in self.error_analysis_array) {
                [two_more_error_array addObject:dic[@"question_id"]];
            }
            
            //正确数据
            NSMutableArray *two_more_correct_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in correct_analysis_mutable) {
                [two_more_correct_array addObject:dic[@"question_id"]];
            }
            
            if (self.DoExerciseType < 3) {
                self.DoExerciseType++;
            }else {
                self.DoExerciseType = 3;
            }
            
            NSDictionary *param = @{@"id_":two_more_error_array, @"type_":[NSString stringWithFormat:@"%ld", self.DoExerciseType]};
            [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/update_pitfalls_type" Dic:param SuccessBlock:^(id responseObject) {
                if ([responseObject[@"state"] integerValue] == 1) {
                    NSLog(@"再错  或 多次错  上传成功！！！");
                }else {
                    NSLog(@"再错  或 多次错  上传失败！！！");
                }
            } FailureBlock:^(id error) {
                
            }];
            
            //将正确的放入终结本
            NSDictionary *correct_param = @{@"id_":two_more_correct_array, @"type_":[NSString stringWithFormat:@"%d", 4]};
            [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/update_pitfalls_type" Dic:correct_param SuccessBlock:^(id responseObject) {
                if ([responseObject[@"state"] integerValue] == 1) {
                    NSLog(@"作对的题目  上传成功！！！");
                }else {
                    NSLog(@"作对的题目  上传失败！！！");
                }
            } FailureBlock:^(id error) {
                
            }];
            
        }
        
    }
    
}

- (void)setViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark ---- tableview   delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageV = [[UIImageView alloc] init];
    ViewRadius(imageV, 5.0);
    imageV.backgroundColor = [UIColor greenColor];
    [cell.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    return cell;
}

#pragma mark --- tableview   datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return ANSWER_RESULT_HEIGHT + 165;
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    if (section == 0) {
        [self setFirstHeaderViewUI:header_view];
    }else {
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(14);
        label.textColor = DetailTextColor;
        label.text = @"根据您的训练结果,我们为您推荐:";
        [header_view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(10, 20, 10, 10));
        }];
    }
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = DetailTextColor;
    return footer_view;
}


#pragma mark ---- other
- (void)setFirstHeaderViewUI:(UIView *)back_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = [NSString stringWithFormat:@"答题时间：%@", self.DoQuestionTime];
    [back_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(10);
        make.centerX.equalTo(back_view.mas_centerX);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(14);
    label1.textColor = SetColor(117, 117, 117, 1);
    label1.text = @"学霸就是不一样";
    [back_view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.centerX.equalTo(back_view.mas_centerX);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = SetFont(14);
    label2.textColor = SetColor(117, 117, 117, 1);
    label2.text = @"答题速度超过80%的同学哦~~";
    [back_view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.centerX.equalTo(back_view.mas_centerX);
    }];
    
    ChainReactionView *react_view = [[ChainReactionView alloc] initWithFrame:CGRectZero withNameArray:self.nameArray];
    //标记该页面显示的是正确答案和错误答案的集合
    react_view.isShowYESAndNO = YES;
    react_view.data_array = self.result_array;
    [back_view addSubview:react_view];
    [react_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(0);
        make.left.equalTo(back_view.mas_left);
        make.right.equalTo(back_view.mas_right);
        make.height.mas_equalTo(ANSWER_RESULT_HEIGHT);
    }];
    
    //查看错题解析
    UIButton *look_error = [UIButton buttonWithType:UIButtonTypeCustom];
    [look_error setTitle:@"查看错题解析" forState:UIControlStateNormal];
    [look_error setTitleColor:WhiteColor forState:UIControlStateNormal];
    look_error.backgroundColor = ButtonColor;
    ViewRadius(look_error, 25.0);
    [look_error addTarget:self action:@selector(look_error_analysis) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:look_error];
    [look_error mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(react_view.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake((SCREENBOUNDS.width - 55) / 2, 50));
    }];
    
    //查看全部解析
    UIButton *look_all = [UIButton buttonWithType:UIButtonTypeCustom];
    [look_all setTitle:@"查看全部解析" forState:UIControlStateNormal];
    [look_all setTitleColor:ButtonColor forState:UIControlStateNormal];
    [look_all setBackgroundColor:WhiteColor];
    ViewBorderRadius(look_all, 25.0, 1.0, ButtonColor);
    [look_all addTarget:self action:@selector(look_all_action) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:look_all];
    [look_all mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(look_error.mas_top);
        make.left.equalTo(look_error.mas_right).offset(15);
        make.size.equalTo(look_error);
    }];
}

//查看错题解析
- (void)look_error_analysis {
    NSMutableArray *error_data = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in self.error_analysis_array) {
        [error_data addObject:dic[@"question_id"]];
    }
    
    QuestionAnalysisViewController *analysis = [[QuestionAnalysisViewController alloc] init];
    analysis.analysis_array = [error_data copy];
    [self.navigationController pushViewController:analysis animated:YES];
}

//查看全部解析
- (void)look_all_action {
    QuestionAnalysisViewController *analysis = [[QuestionAnalysisViewController alloc] init];
    analysis.analysis_array = self.all_analysis_array;
    analysis.isShowNextButton = YES;
    [self.navigationController pushViewController:analysis animated:YES];
}

//返回首页
- (void)backAction {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[SolveQuestionViewController class]]) {
            SolveQuestionViewController *vc = (SolveQuestionViewController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
        }
        
        if ([controller isKindOfClass:[ErrorQuestionBookViewController class]]) {
            ErrorQuestionBookViewController *vc = (ErrorQuestionBookViewController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////转换数据格式   转成接口需要的格式数据    获取试卷解答结果
//- (void)transfromDataFormat {
//    NSMutableArray *data_array = [NSMutableArray arrayWithCapacity:1];
//    for (CustomAnswerModel *model in self.result_array) {
//        [data_array addObject:@{@"id_" : model.question_id,@"option_id_":model.option_id_array}];
//    }
//
//    NSDictionary *parma = @{@"tp_information_id_":self.information_id,
//                            @"answer_list_" : [data_array copy]
//                            };
//    __weak typeof(self) weakSelf = self;
//    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_choice" Dic:parma SuccessBlock:^(id responseObject) {
//        NSLog(@"response === %@", responseObject);
//        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
//        NSMutableArray *all_analysis_array = [NSMutableArray arrayWithCapacity:1];
//        NSMutableArray *error_analysis_array = [NSMutableArray arrayWithCapacity:1];
//        for (NSDictionary *data in (NSArray *)responseObject[@"data"]) {
//            //答案  对错
//            [mutableArr addObject:[NSString stringWithFormat:@"%ld", [data[@"answer_"] integerValue]]];
//            //全部解析数组  数据（题目ID）
//            [all_analysis_array addObject:[NSString stringWithFormat:@"%@", data[@"id_"]]];
//            if (![data[@"answer_"] integerValue]) {
//                [error_analysis_array addObject:[NSString stringWithFormat:@"%@", data[@"id_"]]];
//            }
//        }
//        weakSelf.YESAndNO_array = [mutableArr copy];
//        weakSelf.error_analysis_array = [error_analysis_array copy];
//        weakSelf.all_analysis_array = [all_analysis_array copy];
//        [weakSelf.tableview reloadData];
//    } FailureBlock:^(id error) {
//        NSLog(@"response  error === %@", error);
//    }];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
