//
//  QuanZhenTestsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/2.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "QuanZhenTestsViewController.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "QuanZhenTestModel.h"
#import "BottomShowMaterialsView.h"
#import "CustomTitleView.h"
#import "QuanZhenAnalysisViewController.h"

@interface QuanZhenTestsViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *top_scroll;

@property (nonatomic, strong) UILabel *test_content_label;

//要求
@property (nonatomic, strong) UILabel *require_content_label;

@property (nonatomic, strong) UILabel *my_answer_label;

@property (nonatomic, strong) UITextView *my_answer_content_textview;

@property (nonatomic, strong) UIButton *save_button;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger current_question_index;

@property (nonatomic, strong) BottomShowMaterialsView *showV;

/** 全真申论题目id数组 */
@property (nonatomic, strong) NSArray *essayTest_ids_array;

@end

@implementation QuanZhenTestsViewController

- (void)getQuanZhenData {
    NSDictionary *parma = @{@"exam_id":self.information_id};
    __weak typeof(self) weakSelf = self;
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *ids_array = [NSMutableArray arrayWithCapacity:1];
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_essay" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"shen lun  quan  zhen === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *dic in responseObject[@"data"][@"require_result_"]) {
                QuanZhenTestModel *model = [[QuanZhenTestModel alloc] init];
                model.test_id = dic[@"id_"];
                model.test_content_string = dic[@"title_"] ?: @"题干题干题干题干题干题干题干题干";
                model.require_content_array = dic[@"content_list_"];
                model.answer_content_string = [dic[@"user_answer_"] isEqualToString:@""] ? @"在此输入答案" : dic[@"user_answer_"];
                //全真题目材料数据
                NSMutableArray *materials_array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *materialsDic in dic[@"material_result_"]) {
                    EssayTestQuanZhenMaterialsModel *materialsModel = [[EssayTestQuanZhenMaterialsModel alloc] init];
                    materialsModel.materials_id = materialsDic[@"id_"];
                    materialsModel.materials_content = materialsDic[@"content_"];
                    materialsModel.materials_image_array = materialsDic[@"material_picture_list_"];
                    [materials_array addObject:materialsModel];
                }
                model.materials_array = [materials_array copy];
                [data addObject:model];
                [ids_array addObject:model.test_id];
            }
            weakSelf.dataArray = [data copy];
            weakSelf.essayTest_ids_array = [ids_array copy];
            //设置第一个题目数据
            [weakSelf setScrollViewContent];
            QuanZhenTestModel *model = weakSelf.dataArray[0];
            weakSelf.test_content_label.text = model.test_content_string;
            weakSelf.require_content_label.text = model.require_finish_string;
            weakSelf.my_answer_content_textview.text = model.answer_content_string;
        }
    } FailureBlock:^(id error) {
        
    }];
}

/**
 设置题目标题数据
 */
- (void)setScrollViewContent {
    CGFloat width = (SCREENBOUNDS.width - 20 * 6) / 5;
    for (NSInteger index = 0; index < self.dataArray.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = FRAME(20 + index * (width + 20), 10, width, 40);
        button.titleLabel.font = SetFont(14);
        button.backgroundColor = SetColor(246, 246, 246, 1);
        [button setTitleColor:DetailTextColor forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"题目%ld", index+1] forState:UIControlStateNormal];
        button.tag = index;
        ViewRadius(button, 8.0);
        [button addTarget:self action:@selector(touchButtonChangeQuestion:) forControlEvents:UIControlEventTouchUpInside];
        [self.top_scroll addSubview:button];
        if (index == 0) {
            button.backgroundColor = ButtonColor;
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }
    self.top_scroll.contentSize = CGSizeMake(width * self.dataArray.count, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.current_question_index = 0;
    
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"交卷" target:self action:@selector(submitTestAndAnswer)];
    
    self.navigationItem.titleView.userInteractionEnabled = YES;
    CustomTitleView *titleV = [[CustomTitleView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width - 50, 40)];
    titleV.backgroundColor = WhiteColor;
    titleV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleV.intrinsicContentSize = CGSizeMake(SCREENBOUNDS.width - 50, 40.0);
    
    UIButton *showMaterialsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showMaterialsButton.backgroundColor = ButtonColor;
    [showMaterialsButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [showMaterialsButton setTitle:@"显示材料" forState:UIControlStateNormal];
    ViewRadius(showMaterialsButton, 5.0);
    [showMaterialsButton addTarget:self action:@selector(showMaterialsView) forControlEvents:UIControlEventTouchUpInside];
    [titleV addSubview:showMaterialsButton];
    [showMaterialsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleV.mas_centerY);
        make.centerX.equalTo(titleV.mas_centerX);
        make.width.mas_equalTo(SCREENBOUNDS.width / 3 * 2 - 20);
        make.height.mas_equalTo(24);
    }];
    
    self.navigationItem.titleView = titleV;
    
    [self initViewUI];
    
    [self getQuanZhenData];
}

