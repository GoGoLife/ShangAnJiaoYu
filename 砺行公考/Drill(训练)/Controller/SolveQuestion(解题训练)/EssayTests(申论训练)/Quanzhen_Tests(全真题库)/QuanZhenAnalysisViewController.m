//
//  QuanZhenAnalysisViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "QuanZhenAnalysisViewController.h"
#import "EssayTestAnalysisModel.h"
#import "AnalysisForLabelTableViewCell.h"
#import "AnalysisForImageTableViewCell.h"
#import "AnalysisForWKWebviewTableViewCell.h"

@interface QuanZhenAnalysisViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *essayTest_dataArray;

@end

@implementation QuanZhenAnalysisViewController

- (void)getAnalysisData:(NSString *)essayTest_id {
    if (!essayTest_id) {
        [self showHUDWithTitle:@"全真试卷题目id为空"];
        return;
    }
    NSDictionary *parma = @{@"require_id_":essayTest_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_essay_answer" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"essayTest analysis == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf formatData:responseObject[@"data"]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)formatData:(NSDictionary *)dic {
    //我的答案
    EssayTestAnalysisModel *myAnswerModel = [[EssayTestAnalysisModel alloc] init];
    myAnswerModel.Analysis_model_string = @"我的答案";
    myAnswerModel.Analysis_content = dic[@"user_answer_"];
    
    //采点示范
    EssayTestAnalysisModel *CollectPointsModel = [[EssayTestAnalysisModel alloc] init];
    CollectPointsModel.Analysis_model_string = @"采点示范";
    CollectPointsModel.Analysis_content = dic[@"collect_demonstration_"];
    
    //剖题
    EssayTestAnalysisModel *anatomyModel = [[EssayTestAnalysisModel alloc] init];
    anatomyModel.Analysis_model_string = @"破题";
    anatomyModel.Analysis_content = dic[@"break_"];
    
    //推荐标题
    EssayTestAnalysisModel *recommendedModel = [[EssayTestAnalysisModel alloc] init];
    recommendedModel.Analysis_model_string = @"推荐标题";
    NSString *finish = @"";
    for (NSString *string in dic[@"recommend_title_list_"]) {
        finish = [finish stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", string]];
    }
    recommendedModel.Analysis_content = finish;
    
    //思维导图
    EssayTestAnalysisModel *mappingModel = [[EssayTestAnalysisModel alloc] init];
    mappingModel.Analysis_model_string = @"思维导图";
    mappingModel.Analysis_content = dic[@"thinking_map_list_"][0];
    
    //参考答案
    EssayTestAnalysisModel *referenceModel = [[EssayTestAnalysisModel alloc] init];
    referenceModel.Analysis_model_string = @"参考答案";
    NSString *referenceFinish = @"";
    for (NSString *string in dic[@"parsing_list_"]) {
        referenceFinish = [referenceFinish stringByAppendingString:[NSString stringWithFormat:@"参考范文\n%@\n\n", string]];
    }
    referenceModel.Analysis_content = referenceFinish;
    
    self.essayTest_dataArray = @[myAnswerModel, CollectPointsModel, anatomyModel, recommendedModel, mappingModel, referenceModel];
    
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"解析";
    [self setBack];
    
    [self initViewUI];
    
    [self getAnalysisData:self.dataArray[0]];
    
    NSLog(@"array == %@", self.dataArray);
    
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.scroll];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.essayTest_dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EssayTestAnalysisModel *model = self.essayTest_dataArray[indexPath.section];
    if ([model.Analysis_model_string isEqualToString:@"采点示范"]) {
        AnalysisForWKWebviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webviewCell"];
        cell.html_string = model.Analysis_content;
        return cell;
    }else if ([model.Analysis_model_string isEqualToString:@"思维导图"]) {
        AnalysisForImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        [cell.image_view sd_setImageWithURL:[NSURL URLWithString:model.Analysis_content] placeholderImage:[UIImage imageNamed:@"no_image"]];
        return cell;
    }else {
        AnalysisForLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
        cell.content_label.text = model.Analysis_content;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EssayTestAnalysisModel *model = self.essayTest_dataArray[indexPath.section];
    return model.analysis_content_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    EssayTestAnalysisModel *model = self.essayTest_dataArray[section];
    if (model.analysis_content_height == 0.0) {
        return 0.0;
    }
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    EssayTestAnalysisModel *model = self.essayTest_dataArray[section];
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.textColor = DetailTextColor;
    label.text = model.Analysis_model_string;
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = WhiteColor;
    return footer_view;
}

#pragma mark ---- 懒加载
- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] init];
        //设置button
        CGFloat button_width = (SCREENBOUNDS.width - 120) / 5;
        CGFloat button_height = 40.0;
        
        for (NSInteger index = 0; index < self.dataArray.count; index++) {
            CGFloat button_x = 20.0 + index * (button_width + 20);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = FRAME(button_x, 10, button_width, button_height);
            button.tag = index;
            button.titleLabel.font = SetFont(14);
            button.backgroundColor = SetColor(246, 246, 246, 1);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"第%ld题", index + 1] forState:UIControlStateNormal];
            ViewRadius(button, 5.0);
            [button addTarget:self action:@selector(changeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scroll addSubview:button];
            if (index == 0) {
                button.backgroundColor = ButtonColor;
                [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            }
        }
        _scroll.backgroundColor = WhiteColor;
        _scroll.bounces = NO;
        [_scroll setContentSize:CGSizeMake(self.dataArray.count * button_width + (self.dataArray.count - 1) * 20 + 40, 0)];
        _scroll.showsHorizontalScrollIndicator = NO;
    }
    return _scroll;
}

- (void)changeButtonAction:(UIButton *)sender {
    for (UIButton *button in self.scroll.subviews) {
        if (![button isKindOfClass:[UIButton class]]) {
            continue;
        }
        if (button.tag == sender.tag) {
            button.backgroundColor = ButtonColor;
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self getAnalysisData:self.dataArray[sender.tag]];
        }else {
            button.backgroundColor = SetColor(246, 246, 246, 1);;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}


- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[AnalysisForLabelTableViewCell class] forCellReuseIdentifier:@"labelCell"];
        [_tableview registerClass:[AnalysisForImageTableViewCell class] forCellReuseIdentifier:@"imageCell"];
        [_tableview registerClass:[AnalysisForWKWebviewTableViewCell class] forCellReuseIdentifier:@"webviewCell"];
    }
    return _tableview;
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
