//
//  StartViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "StartViewController.h"
#import "DoExerciseViewController.h"

@interface StartViewController ()

/**
 试卷数据
 */
@property (nonatomic, strong) NSDictionary *exam_data;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation StartViewController

//获取题目列表
- (void)getTestListData {
    if (!self.information_id) {
        [self showHUDWithTitle:@"没有试卷ID！！！！！"];
        return;
    }
    
    NSDictionary *parme = @{@"exam_id":self.information_id};
    NSLog(@"试卷ID ==== %@", self.information_id);
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_true_topic_details" Dic:parme SuccessBlock:^(id responseObject) {
        NSLog(@"question_data === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf hidden];
            weakSelf.contentLabel.text = responseObject[@"data"][@"describe_"];
            weakSelf.exam_data = responseObject[@"data"];
            
//            if (weakSelf.type == QuestionType_Basics) {
//                //基础能力训练
//                DoExerciseViewController *exercise = [[DoExerciseViewController alloc] init];
//                exercise.question_data = responseObject[@"data"];
//                [weakSelf.navigationController pushViewController:exercise animated:YES];
//
//            }else if (weakSelf.type == QuestionType_Function) {
//                //解题方法训练
//                DoExerciseViewController *exercise = [[DoExerciseViewController alloc] init];
//                exercise.question_data = responseObject[@"data"];
//                [weakSelf.navigationController pushViewController:exercise animated:YES];
//
//            }else if (weakSelf.type == QuestionType_Bank) {
//                DoExerciseViewController *exercise = [[DoExerciseViewController alloc] init];
//                exercise.question_data = responseObject[@"data"];
//                [weakSelf.navigationController pushViewController:exercise animated:YES];
//            }
        }
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    // Do any additional setup after loading the view.
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"starts_view"];
    [self.view addSubview:imageV];
    __weak typeof(self) weakSelf = self;
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(200);
    }];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.font = SetFont(32);
    titleLable.text = @"思维反应训练特训";
    [self.view addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = SetFont(16);
    self.contentLabel.textColor = DetailTextColor;
    self.contentLabel.numberOfLines = 0;
//    self.contentLabel.text = @"简介+方法来源+能力养成来源简介+方法来源+能力养成来源简介+方法来源+能力养成来源简介+方法来源+能力养成来源简介+方法来源+能力养成来源";
    [self.view addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLable.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(30);
        make.right.equalTo(weakSelf.view.mas_right).offset(-30);
    }];
    
    UILabel *messageLable = [[UILabel alloc] init];
    messageLable.font = SetFont(14);
    messageLable.textColor = DetailTextColor;
    messageLable.text = @"检测到有历史未完成答题记录";
    [self.view addSubview:messageLable];
    [messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(44);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    messageLable.hidden = YES;
    
    UIButton *continuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continuButton setTitle:@"继续上次训练" forState:UIControlStateNormal];
    [continuButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    continuButton.backgroundColor = SetColor(36, 111, 245, 1);
    ViewRadius(continuButton, 19.0);
    [self.view addSubview:continuButton];
    [continuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLable.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
        make.height.mas_equalTo(38);
    }];
    continuButton.hidden = YES;
    
    UILabel *numberLable = [[UILabel alloc] init];
    numberLable.font = SetFont(12);
    numberLable.textColor = DetailTextColor;
    numberLable.text = @"3223人已通过";
    [self.view addSubview:numberLable];
    [numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:@"立即开始" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    startButton.backgroundColor = WhiteColor;
    ViewBorderRadius(startButton, 19.0, 1.0, [UIColor blueColor]);
    [startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(numberLable.mas_top).offset(-10);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
        make.height.mas_equalTo(38);
    }];
    
    
    
    [self getTestListData];
}

//跳转到做题界面
- (void)startAction {
    DoExerciseViewController *exercise = [[DoExerciseViewController alloc] init];
    exercise.question_data = self.exam_data;
    if (self.type == QuestionType_Basics) {
        exercise.type = EXERCISE_TYPE_BASICS;
    }else if (self.type == QuestionType_Function) {
        exercise.type = EXERCISE_TYPE_FUNCTION;
    }else {
        exercise.type = EXERCISE_TYPE_BANK;
    }
    [self.navigationController pushViewController:exercise animated:YES];
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
