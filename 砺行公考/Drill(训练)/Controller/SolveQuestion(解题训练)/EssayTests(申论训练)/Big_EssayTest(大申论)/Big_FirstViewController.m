//
//  Big_FirstViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/19.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Big_FirstViewController.h"
#import "OptionTableViewCell.h"
#import "MaterialsViewController.h"
#import "WriteTitleView.h"
#import "chooseTitleView.h"
#import "ShowBastTitleView.h"
#import "UploadPointsViewController.h"

@interface Big_FirstViewController ()<UITableViewDelegate, UITableViewDataSource, ReturnChooseTitleArrayDelegate, ShowBastViewDelegate>

@property (nonatomic, strong) UITableView *talbeview;

@property (nonatomic, strong) NSArray *big_materials_array;

@property (nonatomic, strong) NSArray *question_array;

@property (nonatomic, assign) BOOL isShowYesAnswer;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UITextField *field;

@end

@implementation Big_FirstViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
}

//获取大申论题的题目和材料数据
- (void)getHttpData {
    if (!self.big_essayTest_id) {
        [self showHUDWithTitle:@"无申论ID"];
        return;
    }
    //保存题目ID  用于后续获取数据
    [[NSUserDefaults standardUserDefaults] setObject:self.big_essayTest_id forKey:@"big_essayTest_id"];
    
    //请求申论材料   有了数据之后  进行跳转    防止布局出现问题
    __weak typeof(self) weakSelf = self;
    NSDictionary *parma = @{@"essay_id_":self.big_essayTest_id};
//    NSLog(@"parma == %@", parma);
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_big_essay_title" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"big essay test === %@", responseObject);
            weakSelf.dataDic = responseObject[@"data"];
            [weakSelf.talbeview reloadData];
            //存储大申论中的题的ID  用于后续获取大申论解析数据
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"id_"] forKey:@"big_essayTest_require_id"];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    [self getHttpData];
    
    self.talbeview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.talbeview.delegate = self;
    self.talbeview.dataSource = self;
    [self.talbeview registerClass:[OptionTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.talbeview.scrollEnabled = NO;
    [self.view addSubview:self.talbeview];
    __weak typeof(self) weakSelf = self;
    [self.talbeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0;
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.leftLabel.text = @[@"A", @"B", @"C", @"D"][indexPath.row];
    cell.contentLabel.textColor = DetailTextColor;
    cell.contentLabel.text = self.question_array[0][@"essay_judge_options_result"][indexPath.row][@"content_"];//@"答案选项内容";
    cell.tagLabel.text = @"";
    if (self.isShowYesAnswer) {
        NSString *yes_answer = self.question_array[0][@"essay_judge_options_result"][indexPath.row][@"answer_"];
        if ([yes_answer integerValue]) {
            cell.contentLabel.textColor = ButtonColor;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//
//    }
//    return 0.0;
    NSString *finish = @"";
    for (NSString *string in self.dataDic[@"content_list_"]) {
        finish = [finish stringByAppendingString:[NSString stringWithFormat:@"%@\n", string]];
    }
    CGFloat height = [self calculateRowHeight:self.dataDic[@"title_"] fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    CGFloat height1 = [self calculateRowHeight:finish fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    return height + height1 + 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 500.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    [self setFirst_header_view:header_view];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = WhiteColor;
    [self setFooter_view:footer_view];
    return footer_view;
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
    
    UILabel *question_label = [[UILabel alloc] init];
    question_label.font = SetFont(16);
    question_label.numberOfLines = 0;
    question_label.text = self.dataDic[@"title_"];//@"一、根据给定材料1、2，概括当代社会中/“90后/“群体开展创业优势。（20分）";
    [header_view addSubview:question_label];
    [question_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(year_label.mas_bottom).offset(10);
        make.left.equalTo(year_label.mas_left);
        make.right.equalTo(line.mas_right);
    }];
    
    NSString *finish = @"";
    for (NSString *string in self.dataDic[@"content_list_"]) {
        finish = [finish stringByAppendingString:[NSString stringWithFormat:@"%@\n", string]];
    }
    UILabel *require_label = [[UILabel alloc] init];
    require_label.font = SetFont(14);
    require_label.textColor = DetailTextColor;
    require_label.numberOfLines = 0;
    require_label.text = finish;//@"要求： \n（1）观点明确，认识深刻； \n（2）内容充实，结构完整、逻辑清晰，语言流畅；\n（3）字数不超过1000～1200字。";
    [header_view addSubview:require_label];
    [require_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(question_label.mas_bottom).offset(10);
        make.left.equalTo(question_label.mas_left);
        make.right.equalTo(question_label.mas_right);
    }];
}

//section == 1   footer_view
- (void)setFooter_view:(UIView *)footer_view {
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [footer_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer_view.mas_top);
        make.left.equalTo(footer_view.mas_left);
        make.right.equalTo(footer_view.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @" 请拟定您心中的标题";
    [footer_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer_view.mas_top).offset(40);
        make.left.equalTo(footer_view.mas_left).offset(20);
    }];
    
    self.field = [[UITextField alloc] init];
    self.field.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(self.field, 8.0);
    self.field.placeholder = @" 请输入您心中的大标题";
    [footer_view addSubview:self.field];
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(footer_view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    __weak typeof(self) weakSelf = self;
    UITextField *field1 = [[UITextField alloc] init];
    field1.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(field1, 8.0);
    field1.placeholder = @"在此输入副标题（如有）";
    [footer_view addSubview:field1];
    [field1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.field.mas_bottom).offset(20);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(footer_view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    
    
    
//    UIView *back_view = [[UIView alloc] init];
//    ViewRadius(back_view, 5.0);
//    back_view.backgroundColor = SetColor(246, 246, 246, 1);
//    [footer_view addSubview:back_view];
//    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
//    }];
//
//    //设置解析label
//    UILabel *analysisLabel = [[UILabel alloc] init];
//    analysisLabel.font = SetFont(14);
//    analysisLabel.textColor = SetColor(74, 74, 74, 1);
//    analysisLabel.numberOfLines = 0;
//    analysisLabel.text = self.question_array[0][@"parsing_"];//@"解析： \n该题使用信息对应点法。当地好的好。觉得客户会发，生厉害呐上班看见撒谎的好看了，撒娇哭了就离。开价值连城状况会笑口常开着谁的风景哦速速，破非农数据可能参加了，看自己车司机。滴哦加哦评价颇激动就离。开你你是加拿大进口，几乎是个飞机回国。公司开会就开始，方法和技术考核，是德国很快就会出困境。即使世界的成绩，市场经济健康。";
//    [back_view addSubview:analysisLabel];
//    [analysisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
//    }];
}

#pragma mark ---- custom aciton
//下一步    撰写标题
- (void)nextAction {
    self.navigationItem.rightBarButtonItem = nil;
    if ([self.field.text isEqualToString:@""]) {
        [self showHUDWithTitle:@"请输入标题"];
        return;
    }
    
    [self.field resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    chooseTitleView *choose_view = [[chooseTitleView alloc] init];
//    choose_view.big_essayTest_id = weakSelf.big_essayTest_id;
    choose_view.delegate = self;
    choose_view.dataArray = self.dataDic[@"title_list_"];
    [weakSelf.view addSubview:choose_view];
    [choose_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(240);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
//    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    WriteTitleView *titleView = [[WriteTitleView alloc] initWithFrame:app_delegate.window.bounds];
//    titleView.userInteractionEnabled = YES;
//    __weak typeof(self) weakSelf = self;
//    __strong WriteTitleView *title_view = titleView;
//    titleView.nextBlock = ^{
//        weakSelf.navigationItem.rightBarButtonItem = nil;
//        [title_view removeFromSuperview];
//        //跳转下一个页面
//        chooseTitleView *choose_view = [[chooseTitleView alloc] init];
//        choose_view.big_essayTest_id = weakSelf.big_essayTest_id;
//        choose_view.delegate = self;
//        [weakSelf.view addSubview:choose_view];
//        [choose_view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.view.mas_top).offset(240);
//            make.left.equalTo(weakSelf.view.mas_left);
//            make.bottom.equalTo(weakSelf.view.mas_bottom);
//            make.right.equalTo(weakSelf.view.mas_right);
//        }];
//    };
//    [app_delegate.window addSubview:titleView];
}

#pragma mark ----- custom delegate
//delegate   返回所选择的认为最合适的三个标题
- (void)returnChooseTitleArray:(NSArray *)array {
    NSLog(@"selected title array === %@", array);
    [[NSUserDefaults standardUserDefaults] setObject:array[0] forKey:@"default_bast_title"];
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ShowBastTitleView *show_title_view = [[ShowBastTitleView alloc] initWithFrame:app_delegate.window.bounds];
    show_title_view.delegate = self;
    show_title_view.dataArr = array;
    [app_delegate.window addSubview:show_title_view];
}

//呈现最佳标题页面  delegate
- (void)touchStartButtonAction {
//    MaterialsViewController *materials = [[MaterialsViewController alloc] init];
////    materials.dataArray = self.big_materials_array;
//    materials.isBigEssayTests = YES;
//    materials.big_essay_id = self.big_essayTest_id;
//    [self.navigationController pushViewController:materials animated:YES];
//    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextVC)];
    [[NSUserDefaults standardUserDefaults] setObject:self.field.text forKey:BigEssayTests_my_title];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否需要修改标题" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UploadPointsViewController *points = [[UploadPointsViewController alloc] init];
        points.isBigTest = YES;
        [weakSelf.navigationController pushViewController:points animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextVC)];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pushNextVC {
    [[NSUserDefaults standardUserDefaults] setObject:self.field.text forKey:BigEssayTests_my_title];
    UploadPointsViewController *points = [[UploadPointsViewController alloc] init];
    points.isBigTest = YES;
    [self.navigationController pushViewController:points animated:YES];
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
