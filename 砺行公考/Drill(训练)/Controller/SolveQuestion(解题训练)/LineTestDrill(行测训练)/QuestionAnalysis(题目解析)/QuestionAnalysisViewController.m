//
//  QuestionAnalysisViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "QuestionAnalysisViewController.h"
#import "OptionTableViewCell.h"
#import "CommentTableViewCell.h"
#import "QuestionAnalysisModel.h"
#import "AnalysisTableViewCell.h"
#import "AnswerModel.h"
#import "CommentHeaderView.h"
#import "CommentFooterView.h"
#import "TipsCollectionViewCell.h"

@interface QuestionAnalysisViewController ()<UITableViewDelegate, UITableViewDataSource, CommentFooterViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AnalysisTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArr;

//保存查看的题目的位置   默认从第一题开始
@property (nonatomic, assign) NSInteger question_index;

//解析数据Model
@property (nonatomic, strong) QuestionAnalysisModel *questionModel;

//主要用于是否刷新section （查看精解的section）
@property (nonatomic, assign) BOOL isReloadSection;

//发表评论输入框
@property (nonatomic, strong) UIView *bottom_tool;

//评论输入框
@property (nonatomic, strong) UITextField *input_comment_textfield;

/** 用于判断评论的是不是子评论 */
@property (nonatomic, assign) BOOL isSonComment;

/** 用于保存点击的是那个section   便于获取相关数据  用于上传 */
@property (nonatomic, assign) NSInteger touchSection;

/** 展示题目题干+图片信息  */
@property (nonatomic, strong) UICollectionView *collectionview;

/** 精解挑刺   tips总结展示界面 */
@property (nonatomic, strong) UIView *show_view;

/** 精解挑刺内容    tips总结内容 */
@property (nonatomic, strong) UITextView *content_textview;

@end

@implementation QuestionAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"解析";
    self.question_index = 0;
    
    [self setBack];
    
    [self setViewUI];
    
    //获取题目解析数据
//<<<<<<< HEAD
    [self look_next_action:YES];
//=======
//    [self look_next_action:NO];
//>>>>>>> 2ee33111534adcaf044fff913e5325f7bb6f7fdf
}

- (void)touchNextButtonAction:(UIButton *)sender {
    [self look_next_action:YES];
}

