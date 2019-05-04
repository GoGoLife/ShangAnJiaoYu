//
//  TrainingAnalysisViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TrainingAnalysisViewController.h"
#import "OptionTableViewCell.h"
#import "StarsView.h"
#import <SJVideoPlayer.h>
#import "TrainingSecondDoQuestionViewController.h"
#import "TrainingHomeViewController.h"
#import "QuestionAnalysisModel.h"
#import "AnswerModel.h"
#import "TraningDoQuestionViewController.h"
#import "FiveRoundsFirstViewController.h"

@interface TrainingAnalysisViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) SJVideoPlayer *player;

//保存查看的题目的位置   默认从第一题开始
@property (nonatomic, assign) NSInteger question_index;

//解析数据Model
@property (nonatomic, strong) QuestionAnalysisModel *questionModel;

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation TrainingAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.question_index = 0;
    
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[OptionTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //添加下一题按钮  到    Window上
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.backgroundColor = ButtonColor;
    self.nextButton.titleLabel.font = SetFont(14);
    [self.nextButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    ViewRadius(self.nextButton, 25.0);
    [self.nextButton addTarget:self action:@selector(look_next_action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-150);
        make.size.mas_equalTo(CGSizeMake(120, 50));
    }];
    
    [self look_next_action];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //题目数据
    AnswerModel *model = self.questionModel.answerArray[indexPath.row];
    OptionTableViewCell *optionCell = [tableView dequeueReusableCellWithIdentifier:@"optionCell"];
    if (!optionCell) {
        optionCell = [[OptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optionCell"];
    }
    optionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    optionCell.leftLabel.text = @[@"A", @"B", @"C", @"D"][indexPath.row];
    optionCell.contentLabel.attributedText = [self returnAnswerContentIndexPath:model];
    //正确答案标蓝
    if ([model.isCorrect isEqualToString:@"1"]) {
        optionCell.leftLabel.textColor = ButtonColor;
        optionCell.leftLabel.layer.borderColor = ButtonColor.CGColor;
        optionCell.contentLabel.textColor = ButtonColor;
    }else {
        optionCell.leftLabel.textColor = DetailTextColor;
        optionCell.leftLabel.layer.borderColor = DetailTextColor.CGColor;
        optionCell.contentLabel.textColor = DetailTextColor;
    }
    return optionCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnswerModel *model = self.questionModel.answerArray[indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%@", [self returnAnswerContentIndexPath:model]];
    CGFloat height = [self calculateRowHeight:content fontSize:14 withWidth:SCREENBOUNDS.width - 90];
    return height > 70.0 ? height : 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.questionModel.questionStringHeight + 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat back_view_height = self.question_index < self.analysis_question_id_array.count ? 0.0 : 270.0;
    return self.questionModel.answerAnalysisString_height + self.questionModel.finish_function_height + 300.0 + back_view_height;
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

- (void)setHeaderView:(UIView *)header_view {
    header_view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.textColor = SetColor(74, 74, 74, 1);
    label.numberOfLines = 0;
    label.text = self.questionModel.questionString;//@"1、当我们经历艰难终于抵达互相的四湖，突然发现眼前的村镇予以集中的互相升面目苏那双方尽得，___________的老热播个暖体的孩子的，和封建社会才开始绿肥红瘦开发和家人分开就______。";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
}

- (void)setFooterView:(UIView *)footer_view {
    footer_view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"精解";
    [footer_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer_view.mas_top).offset(10);
        make.left.equalTo(footer_view.mas_left).offset(20);
    }];
    
    UILabel *answer_label = [[UILabel alloc] init];
    answer_label.font = SetFont(18);
    answer_label.text = @"参考答案：C";
    [footer_view addSubview:answer_label];
    [answer_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
    }];
    
    //砺行方法
    UILabel *function = [[UILabel alloc] init];
    function.font = SetFont(18);
    function.text = @"砺行方法：";
    [footer_view addSubview:function];
    [function mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answer_label.mas_bottom).offset(12);
        make.left.equalTo(answer_label.mas_left);
    }];
    
    UILabel *function_content = [[UILabel alloc] init];
    function_content.font = SetFont(14);
    function_content.textColor = SetColor(74, 74, 74, 1);
    function_content.numberOfLines = 0;
    function_content.text = self.questionModel.finish_function_string;//@"重心信息的信息对应点法、主被动维度法 ";
    [footer_view addSubview:function_content];
    [function_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(function.mas_bottom).offset(10);
        make.left.equalTo(footer_view.mas_left).offset(20);
        make.right.equalTo(footer_view.mas_right).offset(-20);
    }];
    
    //解题步骤
    UILabel *steps_label = [[UILabel alloc] init];
    steps_label.font = SetFont(18);
    steps_label.text = @"解题步骤：";
    [footer_view addSubview:steps_label];
    [steps_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(function_content.mas_bottom).offset(10);
        make.left.equalTo(footer_view.mas_left).offset(20);
    }];
    
    UILabel *steps_content = [[UILabel alloc] init];
    steps_content.font = SetFont(14);
    steps_content.textColor = SetColor(74, 74, 74, 1);
    steps_content.numberOfLines = 0;
    steps_content.text = self.questionModel.answerAnalysisString;//@"该题使用信息对应点法。当地好的好。觉得客户会发，生厉害呐上班看见撒谎的好看了，撒娇哭了就离。开价值连城状况会笑口常开着谁的风景哦速速，破非农数据可能参加了，看自己车司机。滴哦加哦评价颇激动就离。开你你是加拿大进口，几乎是个飞机回国。公司开会就开始，方法和技术考核，是德国很快就会出困境。即使世界的成绩，市场经济健康。";
    [footer_view addSubview:steps_content];
    [steps_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(steps_label.mas_bottom).offset(10);
        make.left.equalTo(footer_view.mas_left).offset(20);
        make.right.equalTo(footer_view.mas_right).offset(-20);
    }];
    
    UILabel *stars_label = [[UILabel alloc] init];
    stars_label.font = SetFont(18);
    stars_label.text = @"星级难度：";
    [footer_view addSubview:stars_label];
    [stars_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(steps_content.mas_bottom).offset(30);
        make.left.equalTo(footer_view.mas_left).offset(20);
    }];
    
    //星级难度
    NSInteger number = [self.questionModel.starLevel_stirng integerValue];
    StarsView *stars = [[StarsView alloc] initWithStarSize:CGSizeMake(20, 20) space:10 numberOfStar:number];
