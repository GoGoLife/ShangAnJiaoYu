//
//  LookQuestionDetailsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/8.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "LookQuestionDetailsViewController.h"
#import "ExerciseTableViewCell.h"
#import "QuestionAnalysisViewController.h"

@interface LookQuestionDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) LookDetailsModel *model;

@end

@implementation LookQuestionDetailsViewController

//测试ID： 89dfb75d4e884adca20f9669a2e3b8a5
- (void)getQuestionDetailsData:(NSString *)question_id {
    NSDictionary *parma = @{@"id_":question_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_choice_detail" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.model.question_content = responseObject[@"data"][@"content_"];
            NSMutableArray *answer = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"tp_options_result"]) {
                [answer addObject:dic[@"content_"]];
            }
            weakSelf.model.answer_content = [answer copy];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self setBack];
    
    //Model
    self.model = [[LookDetailsModel alloc] init];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ExerciseTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //获取数据
    [self getQuestionDetailsData:self.question_id];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.answer_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftLabel.text = @[@"A",@"B",@"C",@"D"][indexPath.row];
    cell.contentLabel.text = self.model.answer_content[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *answer_content = self.model.answer_content[indexPath.row];
    return [self calculateRowHeight:answer_content fontSize:16 withWidth:SCREENBOUNDS.width - 90] + 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.model.question_content_height + 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    
    UILabel *type_label = [[UILabel alloc] init];
    type_label.font = SetFont(16);
    type_label.text = @"题干:";
    [header_view addSubview:type_label];
    [type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(5);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.font = SetFont(16);
    questionLabel.textColor = DetailTextColor;
    questionLabel.numberOfLines = 0;
    questionLabel.text = self.model.question_content;
    [header_view addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(20, 20, 0, 20));
    }];
    
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionAnalysisViewController *analysis = [[QuestionAnalysisViewController alloc] init];
    analysis.analysis_array = @[self.question_id];
    analysis.nextButton.hidden = YES;
    [self.navigationController pushViewController:analysis animated:YES];
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



#pragma mark ----- 自定义的查看题目详情的Model
@implementation LookDetailsModel

StringHeight()
- (CGFloat)question_content_height {
    return [self calculateRowHeight:self.question_content fontSize:16 withWidth:SCREENBOUNDS.width - 40];
}

@end