- (void)setViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[OptionTableViewCell class] forCellReuseIdentifier:@"optionCell"];
    [self.tableview registerClass:[AnalysisTableViewCell class] forCellReuseIdentifier:@"analysisCell"];
    [self.tableview registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    
    //添加下一题按钮  到    Window上
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.backgroundColor = ButtonColor;
    self.nextButton.titleLabel.font = SetFont(14);
    [self.nextButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    ViewRadius(self.nextButton, 25.0);
    [self.nextButton addTarget:self action:@selector(touchNextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-150);
        make.size.mas_equalTo(CGSizeMake(120, 50));
    }];
    self.nextButton.hidden = !self.isShowNextButton;
    
    self.bottom_tool = [[UIView alloc] init];
    self.bottom_tool.backgroundColor = SetColor(238, 238, 238, 1);
    [self.view addSubview:self.bottom_tool];
    [self.bottom_tool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    //添加输入框和表情按钮
    [self setToolBarContent:self.bottom_tool];
}

#pragma mark ---- 评论视图
- (void)setToolBarContent:(UIView *)tool {
    //评论按钮
    UIButton *comment_button = [UIButton buttonWithType:UIButtonTypeCustom];
    comment_button.titleLabel.font = SetFont(14);
    [comment_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [comment_button setTitle:@"评论" forState:UIControlStateNormal];
    [comment_button addTarget:self action:@selector(submitCommentContentAction) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:comment_button];
    [comment_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tool.mas_right).offset(-10);
        make.centerY.equalTo(tool.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    //评论输入框
    self.input_comment_textfield = [[UITextField alloc] init];
    self.input_comment_textfield.backgroundColor = WhiteColor;
    
    self.input_comment_textfield.leftViewMode = UITextFieldViewModeAlways;
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 10, 10)];
    self.input_comment_textfield.leftView = left_label;
    
    self.input_comment_textfield.placeholder = @"写评论";
    ViewRadius(self.input_comment_textfield, 17.0);
    [tool addSubview:self.input_comment_textfield];
    [self.input_comment_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tool.mas_top).offset(8);
        make.left.equalTo(tool.mas_left).offset(20);
        make.bottom.equalTo(tool.mas_bottom).offset(-8);
        make.right.equalTo(comment_button.mas_left).offset(-10);
    }];
    
    //注册按钮通知
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    /* 增加监听（当键盘退出时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.questionModel.commentModelArray.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.questionModel.answerArray.count;
    }else if (section == 1) {
        return 1;
    }else {
        CommentModel *model = self.questionModel.commentModelArray[section - 2];
        return model.cellCommentData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
    }else if (indexPath.section == 1) {
        //精解数据  +  错因标签数据
        AnalysisTableViewCell *analysisCell = [tableView dequeueReusableCellWithIdentifier:@"analysisCell"];
        if (!analysisCell) {
            analysisCell = [[AnalysisTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"analysisCell"];
        }
        analysisCell.delegate = self;
//<<<<<<< HEAD
        analysisCell.question_id = self.analysis_array[self.question_index - 1];
//=======
//        analysisCell.question_id = self.analysis_array[self.question_index];
//>>>>>>> 2ee33111534adcaf044fff913e5325f7bb6f7fdf
        analysisCell.analysis_function_string = self.questionModel.finish_function_string;
        analysisCell.analysisString = self.questionModel.answerAnalysisString;
        analysisCell.stars_score = [self.questionModel.starLevel_stirng floatValue];
        analysisCell.errorTagArry = self.questionModel.errorTagArray;
        analysisCell.correct_answer_string = [self.questionModel.correct_answer_array componentsJoinedByString:@","];
        __weak typeof(self) weakSelf = self;
        analysisCell.touchAnslysisAction = ^{
            weakSelf.isReloadSection = YES;
            [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        };
        analysisCell.AddErrorTagSuccessAction = ^{
            //请求数据
            [weakSelf look_next_action:NO];
            weakSelf.isReloadSection = YES;
        };
        return analysisCell;
    }else {
        //评论数据
        CommentModel *model = self.questionModel.commentModelArray[indexPath.section - 2];
        CommentCellModel *cellModel = model.cellCommentData[indexPath.row];
        CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        if (!commentCell) {
            commentCell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
        }
        commentCell.content_label.text = cellModel.finish_comment_string;
        return commentCell;
    }
}

//将答案的图片 拼接在answerContent 后面
- (NSMutableAttributedString *)returnAnswerContentIndexPath:(AnswerModel *)model {
    NSMutableAttributedString *mutable_string = [[NSMutableAttributedString alloc] initWithString:model.answer_content];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AnswerModel *model = self.questionModel.answerArray[indexPath.row];
        NSString *content = [NSString stringWithFormat:@"%@", [self returnAnswerContentIndexPath:model]];
        CGFloat height = [self calculateRowHeight:content fontSize:14 withWidth:SCREENBOUNDS.width - 90];
        return height > 70.0 ? height : 70.0;
    }else if (indexPath.section == 1) {
        if (self.isReloadSection) {
            return self.questionModel.answerAnalysisString_height + 380 + self.questionModel.finish_function_height + 70;
        }
        return ANALYSIS_FIRST_CELL_HEIGHT;
    }
    CommentModel *model = self.questionModel.commentModelArray[indexPath.section - 2];
    CommentCellModel *cellModel = model.cellCommentData[indexPath.row];
    return cellModel.cell_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.questionModel.questionStringAndImageHeight;
    }else if (section == 1) {
        return 0.0;
    }
    CommentModel *model = self.questionModel.commentModelArray[section - 2];
    return model.header_view_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    }
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header_view = [[UIView alloc] init];
        header_view.backgroundColor = WhiteColor;
        [self setFirstHeaderViewShowToView:header_view];
        return header_view;
    }else if(section == 1) {
        UIView *header_view = [[UIView alloc] init];
        header_view.backgroundColor = WhiteColor;
        [self setFirstHeaderViewShowToView:header_view];
        return header_view;
    }else {
        CommentModel *model = self.questionModel.commentModelArray[section - 2];
        CommentHeaderView *header_view = [[CommentHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, model.header_view_height)];
        [header_view.header_imageview sd_setImageWithURL:[NSURL URLWithString:model.headerURL] placeholderImage:[UIImage imageNamed:@"date"]];
        header_view.name_label.text = model.nickName;
        header_view.date_label.text = model.dateString;
        header_view.content_label.text = model.contentString;
        return header_view;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footer_view = [[UIView alloc] init];
        return footer_view;
    }else if (section == 1) {
        UIView *footer_view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(16);
        label.text = @"评论（18）";
        [footer_view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
        }];
        return footer_view;
    }else {
        CommentModel *model = self.questionModel.commentModelArray[section - 2];
        CommentFooterView *footer_view = [[CommentFooterView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40.0)];
        footer_view.delegate = self;
        footer_view.parise_numbers_string = model.soptString;
        return footer_view;
    }
    
}

//展示题目的题干   图片
- (void)setFirstHeaderViewShowToView:(UIView *)back_view {
    [back_view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------- 评论输入框   相关方法
//键盘出现    实现方法
/**
 *  键盘弹出
 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    self.tableview.scrollEnabled = NO;
}

/**
 *  键盘退出
 */