//    stars.backgroundColor = [UIColor redColor];
    stars.selectable = NO;
    [footer_view addSubview:stars];
    [stars mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(steps_content.mas_bottom).offset(30);
        make.left.equalTo(stars_label.mas_right).offset(5);
    }];
    
    CGFloat back_view_height = self.question_index < self.analysis_question_id_array.count ? 0.0 : 200.0;
    UIView *back_view = [[UIView alloc] init];
    [footer_view addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stars.mas_bottom).offset(30);
        make.left.equalTo(footer_view.mas_left);
        make.right.equalTo(footer_view.mas_right);
        make.height.mas_equalTo(back_view_height);
    }];
    
    //添加back_view内容
    [self setBackViewContent:back_view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:WhiteColor];
    [button setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
    [button setTitle:@"添加tips并保存到总结本" forState:UIControlStateNormal];
    ViewBorderRadius(button, 0.0, 1.0, DetailTextColor);
    [footer_view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_bottom).offset(40);
        make.left.equalTo(footer_view.mas_left);
        make.right.equalTo(footer_view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    NSInteger order = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lineTestExamCount"] integerValue] - 1;
    //学习新方法
    UIButton *studyNewFunction = [UIButton buttonWithType:UIButtonTypeCustom];
    [studyNewFunction setBackgroundColor:SetColor(67, 154, 247, 1)];
    studyNewFunction.titleLabel.font = SetFont(16);
    [studyNewFunction setTitleColor:WhiteColor forState:UIControlStateNormal];
    [studyNewFunction setTitle:@"学习新方法" forState:UIControlStateNormal];
//    //根据不同的类型  显示不同的文本
//    if (self.type == AnalysisType_FiveRounds_First) {
//        [studyNewFunction setTitle:@"" forState:UIControlStateNormal];
//    }
    ViewRadius(studyNewFunction, 25.0);
    [footer_view addSubview:studyNewFunction];
    if (self.type == AnalysisType_Third) {
        [studyNewFunction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(20);
            make.left.equalTo(footer_view.mas_left).offset(20);
            make.size.mas_equalTo(CGSizeMake(160.0, 50.0));
        }];
    }else if (self.type == order && self.question_index == self.analysis_question_id_array.count) {
        [studyNewFunction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(20);
            make.centerX.equalTo(footer_view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(160.0, 50.0));
        }];
    }else {
        studyNewFunction.hidden = YES;
    }
    [studyNewFunction addTarget:self action:@selector(studyNewFunctionAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pushDrill = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushDrill setBackgroundColor:SetColor(67, 154, 247, 1)];
    pushDrill.titleLabel.font = SetFont(16);
    ViewRadius(pushDrill, 25.0);
    [pushDrill setTitleColor:WhiteColor forState:UIControlStateNormal];
    [pushDrill setTitle:@"进入训练" forState:UIControlStateNormal];
    [footer_view addSubview:pushDrill];
    if (self.type == AnalysisType_Third) {
        [pushDrill mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(20);
            make.left.equalTo(studyNewFunction.mas_right).offset(40.0);
            make.size.mas_equalTo(CGSizeMake(160, 50));
        }];
    }else if (self.type == order) {
        pushDrill.hidden = YES;
    } else {
        [pushDrill mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(20);
            make.centerX.equalTo(footer_view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(160, 50));
        }];
    }
    [pushDrill addTarget:self action:@selector(pushSecondVC) forControlEvents:UIControlEventTouchUpInside];
    if (self.question_index == self.analysis_question_id_array.count) {
        pushDrill.hidden = NO;
        self.nextButton.hidden = YES;
    }else {
        pushDrill.hidden = YES;
    }
    
    //五轮第一轮  解析界面按钮隐藏
