//
//  First_ AnalyzeQuestionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "First_AnalyzeQuestionViewController.h"
#import "OptionTableViewCell.h"
#import "MaterialsViewController.h"
#import "UploadPointsViewController.h"

@interface First_AnalyzeQuestionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *talbeview;

//保存材料数据
@property (nonatomic, strong) NSArray *materials_array;

//保存题干数据   根据材料   需要回答的题目
@property (nonatomic, strong) NSArray *question_array;

/** 小申论所有题目的数据 */
@property (nonatomic, strong) NSArray *dataArray;

/** 当前题目的数据 */
@property (nonatomic, strong) NSDictionary *current_dic;

/** 审题判断的单选题 */
@property (nonatomic, strong) NSArray *choice_id_list;

/** 记录当前做到了第几题 */
@property (nonatomic, assign) NSInteger current_choice_index;

@end

@implementation First_AnalyzeQuestionViewController


/**
 获取小申论的题干 要求 解析 多个选择题
 全部数据
 */
- (void)getHttpData {
    if (!self.small_tests_id_array) {
        [self showHUDWithTitle:@"无申论ID"];
        return;
    }
    //题目的ID  用于获取后面数据
//    [[NSUserDefaults standardUserDefaults] setObject:self.small_tests_id forKey:@"small_essayTest_id"];
    //请求申论材料   有了数据之后  进行跳转    防止布局出现问题
    __weak typeof(self) weakSelf = self;
    NSDictionary *parma = @{@"essay_id_":self.small_tests_id_array};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_small_essay_judgment" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"small content === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"];
            [weakSelf getCurrentQuestionData:weakSelf.question_index];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", weakSelf.dataArray.count] forKey:Small_EssayTests_All_Numbers];
        }
        
    } FailureBlock:^(id error) {
        
    }];
}