- (void)keyboardWillHide:(NSNotification *)aNotification  {
    self.tableview.scrollEnabled = YES;
}

//评论视图上的评论按钮
- (void)submitCommentContentAction {
    if ([self.input_comment_textfield.text isEqualToString:@""]) {
        [self showHUDWithTitle:@"请输入评论"];
        return;
    }
    [self showHUD];
    if (self.isSonComment) {
        //代表回复的是子评论
        //题目ID
        NSString *question_id = self.analysis_array[self.question_index];
        //获取父评论的ID
        CommentModel *model = self.questionModel.commentModelArray[self.touchSection];
        NSDictionary *parma = @{
                                @"contingency_id_":question_id,
                                @"content_":self.input_comment_textfield.text,
                                @"sort_":@"2",
                                @"parent_id_":model.comment_id
                                };
        __weak typeof(self) weakSelf = self;
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_comment" Dic:parma SuccessBlock:^(id responseObject) {
            NSLog(@"题目评论 result === %@", responseObject);
            if ([responseObject[@"state"] integerValue] == 1) {
                weakSelf.input_comment_textfield.text = @"";
                [weakSelf.input_comment_textfield resignFirstResponder];
//                [weakSelf showHUDWithTitle:@"评论成功"];
                [weakSelf hidden];
                //重新请求评论数据
                [weakSelf getCommentData];
            }else {
                [weakSelf hidden];
            }
        } FailureBlock:^(id error) {
//            [weakSelf showHUDWithTitle:@"评论失败"];
            [weakSelf hidden];
        }];
        
    }else {
        //题目ID
        NSString *question_id = self.analysis_array[self.question_index];
        NSDictionary *parma = @{
                                @"contingency_id_":question_id,
                                @"content_":self.input_comment_textfield.text,
                                @"sort_":@"2",
                                @"parent_id_":@""
                                };
        __weak typeof(self) weakSelf = self;
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_comment" Dic:parma SuccessBlock:^(id responseObject) {
            NSLog(@"题目评论 result === %@", responseObject);
            if ([responseObject[@"state"] integerValue] == 1) {
                weakSelf.input_comment_textfield.text = @"";
                [weakSelf.input_comment_textfield resignFirstResponder];
//                [weakSelf showHUDWithTitle:@"评论成功"];
                [weakSelf hidden];
                //重新请求评论数据
                [weakSelf getCommentData];
                
            }else {
//                [weakSelf showHUDWithTitle:@"评论失败"];
                [weakSelf hidden];
            }
        } FailureBlock:^(id error) {
//            [weakSelf showHUDWithTitle:@"评论失败"];
            [weakSelf hidden];
        }];
    }
}

//点击某个评论   回复评论   代表的是子评论   需要传入父评论的ID
- (void)touchCommentButtonTargetAction:(NSInteger)section {
    [self.input_comment_textfield becomeFirstResponder];
    self.touchSection = section;
    self.isSonComment = YES;
}