//    if (self.type == AnalysisType_FiveRounds_First) {
//        studyNewFunction.hidden = YES;
//        pushDrill.hidden = NO;
//    }
}

- (void)setBackViewContent:(UIView *)back_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"训练指导";
    [back_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    self.player = [[SJVideoPlayer alloc] init];
    self.player.disableAutoRotation = YES;
    ViewRadius(self.player.view, 8.0);
    [back_view addSubview:self.player.view];
    self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"current_exam_analysis_video"]]];
    self.player.autoPlay = NO;
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.bottom.equalTo(back_view.mas_bottom).offset(0);
    }];
    //播放结束回调
    self.player.playDidToEndExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        [player replay];
    };
}

//进入下一轮训练
- (void)pushSecondVC {
    DoQuestionType DoType = DoQuestionType_Training_Second;
    NSString *order = @"2";
    if (self.type == AnalysisType_First) {
        //解析第一轮  跳转到做题第二轮
        DoType = DoQuestionType_Training_Second;
        order = @"2";
    }else if (self.type == AnalysisType_Second) {
        DoType = DoQuestionType_Training_Third;
        order = @"3";
    }else if (self.type == AnalysisType_Third) {
        DoType = DoQuestionType_Training_Fourth;
        order = @"4";
    }else if (self.type == AnalysisType_Fourth) {
        DoType = DoQuestionType_Training_Fifth;
        order = @"5";
    }else if (self.type == AnalysisType_Fifth) {
        DoType = DoQuestionType_Training_Sixth;
        order = @"6";
    }else if (self.type == AnalysisType_Sixth) {
        DoType = DoQuestionType_Training_Seventh;
        order = @"7";
    }else if (self.type == AnalysisType_Seventh) {
        DoType = DoQuestionType_Training_Eighth;
        order = @"8";
    }else if (self.type == AnalysisType_Eighth) {
        DoType = DoQuestionType_Training_Nineth;
        order = @"9";
    }else if (self.type == AnalysisType_Nineth) {
        DoType = DoQuestionType_Training_Tenth;
        order = @"10";
    }else if (self.type == AnalysisType_Tenth) {
        //最后一轮  直接返回吧
    }else if (self.type == AnalysisType_FiveRounds_First) {
        DoType = DoQuestionType_FiveRounds_First;
        
    }
    
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[TraningDoQuestionViewController class]]) {
            TraningDoQuestionViewController *DoQuestion = (TraningDoQuestionViewController *)vc;
            DoQuestion.doType = DoType;
            DoQuestion.isShowPlayer = NO;
            [DoQuestion getDataWithExamWithOrder:[order integerValue]];
            [self.navigationController popToViewController:DoQuestion animated:YES];
            return;
        }
    }
}

