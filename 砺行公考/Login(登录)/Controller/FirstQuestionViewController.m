//
//  FirstQuestionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "FirstQuestionViewController.h"
#import "seconQuestionViewController.h"

@interface FirstQuestionViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger current_button_index;

@end

@implementation FirstQuestionViewController

- (void)getData {
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/find_current_state_list" Dic:@{} SuccessBlock:^(id responseObject) {
        __weak typeof(self) weakSelf = self;
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"][@"select_list"];
            [weakSelf setUI:responseObject[@"data"][@"select_list"]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.current_button_index = -1;
    
    [self getData];
}

- (void)setUI:(NSArray *)titleArray {
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = SetFont(12);
    NSString *str = @"1/3";
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrDescribeStr addAttribute:NSFontAttributeName value:SetFont(18) range:[str rangeOfString:@"1"]];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[str rangeOfString:@"1"]];
    label.attributedText = attrDescribeStr;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(22);
    label1.text = @"您目前的状态是?";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"砺行依据不同阶段特点分别安排训练计划";
    label2.textColor = SetColor(155, 155, 155, 1);
    label2.font = SetFont(14);
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
//    NSArray *titleArr = @[@"大一,大二", @"大三", @"大四", @"已毕业,在职兼顾备考", @"已毕业,脱产全心备考"];
    for (NSInteger index = 0; index < titleArray.count; index++) {
        NSDictionary *dic = titleArray[index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index + 200;
        [button setTitle:dic[@"content_"] forState:UIControlStateNormal];
        ViewBorderRadius(button, 25.0, 0.5, SetColor(224, 224, 224, 1));
        button.titleLabel.font = SetFont(16);
        [button setTitleColor:SetColor(155, 155, 155, 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2.mas_bottom).offset(20 + 70 * index);
            make.left.equalTo(weakSelf.view.mas_left).offset(30);
            make.right.equalTo(weakSelf.view.mas_right).offset(-30);
            make.height.mas_equalTo(50);
        }];
    }
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    next.tag = 100;
    next.backgroundColor = [UIColor grayColor];
    ViewRadius(next, 25.0);
    [next addTarget:self action:@selector(touchNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30);
        make.height.mas_equalTo(50);
    }];
    
}

//选择
- (void)touchButton:(UIButton *)sender {
    NSInteger index = sender.tag;
    for (UIButton *button in self.view.subviews) {
        if (button.class != UIButton.class || button.tag == 100) {
            continue;
        }
        if (index == button.tag) {
            self.current_button_index = index;
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button.layer setBorderColor:[UIColor blueColor].CGColor];
        }else {
            [button setTitleColor:SetColor(155, 155, 155, 1) forState:UIControlStateNormal];
            [button.layer setBorderColor:SetColor(224, 224, 224, 1).CGColor];
        }
    }
}

//跳转第二题
- (void)touchNext {
    if (self.current_button_index == -1) {
        [self showHUDWithTitle:@"请先选择您的当前状态"];
        return;
    }else {
        NSString *serial_id = self.dataArray[self.current_button_index - 200][@"serial_number_"];
        //上传数据
        [self submitDataToService:serial_id];
    }
}

- (void)submitDataToService:(NSString *)serial_id {
    NSDictionary *parma = @{@"serial_number_list_":@[serial_id]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/insert_current_state" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"上传状态成功");
            seconQuestionViewController *second = [[seconQuestionViewController alloc] init];
            [weakSelf.navigationController pushViewController:second animated:YES];
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