#pragma mark ********** 精解挑刺   添加tips总结  相关方法 *************
/** 点击输入精解挑刺 */
- (void)touchFineSolutionAction {
    [self showViewWithTitle:@"精解挑刺"];
}

/** 点击添加到tips总结 */
- (void)touchSaveToSummarizeBook {
    [self showViewWithTitle:@"添加tips总结"];
}

//精解挑刺   +    tips总结   展示界面
- (void)showViewWithTitle:(NSString *)title {
    [self.show_view removeFromSuperview];
    self.show_view = [[UIView alloc] init];
    self.show_view.backgroundColor = WhiteColor;//SetColor(246, 246, 246, 1);
    [self.view addSubview:self.show_view];
    __weak typeof(self) weakSelf = self;
    [self.show_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(SCREENBOUNDS.height / 2);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = SetColor(74, 74, 74, 1);
    label.text = title;
    [self.show_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.show_view.mas_top).offset(20);
        make.left.equalTo(weakSelf.show_view.mas_left).offset(20);
    }];
    
    UIButton *cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel_button setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.show_view addSubview:cancel_button];
    [cancel_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.show_view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [cancel_button addTarget:self action:@selector(removeShowView) forControlEvents:UIControlEventTouchUpInside];
    
    self.content_textview = [[UITextView alloc] init];
    self.content_textview.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.content_textview.font = SetFont(14);
    self.content_textview.backgroundColor = SetColor(246, 246, 246, 1);
    [self.show_view addSubview:self.content_textview];
    [self.content_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.show_view.mas_left).offset(20);
        make.right.equalTo(weakSelf.show_view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.show_view.mas_bottom).offset(-60);
    }];
    
    UIButton *submit_button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([title isEqualToString:@"精解挑刺"]) {
        submit_button.tag = 1000;
    }else {
        submit_button.tag = 2000;
    }
    submit_button.backgroundColor = ButtonColor;
    [submit_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [submit_button setTitle:@"提交" forState:UIControlStateNormal];
    ViewRadius(submit_button, 8.0);
    [self.show_view addSubview:submit_button];
    [submit_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.content_textview.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.show_view.mas_left).offset(40);
        make.right.equalTo(weakSelf.show_view.mas_right).offset(-40);
        make.height.mas_equalTo(40.0);
    }];
    [submit_button addTarget:self action:@selector(submitDataWithType:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitDataWithType:(UIButton *)sender {
    [self showHUD];
    //题目ID
    NSString *question_id = self.analysis_array[self.question_index];
    __weak typeof(self) weakSelf = self;
    [self.show_view removeFromSuperview];
    if (sender.tag == 1000) {
        //精解挑刺
        NSDictionary *param = @{@"question_choice_id_":question_id,@"content_":self.content_textview.text};
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_user_prick" Dic:param SuccessBlock:^(id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1) {
                [weakSelf hidden];
            }else {
                [weakSelf hidden];
            }
        } FailureBlock:^(id error) {
            [weakSelf hidden];
        }];
    }else {
        //tips总结
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[question_id] options:kNilOptions error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *param = @{@"content_":self.content_textview.text,@"question_id_":jsonString,@"type_":@"1"};
        [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_tips_total" Dic:param imageArray:@[] SuccessBlock:^(id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1) {
                NSLog(@"tips 上传完成！！！");
                [weakSelf.show_view removeFromSuperview];
                [weakSelf hidden];
            }else {
                NSLog(@"tips 上传失败！！！");
                [weakSelf hidden];
            }
        } FailureBlock:^(id error) {
            [weakSelf hidden];
        }];
        
    }
}

//移除展示视图
- (void)removeShowView {
    [self.show_view removeFromSuperview];
}