/** 跳转学习新方法 */
- (void)studyNewFunctionAction {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[TrainingHomeViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }else if ([vc isKindOfClass:[FiveRoundsFirstViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark ------ 根据题目ID请求数据 + 下一题Action
- (void)look_next_action {
    [self showHUD];
    if (self.question_index > self.analysis_question_id_array.count - 1) {
        [self showHUDWithTitle:@"已经是最后一题了！"];
        return;
    }
    NSString *question_id = self.analysis_question_id_array[self.question_index];
    NSDictionary *parma = @{@"id_":question_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_choice/parsing" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"analysis  data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf format_data:(NSDictionary *)responseObject[@"data"]];
            //            [weakSelf hidden];
            //获取评论数据
//            [weakSelf getCommentData];
        }
        [weakSelf hidden];
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
    //在最后question_index + 1   确保进入下一题
    self.question_index++;
}

//整理数据
- (void)format_data:(NSDictionary *)data_dic {
    self.questionModel = [[QuestionAnalysisModel alloc] init];
    //单选  多选
    self.questionModel.question_choice_type_ = [NSString stringWithFormat:@"%ld", [data_dic[@"choice_type_"] integerValue]];
    //星级
    self.questionModel.starLevel_stirng = [NSString stringWithFormat:@"%ld", [data_dic[@"degree_"] integerValue]];
    //题号
    self.questionModel.questionNumber = [NSString stringWithFormat:@"%ld", self.question_index];
    //题干
    self.questionModel.questionString = data_dic[@"content_"];
    //题干图片
    self.questionModel.question_image_array = data_dic[@"question_choice_picture_result"];
    //砺行方法
    self.questionModel.analysis_function_array = data_dic[@"method_result"];
    //星级难度
    self.questionModel.starLevel_stirng = [NSString stringWithFormat:@"%ld", [data_dic[@"degree_"] integerValue]];
    
    //题目选项
    NSMutableArray *answer = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *answer_dic in data_dic[@"tp_options_result"]) {
        AnswerModel *model = [[AnswerModel alloc] init];
        model.answer_id = @"";
        model.answer_content_image = answer_dic[@"question_picture_id_"];
        model.answer_content = answer_dic[@"content_"];
        model.isCorrect = [NSString stringWithFormat:@"%ld", [answer_dic[@"answer_"] integerValue]];
        [answer addObject:model];
    }
    self.questionModel.answerArray = [answer copy];
    //解析
    self.questionModel.answerAnalysisString = data_dic[@"parsing_"];
    
    //错因标签数据
    self.questionModel.error_label_list = data_dic[@"error_label_list_"];
    
    [self.tableview reloadData];
}

//将答案的图片 拼接在answerContent 后面
- (NSMutableAttributedString *)returnAnswerContentIndexPath:(AnswerModel *)model {
    NSMutableAttributedString *mutable_string = [[NSMutableAttributedString alloc] initWithString:model.answer_content ?: @""];
    if (![model.answer_content_image isEqualToString:@""]) {
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:model.answer_content_image]];
        UIImage *image = [UIImage imageWithData:imageData];
        NSTextAttachment *imageText = [[NSTextAttachment alloc] init];
        imageText.image = image;
        imageText.bounds = FRAME(0, 0, 40, 40);
        //创建可携带图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:imageText];
        [mutable_string insertAttributedString:string atIndex:model.answer_content.length];
    }
    return mutable_string;
}

@end
