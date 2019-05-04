//
//  SummarizeBookViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SummarizeBookViewController.h"
#import "SummarizeBookTableViewCell.h"
//添加tips笔记题目
#import "AddQuestionViewController.h"
//考试总结
#import "ExamSummarizeViewController.h"
//学习总结
#import "StudySummarizeViewController.h"
//训练总结
#import "SelectQuestionViewController.h"
//tips总结详情
#import "Tips_AddSummarizeViewController.h"
//训练总结详情
#import "Drill_WriteSummarizeViewController.h"
#import "SummarizeModel.h"
#import "AnswerModel.h"

@interface SummarizeBookViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIButton *type_button;

@end

@implementation SummarizeBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"总结本";
    [self setBack];
    self.view.backgroundColor = SetColor(246, 246, 246, 1);
    
    [self setleftOrRight:@"right" BarButtonItemWithImage:[UIImage imageNamed:@"mine_help"] target:self action:@selector(pushSummarizeHelpView)];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.current_type = 1;
    
    //请求数据
    [self getHttpDataWithType:@"1"];
    
    __weak typeof(self) weakSelf = self;
    NSArray *button_title_array = @[@"tips总结", @"考试总结", @"学习总结", @"训练总结"];
    CGFloat width = (SCREENBOUNDS.width - 40) / 4;
    for (NSInteger index = 0; index < 4; index++) {
        self.type_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.type_button.backgroundColor = WhiteColor;
        self.type_button.titleLabel.font = SetFont(12);
        [self.type_button setTitleColor:ButtonColor forState:UIControlStateNormal];
        [self.type_button setTitle:button_title_array[index] forState:UIControlStateNormal];
        ViewRadius(self.type_button, 5.0);
        if (index == 0) {
            self.type_button.backgroundColor = ButtonColor;
            [self.type_button setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
        self.type_button.tag = index + 100;
        [self.type_button addTarget:self action:@selector(changeBookType:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.type_button];
        [self.type_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view.mas_top).offset(10);
            make.left.equalTo(weakSelf.view.mas_left).offset(5 + (width + 10) * index);
            make.size.mas_equalTo(CGSizeMake(width, 34));
        }];
    }
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[SummarizeBookTableViewCell class] forCellReuseIdentifier:@"summarize"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(54, 0, 0, 0));
    }];
    
    
    self.add_button = [UIButton buttonWithType:UIButtonTypeCustom];
//    add_button.backgroundColor = ButtonColor;
    [self.add_button setImage:[UIImage imageNamed:@"circle_1"] forState:UIControlStateNormal];
    ViewRadius(self.add_button, 30.0);
    [self.add_button addTarget:self action:@selector(addNewSummarize) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.add_button];
    [self.add_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-35);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SummarizeModel *model = self.dataArray[indexPath.row];
    SummarizeBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"summarize"];
    if (self.current_type == 1) {
        cell.content_label.text = model.question_content;
        cell.answer_label_A.text = [NSString stringWithFormat:@"A:%@", ((AnswerModel *)model.question_choice_data[0]).answer_content];
        cell.answer_label_B.text = [NSString stringWithFormat:@"B:%@", ((AnswerModel *)model.question_choice_data[1]).answer_content];
        cell.answer_label_C.text = [NSString stringWithFormat:@"C:%@", ((AnswerModel *)model.question_choice_data[2]).answer_content];
        cell.answer_label_D.text = [NSString stringWithFormat:@"D:%@", ((AnswerModel *)model.question_choice_data[3]).answer_content];
        cell.summarize_label.text = model.content;
        cell.date_label.text = model.creat_time;
    }else if (self.current_type == 2 || self.current_type == 3) {
        cell.content_label.text = model.content;
        cell.answer_label_A.text = @"";
        cell.answer_label_B.text = @"";
        cell.answer_label_C.text = @"";
        cell.answer_label_D.text = @"";
        cell.date_label.text = model.creat_time;
    }else {
        cell.content_label.text = model.question_content;
        cell.answer_label_A.text = @"";
        cell.answer_label_B.text = @"";
        cell.answer_label_C.text = @"";
        cell.answer_label_D.text = @"";
        cell.summarize_label.text = model.content;
        cell.date_label.text = model.creat_time;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.current_type == 2 || self.current_type == 3) {
        return 100.0;
    }
    return 200.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SummarizeModel *model = self.dataArray[indexPath.row];
    switch (self.current_type) {
        case 1:
        {
            Tips_AddSummarizeViewController *tips_detail = [[Tips_AddSummarizeViewController alloc] init];
            tips_detail.tips_id = model.notes_id;
            [self.navigationController pushViewController:tips_detail animated:YES];
        }
            break;
        case 2:
        {
            ExamSummarizeViewController *exam = [[ExamSummarizeViewController alloc] init];
            exam.exam_id = model.notes_id;
            [self.navigationController pushViewController:exam animated:YES];
        }
            break;
        case 3:
        {
            StudySummarizeViewController *study = [[StudySummarizeViewController alloc] init];
            study.study_id = model.notes_id;
            [self.navigationController pushViewController:study animated:YES];
        }
            break;
        case 4:
        {
            Drill_WriteSummarizeViewController *details = [[Drill_WriteSummarizeViewController alloc] init];
            details.Drill_details_id = model.notes_id;
            details.Drill_question_id = model.question_id;
            [self.navigationController pushViewController:details animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)addNewSummarize {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"添加总结" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"tips总结" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AddQuestionViewController *add = [[AddQuestionViewController alloc] init];
        add.isNewCreat = YES;
        [self.navigationController pushViewController:add animated:YES];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"考试总结" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ExamSummarizeViewController *exam = [[ExamSummarizeViewController alloc] init];
        [self.navigationController pushViewController:exam animated:YES];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"学习总结" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        StudySummarizeViewController *study = [[StudySummarizeViewController alloc] init];
        [self.navigationController pushViewController:study animated:YES];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"训练总结" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SelectQuestionViewController *select = [[SelectQuestionViewController alloc] init];
        [self.navigationController pushViewController:select animated:YES];
    }];
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:action5];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//改变总结本的状态
- (void)changeBookType:(UIButton *)sender {
    for (UIButton *button in self.view.subviews) {
        if (![button isKindOfClass:[UIButton class]]) {
            return;
        }
        if (button.tag == sender.tag) {
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            button.backgroundColor = ButtonColor;
            switch (sender.tag - 100) {
                case 0:
                {
                    [self getHttpDataWithType:@"1"];
                    self.current_type = 1;
                }
                    break;
                case 1:
                {
                    [self getHttpDataWithType:@"2"];
                    self.current_type = 2;
                }
                    break;
                case 2:
                {
                    [self getHttpDataWithType:@"3"];
                    self.current_type = 3;
                }
                    break;
                case 3:
                {
                    [self getHttpDataWithType:@"4"];
                    self.current_type = 4;
                }
                    break;
                    
                default:
                    break;
            }
        }else {
            [button setTitleColor:ButtonColor forState:UIControlStateNormal];
            button.backgroundColor = WhiteColor;
        }
    }
}