#pragma mark ------ 根据题目ID请求数据 + 下一题Action
- (void)look_next_action:(BOOL)isNext {
    [self showHUD];
    self.isReloadSection = NO;
    if (self.question_index > self.analysis_array.count - 1) {
        [self showHUDWithTitle:@"已经是最后一题了！"];
        return;
    }
    NSString *question_id = self.analysis_array[self.question_index];
    NSDictionary *parma = @{@"id_":question_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_choice/parsing" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"analysis  data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf format_data:(NSDictionary *)responseObject[@"data"]];
//            [weakSelf hidden];
            //获取评论数据
            [weakSelf getCommentData];
        }
        [weakSelf hidden];
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
    
    if (isNext) {
        //在最后question_index + 1   确保进入下一题
        self.question_index++;
    }
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
    //正确选项数组
    NSMutableArray *correct_answer = [NSMutableArray arrayWithCapacity:1];
    for (int index = 0; index < [data_dic[@"tp_options_result"] count]; index++) {
        NSDictionary *answer_dic = data_dic[@"tp_options_result"][index];
        AnswerModel *model = [[AnswerModel alloc] init];
        model.answer_id = @"";
        model.answer_content_image = answer_dic[@"question_picture_id_"];
        model.answer_content = answer_dic[@"content_"];
        model.isCorrect = [NSString stringWithFormat:@"%ld", [answer_dic[@"answer_"] integerValue]];
        if ([model.isCorrect isEqualToString:@"1"]) {
            [correct_answer addObject:@[@"A",@"B",@"C",@"D"][index]];
        }
        [answer addObject:model];
    }
    self.questionModel.answerArray = [answer copy];
    self.questionModel.correct_answer_array = [correct_answer copy];
    
    //解析
    self.questionModel.answerAnalysisString = data_dic[@"parsing_"];
    
    //错因标签数据
    self.questionModel.error_label_list = data_dic[@"error_label_list_"];
    
    [self.collectionview reloadData];
    [self.tableview reloadData];
}

//通过接口获取评论数据
- (void)getCommentData {
    if (self.question_index > self.analysis_array.count - 1) {
        [self showHUDWithTitle:@"已经是最后一题了！"];
        return;
    }
    //题目ID
    NSString *question_id = self.analysis_array[self.question_index];
    NSDictionary *parma = @{@"contingency_id_":question_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_question_comment" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"评论数据 === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            //评论数据
            NSMutableArray *commentArray = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *sectionDic in responseObject[@"data"]) {
                CommentModel *model = [[CommentModel alloc] init];
                model.comment_id = sectionDic[@"id_"];
                model.headerURL = sectionDic[@"picture_"];
                model.nickName = [sectionDic[@"name_"] isEqualToString:@""] ? @"15158874572" : sectionDic[@"name_"];
                model.tagString = @"初入茅庐";
                NSString *date_string = [KPDateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%ld", [sectionDic[@"create_time_"] integerValue]] withFormatStr:@"yyyy-MM-dd"];
                model.dateString = date_string;//sectionDic[@"create_time_"];
                model.contentString = sectionDic[@"content_"];
                //点赞数量
                model.soptString = @"200";
                //子评论数据
                NSMutableArray *cell_comment_array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *cellDic in sectionDic[@"son_comment_result_"]) {
                    CommentCellModel *cellModel = [[CommentCellModel alloc] init];
                    cellModel.cell_comment_id = cellDic[@"id_"];
                    cellModel.cell_user_name = cellDic[@"name_"];
                    cellModel.cell_parent_name = cellDic[@"parent_name_"];
                    cellModel.cell_comment_content = cellDic[@"content_"];
                    [cell_comment_array addObject:cellModel];
                }
                model.cellCommentData = [cell_comment_array copy];
                [commentArray addObject:model];
            }
            weakSelf.questionModel.commentModelArray = [commentArray copy];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

#pragma mark ----- 懒加载
- (UICollectionView *)collectionview {
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.minimumLineSpacing = 20.0;
        layout.minimumInteritemSpacing = 20.0;
        CGFloat width = (SCREENBOUNDS.width - 100) / 4;
        layout.itemSize = CGSizeMake(width, width);
        
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.backgroundColor = WhiteColor;
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        [_collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader"];
        [_collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionview;
}

//展示题目的题干  图片
#pragma mark --- collectionview delegate datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.questionModel.question_image_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *image_url = self.questionModel.question_image_array[indexPath.row];
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"no_image"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENBOUNDS.width, self.questionModel.questionStringHeight + 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
    for (UIView *vv in header_view.subviews) {
        [vv removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = SetColor(74, 74, 74, 1);
    label.numberOfLines = 0;
    label.text = self.questionModel.questionString;
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(10, 20, 0, 20));
    }];
    return header_view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self removeShowView];
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
