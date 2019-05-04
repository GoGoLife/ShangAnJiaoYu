//
//  SmallTrainingFirstViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SmallTrainingFirstViewController.h"
#import "OptionTableViewCell.h"
#import "SmallTrainingSecondViewController.h"
#import "TestTrainingFirstModel.h"

@interface SmallTrainingFirstViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) TestTrainingFirstModel *model;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) BOOL isShowParsing;

@property (nonatomic, strong) NSIndexPath *selected_indexPath;

@end

@implementation SmallTrainingFirstViewController

- (void)getDataWithOrder:(NSString *)order {
    //当前处于第几个小申论
    [[NSUserDefaults standardUserDefaults] setObject:@([order integerValue]) forKey:@"current_smallTest_index"];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"exam_id_":self.exam_id,@"order_":order};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_first_step" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"small test data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dataDic in responseObject[@"data"]) {
                TestTrainingFirstModel *model = [[TestTrainingFirstModel alloc] init];
                model.question_id = dataDic[@"require_id_"];
                model.question_title = dataDic[@"title_"];
                model.question_require = dataDic[@"content_list_"];
                model.judge_title = dataDic[@"judge"][0][@"title"];
                model.judge_option_list = dataDic[@"judge"][0][@"optionList"];
                model.judge_parsing = dataDic[@"judge"][0][@"parsing"];
                [dataArray addObject:model];
            }
            weakSelf.dataArr = [dataArray copy];
            //每个小申论下的题目数量
            [[NSUserDefaults standardUserDefaults] setObject:@(dataArray.count) forKey:@"smallTest_question_count"];
            [weakSelf getCurrentQuestionData:0 withDataArray:[dataArray copy]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)getCurrentQuestionData:(NSInteger)index withDataArray:(NSArray *)array {
    self.model = self.dataArr[index];
    //当前做的第几题
    [[NSUserDefaults standardUserDefaults] setObject:@(index) forKey:@"current_question_index"];
    //当前小题的ID
    [[NSUserDefaults standardUserDefaults] setObject:self.model.question_id forKey:@"current_question_ID"];
    
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"第一步：审题判断";
    [self setBack];
    self.current_question = 0;
    
    //试卷ID
    [[NSUserDefaults standardUserDefaults] setObject:self.exam_id forKey:@"smallTestTrainingID"];
    //试卷里面的小申论题目数量
    [[NSUserDefaults standardUserDefaults] setObject:@(self.topic_count) forKey:@"smallTestNumbers"];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushSecondVC)];
    
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[OptionTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getDataWithOrder:@"1"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.judge_option_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.leftLabel.text = @[@"A",@"B",@"C",@"D"][indexPath.row];
    cell.contentLabel.text = self.model.judge_option_list[indexPath.row][@"content"];
    if (self.isShowParsing) {
        NSInteger answer = [self.model.judge_option_list[self.selected_indexPath.row][@"answer"] integerValue];
        //接口返回的答案
        NSInteger defaultAnswer = [self.model.judge_option_list[indexPath.row][@"answer"] integerValue];
        if (defaultAnswer == 1) {
            cell.leftLabel.layer.borderColor = SetColor(48, 132, 252, 1).CGColor;
            cell.leftLabel.textColor = SetColor(48, 132, 252, 1);
            cell.contentLabel.textColor = SetColor(48, 132, 252, 1);
        }else if(defaultAnswer == 2) {
            cell.tagString = @"易错";
        }
        
        if (answer != 1 && self.selected_indexPath == indexPath) {
            cell.leftLabel.layer.borderColor = SetColor(242, 68, 89, 1).CGColor;
            cell.leftLabel.textColor = SetColor(242, 68, 89, 1);
            cell.contentLabel.textColor = SetColor(242, 68, 89, 1);
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.model.question_content_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!self.isShowParsing) {
        return 0.0;
    }
    return self.model.judge_parsing_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    [self setHeaderView:header_view];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    [self setFooterView:footer_view];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.isShowParsing = YES;
    self.selected_indexPath = indexPath;
    [self.tableview reloadData];
}

- (void)setHeaderView:(UIView *)header_view {
    header_view.backgroundColor = WhiteColor;
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(14);
    title_label.textColor = DetailTextColor;
    title_label.text = @"2017年浙江省副省级考卷·第三题";
    [header_view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    UILabel *question_content = [[UILabel alloc] init];
    question_content.font = SetFont(16);
    question_content.numberOfLines = 0;
    question_content.text = self.model.question_title;//@"三、给定资料3中提到“为钱创业是肤浅的，应为梦想所驱动。”请你根据对这句话的理解自选角度，自拟题目，写一篇文章。（50分）";
    [header_view addSubview:question_content];
    [question_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_bottom).offset(10);
        make.left.equalTo(title_label.mas_left);
        make.right.equalTo(header_view.mas_right).offset(-20);
    }];
    
    UILabel *require_label = [[UILabel alloc] init];
    require_label.font = SetFont(14);
    require_label.textColor = DetailTextColor;
    require_label.numberOfLines = 0;
    require_label.text = self.model.finish_require_string;//@"要求： \n（1）观点明确，认识深刻； \n（2）内容充实，结构完整、逻辑清晰，语言流畅；\n（3）字数不超过1000～1200字。";
    [header_view addSubview:require_label];
    [require_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(question_content.mas_bottom).offset(5);
        make.left.equalTo(question_content.mas_left);
        make.right.equalTo(question_content.mas_right);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(require_label.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left);
        make.right.equalTo(header_view.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *chooseQuestion_title = [[UILabel alloc] init];
    chooseQuestion_title.font = SetFont(16);
    chooseQuestion_title.textColor = SetColor(74, 74, 74, 1);
    chooseQuestion_title.numberOfLines = 0;
    chooseQuestion_title.text = self.model.judge_title;//@"1、本题大申论的类型为？";
    [header_view addSubview:chooseQuestion_title];
    [chooseQuestion_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
    }];
    
    //存储当前题目信息
    [[NSString stringWithFormat:@"%@++++++%@", self.model.question_title, self.model.finish_require_string] writeToFile:CurrentTestTraining_QuestionInfo_File_Data atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)setFooterView:(UIView *)footer_view {
    footer_view.backgroundColor = WhiteColor;
    UITextView *textview = [[UITextView alloc] init];
    textview.font = SetFont(14);
    textview.backgroundColor = SetColor(246, 246, 246, 1);
    textview.editable = NO;
    textview.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    textview.text = self.model.judge_parsing;
    ViewRadius(textview, 8.0);
    [footer_view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
}

/**
 跳转到第二步
 */
- (void)pushSecondVC {
    SmallTrainingSecondViewController *second = [[SmallTrainingSecondViewController alloc] init];
    [self.navigationController pushViewController:second animated:YES];
}

@end
