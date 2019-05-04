//
//  OptionalSolveViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/13.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "OptionalSolveViewController.h"
#import "OptionalSettingViewController.h"
#import "DoExerciseViewController.h"
#import "DrillHistoryViewController.h"

@interface OptionalSolveViewController ()

/** 用户自选的设置 */
@property (nonatomic, strong) NSArray *user_select_data;

@end

@implementation OptionalSolveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"自选设置" style:UIBarButtonItemStyleDone target:self action:@selector(optionSetting)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self setViewUI];
}

- (void)setViewUI {
    __weak typeof(self) weakSelf = self;
    UIImageView *topImage = [[UIImageView alloc] init];
    topImage.image = [UIImage imageNamed:@"option-6"];
    [self.view addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(180);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = SetFont(32);
    titleLabel.text = @"我的自选题库";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.mas_bottom).offset(40);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.textColor = DetailTextColor;
    label.text = @"该自选题库包含：";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.centerX.equalTo(titleLabel.mas_centerX);
    }];
    
    CGFloat optional_width = SCREENBOUNDS.width / 2;
    UILabel *optional1 = [[UILabel alloc] init];
    optional1.font = SetFont(16);
    optional1.textColor = DetailTextColor;
    optional1.textAlignment = NSTextAlignmentCenter;
    optional1.text = @"言语理解：10题";
    [self.view addSubview:optional1];
    [optional1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.width.mas_equalTo(optional_width);
    }];
    
    UILabel *optional2 = [[UILabel alloc] init];
    optional2.font = SetFont(16);
    optional2.textColor = DetailTextColor;
    optional2.textAlignment = NSTextAlignmentCenter;
    optional2.text = @"逻辑判断：10题";
    [self.view addSubview:optional2];
    [optional2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(optional1.mas_top).offset(0);
        make.left.equalTo(optional1.mas_right);
        make.width.mas_equalTo(optional_width);
    }];
    
    UILabel *optional3 = [[UILabel alloc] init];
    optional3.font = SetFont(16);
    optional3.textColor = DetailTextColor;
    optional3.textAlignment = NSTextAlignmentCenter;
    optional3.text = @"常识理论：10题";
    [self.view addSubview:optional3];
    [optional3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(optional1.mas_bottom).offset(0);
        make.left.equalTo(optional1.mas_left);
        make.width.mas_equalTo(optional_width);
    }];

    UILabel *optional4 = [[UILabel alloc] init];
    optional4.font = SetFont(16);
    optional4.textColor = DetailTextColor;
    optional4.textAlignment = NSTextAlignmentCenter;
    optional4.text = @"资料分析：10题";
    [self.view addSubview:optional4];
    [optional4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(optional2.mas_bottom).offset(0);
        make.left.equalTo(optional2.mas_left);
        make.width.mas_equalTo(optional_width);
    }];

    UILabel *optional5 = [[UILabel alloc] init];
    optional5.font = SetFont(16);
    optional5.textColor = DetailTextColor;
    optional5.textAlignment = NSTextAlignmentCenter;
    optional5.text = @"数量关系：10题";
    [self.view addSubview:optional5];
    [optional5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(optional3.mas_bottom).offset(0);
        make.left.equalTo(optional3.mas_left);
        make.width.mas_equalTo(optional_width);
    }];
    
    //什么是自选题库
    UILabel *lookDetails = [[UILabel alloc] init];
    lookDetails.font = SetFont(12);
    lookDetails.textColor = DetailTextColor;
    lookDetails.text = @"什么是自选题库";
    [self.view addSubview:lookDetails];
    [lookDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_bottom).offset(-30);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    lookDetails.hidden = YES;
    
    //查看训练历史
    UIButton *lookHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookHistoryButton setTitle:@"查看训练历史" forState:UIControlStateNormal];
    [lookHistoryButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    lookHistoryButton.backgroundColor = WhiteColor;
    ViewBorderRadius(lookHistoryButton, 25.0, 1.0, [UIColor blueColor]);
    [lookHistoryButton addTarget:self action:@selector(lookHistoryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lookHistoryButton];
    [lookHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lookDetails.mas_top).offset(-10);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
        make.height.mas_equalTo(50);
    }];
    lookHistoryButton.hidden = YES;
    
    //立即开始
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:@"立即开始" forState:UIControlStateNormal];
    [startButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    startButton.backgroundColor = SetColor(36, 111, 245, 1);
    ViewRadius(startButton, 25.0);
    [startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lookHistoryButton.mas_top).offset(-10);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
        make.height.mas_equalTo(50);
    }];
}

//自选设置跳转
- (void)optionSetting {
    OptionalSettingViewController *setting = [[OptionalSettingViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    setting.returnUserSelectSetting = ^(NSArray *array) {
        weakSelf.user_select_data = array;
    };
    [self.navigationController pushViewController:setting animated:YES];
}

//开始做题
- (void)startButtonAction {
    if (!self.user_select_data) {
//        [self showHUDWithTitle:@"请选择自定义题目"];
        return;
    }
    
    [self getOptionalHttpData:self.user_select_data];
}

//查看训练历史
- (void)lookHistoryAction {
    DrillHistoryViewController *history = [[DrillHistoryViewController alloc] init];
    [self.navigationController pushViewController:history animated:YES];
}

- (void)getOptionalHttpData:(NSArray *)array {
    NSDictionary *parma = @{
                            @"choice_serial_list": array[0],
                            @"method_list": array[1],
                            @"source":array[2]
                            };
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/optional_choice_list" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf hidden];
            DoExerciseViewController *exercise = [[DoExerciseViewController alloc] init];
            exercise.type = EXERCISE_TYPE_OPTIONAL;
            exercise.question_data = responseObject[@"data"];
            [weakSelf.navigationController pushViewController:exercise animated:YES];
        }
    } FailureBlock:^(id error) {
        
    }];
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