- (void)getHttpDataWithType:(NSString *)type {
    [self.dataArray removeAllObjects];
    NSDictionary *parma = @{
                            @"page_number":@"1",
                            @"page_size":@"20",
                            @"type_":type,
                            @"is_sorting_":@"0"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_note_total" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"responseObject == %@", responseObject);
        if ([type integerValue] == 1) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                SummarizeModel *sumModel = [[SummarizeModel alloc] init];
                sumModel.notes_id = dic[@"id_"];
                sumModel.content = dic[@"content_"];
                sumModel.creat_time = dic[@"create_time_"];
                sumModel.question_content = dic[@"question_choice_data"][0][@"title_"];
                NSMutableArray *answer_array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *answerDic in dic[@"question_choice_data"][0][@"option_result_"]) {
                    AnswerModel *model = [[AnswerModel alloc] init];
//                    model.answer_id = answerDic[@"id_"];
//                    model.answer_content_image = @"";
                    model.isCorrect = [NSString stringWithFormat:@"%ld", [answerDic[@"answer_"] integerValue]];
                    model.answer_content = answerDic[@"content_"];
                    [answer_array addObject:model];
                }
                sumModel.question_choice_data = [answer_array copy];
                [weakSelf.dataArray addObject:sumModel];
            }
            [weakSelf.tableview reloadData];
        }else if ([type integerValue] == 2 || [type integerValue] == 3) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                SummarizeModel *sumModel = [[SummarizeModel alloc] init];
                sumModel.notes_id = dic[@"id_"];
                sumModel.content = dic[@"title_"];
                sumModel.creat_time = dic[@"create_time_"];
//                sumModel.question_id = dic[@"question_essay_data"][@"id_"];
//                sumModel.question_content = dic[@"question_essay_data"][@"title_"];
//                sumModel.question_require_list = dic[@"question_essay_data"][@"content_list_"];
                [weakSelf.dataArray addObject:sumModel];
            }
            [weakSelf.tableview reloadData];
        }else {
            for (NSDictionary *dic in responseObject[@"data"]) {
                SummarizeModel *sumModel = [[SummarizeModel alloc] init];
                sumModel.notes_id = dic[@"id_"];
                sumModel.content = dic[@"content_"];
                sumModel.creat_time = dic[@"create_time_"];
                sumModel.question_id = dic[@"question_essay_data"][@"id_"];
                sumModel.question_content = dic[@"question_essay_data"][@"title_"];
                sumModel.question_require_list = dic[@"question_essay_data"][@"content_list_"];
                [weakSelf.dataArray addObject:sumModel];
            }
            [weakSelf.tableview reloadData];
        }
        
    } FailureBlock:^(id error) {
        NSLog(@"error == %@", error);
    }];
}

/** 跳转到帮助页面 */
- (void)pushSummarizeHelpView {
    
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