- (void)getCurrentQuestionData:(NSInteger)index {
    NSLog(@"index == %ld", index);
    if (self.dataArray.count == 0) {
        [self showHUDWithTitle:@"无数据"];
        return;
    }
    //保存当前的index  用于最后判断是显示完成还是下一题
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", index] forKey:@"current_index"];
    self.current_dic = self.dataArray[index];
    self.choice_id_list = self.current_dic[@"choice_id_list_"];
    NSLog(@"current == %@", self.current_dic[@"title_"]);
    [self.talbeview reloadData];
    //保存当前题目的题目ID
    //方便做完之后上传改题对应的答案
    [[NSUserDefaults standardUserDefaults] setObject:self.current_dic[@"id_"] forKey:Small_EssayTests_Current_Question_ID];
    
    //保存当前题目的答案
    [[NSUserDefaults standardUserDefaults] setObject:self.current_dic[@"parsing_list_"][0] forKey:Small_EssayTests_Current_Question_Answer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    //当前正在做题的index
    self.question_index = 0;
    self.current_choice_index = 0;
    
    self.talbeview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.talbeview.backgroundColor = WhiteColor;
    self.talbeview.delegate = self;
    self.talbeview.dataSource = self;
    [self.talbeview registerClass:[OptionTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.talbeview];
    __weak typeof(self) weakSelf = self;
    [self.talbeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //添加左滑  右滑手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] init];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [swipe addTarget:self action:@selector(swipeAction:)];
    
    [self.talbeview addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] init];
    swipe1.direction = UISwipeGestureRecognizerDirectionRight;
    [swipe1 addTarget:self action:@selector(swipeAction:)];

    [self.talbeview addGestureRecognizer:swipe1];
    
    [self getHttpData];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        //左滑
        if (self.current_choice_index == 0) {
            [self showHUDWithTitle:@"第一题"];
            return;
        }
        self.current_choice_index--;
        self.isShowAnalysis = NO;
        [self.talbeview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        //右滑
        if (self.current_choice_index == self.choice_id_list.count - 1) {
            [self showHUDWithTitle:@"最后一题"];
            return;
        }
        self.current_choice_index++;
        self.isShowAnalysis = NO;
        [self.talbeview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

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
    OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.leftLabel.text = @[@"A", @"B", @"C", @"D"][indexPath.row];
    cell.contentLabel.textColor = DetailTextColor;
    
    if (self.choice_id_list.count == 0) {
        cell.contentLabel.text = @"";
    }else {
        cell.contentLabel.text = self.choice_id_list[self.current_choice_index][@"tp_options_result"][indexPath.row][@"content_"];
    }
    cell.tagLabel.text = @"";
    //显示正确答案以及解析
    if (self.isShowAnalysis) {
        NSInteger yes_answer = [self.choice_id_list[self.current_choice_index][@"tp_options_result"][indexPath.row][@"answer_"] integerValue];
        if (yes_answer == 1) {
            cell.contentLabel.textColor = ButtonColor;
        }else if (yes_answer == 2) {
            cell.contentLabel.textColor = SetColor(242, 68, 89, 1);
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OPTION_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        //题干
        NSString *string = self.current_dic[@"title_"];//self.question_array[self.question_index][@"content_"];
        CGFloat height = [self calculateRowHeight:string fontSize:16 withWidth:SCREENBOUNDS.width - 40];
        //要求
        NSString *require = @"";
        for (NSString *string in self.current_dic[@"content_list_"]) {
            require = [require stringByAppendingString:[NSString stringWithFormat:@"%@\n", string]];
        }
        
        NSString *string1 = require;
        CGFloat height1 = [self calculateRowHeight:string1 fontSize:14 withWidth:SCREENBOUNDS.width - 40];
        return height + height1 + 120;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (self.choice_id_list.count == 0) {
            return 0.0;
        }
        //展示的是单选题的解析
        NSString *analysis_string = self.choice_id_list[self.current_choice_index][@"parsing_"];
        CGFloat height = [self calculateRowHeight:analysis_string fontSize:14 withWidth:SCREENBOUNDS.width - 80];
        return height + 80;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    if (section == 0) {
        [self setFirst_header_view:header_view];
    }else {
        if (self.choice_id_list.count > 0) {
            //单选题的题干
            UILabel *label = [[UILabel alloc] init];
            label.font = SetFont(16);
            label.text = self.choice_id_list[self.current_choice_index][@"content_"];//@"1、本题小申论的类型为？";
            [header_view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
            }];
        }
    }
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = WhiteColor;
    if (section == 1) {
        if (self.isShowAnalysis) {
            [self setFooter_view:footer_view];
        }
    }else {
        footer_view.backgroundColor = DetailTextColor;
    }
    return footer_view;
}

#pragma mark ---- tableviwe  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.isShowAnalysis = YES;
    [self.talbeview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

//section == 1    header_view
- (void)setFirst_header_view:(UIView *)header_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"第一步：审题判断";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(20);
        make.centerX.equalTo(header_view.mas_centerX);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = DetailTextColor;
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *year_label = [[UILabel alloc] init];
    year_label.font = SetFont(14);
    year_label.textColor = DetailTextColor;
    year_label.text = @"2017年浙江省副省级考卷·第一题";
    [header_view addSubview:year_label];
    [year_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(line.mas_left);
    }];
    
    //题干
    UILabel *question_label = [[UILabel alloc] init];
    question_label.font = SetFont(16);
    question_label.numberOfLines = 0;
    question_label.text = self.current_dic[@"title_"];//self.question_array[self.question_index][@"content_"];//@"一、根据给定材料1、2，概括当代社会中/“90后/“群体开展创业优势。（20分）";
    [header_view addSubview:question_label];
    [question_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(year_label.mas_bottom).offset(10);
        make.left.equalTo(year_label.mas_left);
        make.right.equalTo(line.mas_right);
    }];
    
    //要求
    NSString *require = @"";
    for (NSString *string in self.current_dic[@"content_list_"]) {
        require = [require stringByAppendingString:[NSString stringWithFormat:@"%@\n", string]];
    }
    UILabel *require_label = [[UILabel alloc] init];
    require_label.font = SetFont(14);
    require_label.textColor = DetailTextColor;
    require_label.numberOfLines = 0;
    require_label.text = require;//self.question_array[self.question_index][@"require_"];//@"要求：内容全面，观点正确，语言简洁，字数不超过3000字。";
    [header_view addSubview:require_label];
    [require_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(question_label.mas_bottom).offset(10);
        make.left.equalTo(question_label.mas_left);
        make.right.equalTo(question_label.mas_right);
    }];
}

//section == 1   footer_view  单选题的解析
- (void)setFooter_view:(UIView *)footer_view {
    UIView *back_view = [[UIView alloc] init];
    ViewRadius(back_view, 5.0);
    back_view.backgroundColor = SetColor(246, 246, 246, 1);
    [footer_view addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    //设置解析label
    UILabel *analysisLabel = [[UILabel alloc] init];
    analysisLabel.font = SetFont(14);
    analysisLabel.textColor = SetColor(74, 74, 74, 1);
    analysisLabel.numberOfLines = 0;
    analysisLabel.text = self.choice_id_list[self.current_choice_index][@"parsing_"];
    [back_view addSubview:analysisLabel];
    [analysisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
}

#pragma mark ---- custom aciton
//下一步
- (void)nextAction {
//    MaterialsViewController *materials = [[MaterialsViewController alloc] init];
//    materials.dataArray = self.materials_array;
//    materials.essay_id = self.small_tests_id_array[0];
//    [self.navigationController pushViewController:materials animated:YES];
    UploadPointsViewController *points = [[UploadPointsViewController alloc] init];
    [self.navigationController pushViewController:points animated:YES];
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
