//
//  AddQuestionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "SummarizeBookTableViewCell.h"
#import "Tips_AddSummarizeViewController.h"
#import "QuestionModel.h"
#import "AnswerModel.h"

@interface AddQuestionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AddQuestionViewController

- (void)getHttpData {
    NSDictionary *parma = @{
                            @"page_number":@"1",
                            @"page_size":@"20"
                            };
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_all_choice_question" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"all linetest data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *dataMutable = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *data in responseObject[@"data"]) {
                QuestionModel *model = [[QuestionModel alloc] init];
                model.question_id = data[@"id_"];
                model.question_content = data[@"content_"];
                model.question_type = [NSString stringWithFormat:@"%ld", [data[@"choice_type_"] integerValue]];
                //题目图片
                model.question_picture_array = data[@"question_choice_picture_result"];
                
                NSMutableArray *answer_arr = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *answerDic in data[@"tp_options_result"]) {
                    AnswerModel *answerModel = [[AnswerModel alloc] init];
                    answerModel.answer_content = answerDic[@"content_"];
                    answerModel.answer_content_image = answerDic[@"question_picture_id_"];
                    answerModel.isCorrect = answerDic[@"answer_"];
                    [answer_arr addObject:answerModel];
                }
                model.answer_array = [answer_arr copy];
                [dataMutable addObject:model];
            }
            weakSelf.dataArray = [dataMutable copy];
            [weakSelf.tableview reloadData];
            [weakSelf hidden];
        }
//        NSMutableArray *dataMutable = [NSMutableArray arrayWithCapacity:1];
//        for (NSArray *data in responseObject[@"data"][@"question_data"]) {
//            for (NSDictionary *question_data in data) {
//                QuestionModel *model = [[QuestionModel alloc] init];
//                model.question_id = question_data[@"id_"];                          //ID
//                model.question_type = question_data[@"choice_type_"];           //单选多选
//                model.question_content = question_data[@"content_"];                //题干
//                model.question_picture_array = question_data[@"question_choice_picture_result"];
//                //答案数据转Model
//                NSMutableArray *answer_array = [NSMutableArray arrayWithCapacity:1];
//                for (NSDictionary *answer_data in question_data[@"tp_options_result"]) {
//                    AnswerModel *answer_model = [[AnswerModel alloc] init];
//                    answer_model.answer_id = answer_data[@"id_"];
//                    answer_model.answer_content_image = answer_data[@"question_picture_id_"];
//                    answer_model.answer_content = [[NSMutableAttributedString alloc] initWithString:answer_data[@"content_"]];
//                    [answer_array addObject:answer_model];
//                }
//                model.answer_array = [answer_array copy];
//                [dataMutable addObject:model];
//            }
//        }
//        weakSelf.dataArray = [dataMutable copy];
//        NSLog(@"dataArray === %@", weakSelf.dataArray);
//        [weakSelf.tableview reloadData];
    } FailureBlock:^(id error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    //初始化
    self.selected_array = [NSMutableArray arrayWithCapacity:1];
    
    //获取数据
    [self getHttpData];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[SummarizeBookTableViewCell class] forCellReuseIdentifier:@"summarize"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.dataArray.count == 0) {
//        NSLog(@"11111111111");
//        return nil;
//    }
    QuestionModel *model = self.dataArray[indexPath.row];
    SummarizeBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"summarize"];
    cell.isHiddenSummarizeLabel = YES;
    cell.isSupportSelect = YES;
    cell.content_label.text = model.question_content;
    cell.answer_label_A.text = [NSString stringWithFormat:@"A:%@", ((AnswerModel *)model.answer_array[0]).answer_content];
    cell.answer_label_B.text = [NSString stringWithFormat:@"B:%@", ((AnswerModel *)model.answer_array[1]).answer_content];
    cell.answer_label_C.text = [NSString stringWithFormat:@"C:%@", ((AnswerModel *)model.answer_array[2]).answer_content];
    cell.answer_label_D.text = [NSString stringWithFormat:@"D:%@", ((AnswerModel *)model.answer_array[3]).answer_content];
    if ([self.selected_array containsObject:model]) {
        cell.select_image.image = [UIImage imageNamed:@"select_yes"];
    }else {
        cell.select_image.image = [UIImage imageNamed:@"select_no"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionModel *model = self.dataArray[indexPath.row];
    SummarizeBookTableViewCell *cell = (SummarizeBookTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([self.selected_array containsObject:model]) {
        [self.selected_array removeObject:model];
        cell.select_image.image = [UIImage imageNamed:@"select_no"];
    }else {
        [self.selected_array addObject:model];
        cell.select_image.image = [UIImage imageNamed:@"select_yes"];
    }
    [self.tableview reloadData];
}


//右上角完成方法
- (void)finishAction {
    if (self.selected_array.count == 0) {
        [self showHUDWithTitle:@"请选择题目"];
        return;
    }
    
    if (self.isNewCreat) {
        Tips_AddSummarizeViewController *tips_add = [[Tips_AddSummarizeViewController alloc] init];
        tips_add.tableview_data_array = self.selected_array;
        //    __weak typeof(self) weakSelf = self;
        //    tips_add.AddMoreQuestionBlock = ^(NSArray * _Nonnull array) {
        //        weakSelf.selected_array = [array mutableCopy];
        //        [weakSelf.tableview reloadData];
        //    };
        [self.navigationController pushViewController:tips_add animated:YES];
    }else {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[Tips_AddSummarizeViewController class]]) {
                Tips_AddSummarizeViewController *tips = (Tips_AddSummarizeViewController *)vc;
                tips.tableview_data_array = self.selected_array;
                [self.navigationController popToViewController:tips animated:YES];
            }
        }
    }
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