- (void)initViewUI {
    self.top_scroll = [[UIScrollView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 60)];
    [self.view addSubview:self.top_scroll];
    
    self.test_content_label = [[UILabel alloc] init];
    self.test_content_label.font = SetFont(16);
    self.test_content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.test_content_label.numberOfLines = 0;
    [self.view addSubview:self.test_content_label];
    __weak typeof(self) weakSelf = self;
    [self.test_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top_scroll.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
    }];
    
    self.require_content_label = [[UILabel alloc] init];
    self.require_content_label.font = SetFont(14);
    self.require_content_label.textColor = DetailTextColor;
    self.require_content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.require_content_label.numberOfLines = 0;
    [self.view addSubview:self.require_content_label];
    [self.require_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.test_content_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.require_content_label.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    self.my_answer_label = [[UILabel alloc] init];
    self.my_answer_label.font = SetFont(14);
    self.my_answer_label.textColor = DetailTextColor;
    self.my_answer_label.text = @"我的答案";
    [self.view addSubview:self.my_answer_label];
    [self.my_answer_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.require_content_label.mas_left);
    }];
    
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(back_view, 5.0);
    [self.view addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.my_answer_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-90);
    }];
    
    self.my_answer_content_textview = [[UITextView alloc] init];
    self.my_answer_content_textview.backgroundColor = SetColor(246, 246, 246, 1);
    self.my_answer_content_textview.delegate = self;
    self.my_answer_content_textview.font = SetFont(14);
    self.my_answer_content_textview.textColor = SetColor(191, 191, 191, 1);
    [self.view addSubview:self.my_answer_content_textview];
    [self.my_answer_content_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    self.save_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.save_button.backgroundColor = ButtonColor;
    self.save_button.titleLabel.font = SetFont(18);
    [self.save_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.save_button setTitle:@"保存" forState:UIControlStateNormal];
    ViewRadius(self.save_button, 25.0);
    [self.save_button addTarget:self action:@selector(touchSaveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.save_button];
    [self.save_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
    }];
}

- (void)showMaterialsView {
    QuanZhenTestModel *model = self.dataArray[self.current_question_index];
    self.showV.dataArray = model.materials_array;
    [self.view addSubview:self.showV];
}

//交卷
- (void)submitTestAndAnswer {
    NSMutableArray *answer_array = [NSMutableArray arrayWithCapacity:1];
    BOOL isFinish = NO;
    for (QuanZhenTestModel *model in self.dataArray) {
        
        //判断是否至少有一题作答
        if ([model.answer_content_string isEqualToString:@"在此输入答案"]) {
            isFinish = NO;
        }else {
            isFinish = YES;
        }
        
        NSDictionary *dic = @{
                              @"id_" : model.test_id,
                              @"content_" : [model.answer_content_string isEqualToString:@"在此输入答案"] ? @"" : model.answer_content_string
                              };
        [answer_array addObject:dic];
    }
    
    
    if (!isFinish) {
        [self showHUDWithTitle:@"未作答一题，不能交卷"];
        return;
    }
    
    NSDictionary *parma = @{@"require_answer_list":[answer_array copy]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_user_answer" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"quanzhen answer result == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            //查看解析
            [weakSelf lookEssayTestAnalysis];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//切换题目
- (void)touchButtonChangeQuestion:(UIButton *)sender {
    for (UIButton *button in self.top_scroll.subviews) {
        if (![button isKindOfClass:[UIButton class]]) {
            continue;
        }
        if (button.tag == sender.tag) {
            button.backgroundColor = ButtonColor;
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            QuanZhenTestModel *model = self.dataArray[sender.tag];
            self.test_content_label.text = model.test_content_string;
            self.require_content_label.text = model.require_finish_string;
            self.my_answer_content_textview.text = model.answer_content_string;
            self.current_question_index = sender.tag;
        }else {
            button.backgroundColor = SetColor(246, 246, 246, 1);
            [button setTitleColor:DetailTextColor forState:UIControlStateNormal];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

//保存答案
- (void)touchSaveButtonAction {
    QuanZhenTestModel *model = self.dataArray[self.current_question_index];
    model.answer_content_string = self.my_answer_content_textview.text;
    [self showHUDWithTitle:@"保存成功"];
}

//跳转查看申论题解析
- (void)lookEssayTestAnalysis {
    QuanZhenAnalysisViewController *analysis = [[QuanZhenAnalysisViewController alloc] init];
    analysis.dataArray = self.essayTest_ids_array;
    [self.navigationController pushViewController:analysis animated:YES];
}

#pragma mark ---- 懒加载
- (BottomShowMaterialsView *)showV {
    if (!_showV) {
        _showV = [[BottomShowMaterialsView alloc] initWithFrame:self.view.bounds];
    }
    return _showV;
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
