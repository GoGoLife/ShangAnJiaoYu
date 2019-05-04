//
//  ThreeQuestionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/2.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ThreeQuestionViewController.h"
#import "RecommendViewController.h"

@interface ThreeQuestionViewController ()

//记录点击过的Button   方便清除
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ThreeQuestionViewController

- (void)getData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/find_readiness_situation_list" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"][@"select_list"];
            [weakSelf setUI:weakSelf.dataArray];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectIndex = -1;
    [self setBack];
    
    [self getData];
    
}

- (void)setUI:(NSArray *)titleArray {
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = SetFont(12);
    NSString *str = @"3/3";
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrDescribeStr addAttribute:NSFontAttributeName value:SetFont(18) range:[str rangeOfString:@"3"]];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[str rangeOfString:@"3"]];
    label.attributedText = attrDescribeStr;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(22);
    label1.text = @"您目前的准备情况是?";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"了解您的备考情况有助于";
    label2.textColor = SetColor(155, 155, 155, 1);
    label2.font = SetFont(14);
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"砺行一开始就为您推荐更佳针对性的课程";
    label3.textColor = SetColor(155, 155, 155, 1);
    label3.font = SetFont(14);
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
//    NSArray *titleArr = @[@"零基础", @"有一定基础", @"冲刺高峰"];
//    NSArray *labelText = @[@"(从未了解,了解较少,希望重头系统学习)", @"(有一定练习基础或报班经验,但是尚不满意自己的程度)", @"(对自己的基础很有信心,为了冲刺高分来做联系)"];
    for (NSInteger index = 0; index < titleArray.count; index++) {
        NSDictionary *dic = self.dataArray[index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index + 200;
        [button setTitle:dic[@"content_"] forState:UIControlStateNormal];
        ViewBorderRadius(button, 25.0, 0.5, SetColor(224, 224, 224, 1));
        button.titleLabel.font = SetFont(16);
        [button setTitleColor:SetColor(155, 155, 155, 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label3.mas_bottom).offset(20 + 90 * index);
            make.left.equalTo(weakSelf.view.mas_left).offset(30);
            make.right.equalTo(weakSelf.view.mas_right).offset(-30);
            make.height.mas_equalTo(50);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = SetFont(12);
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.text = dic[@"content_"];
        [self.view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(5);
            make.centerX.equalTo(weakSelf.view.mas_centerX);
        }];
        
        
    }
    
//    UILabel *label4 = [[UILabel alloc] init];
//    label4.text = @"(指:事业单位,银行,烟草,邮政,三大运营商等等)";
//    label4.textColor = SetColor(155, 155, 155, 1);
//    label4.font = SetFont(14);
//    [self.view addSubview:label4];
//    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(label3.mas_bottom).offset(215);
//        make.centerX.equalTo(weakSelf.view.mas_centerX);
//    }];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    next.tag = 100;
    next.backgroundColor = [UIColor grayColor];
    ViewRadius(next, 25.0);
    [next addTarget:self action:@selector(touchPush) forControlEvents:UIControlEventTouchUpInside];
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
            self.selectIndex = index - 200;
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button.layer setBorderColor:[UIColor blueColor].CGColor];
        }else {
            [button setTitleColor:SetColor(155, 155, 155, 1) forState:UIControlStateNormal];
            [button.layer setBorderColor:SetColor(224, 224, 224, 1).CGColor];
        }
    }
}

//跳转推荐课程
- (void)touchPush {
    if (self.selectIndex == -1) {
        [self showHUDWithTitle:@"请先选择"];
        return;
    }
    NSString *serial_string = self.dataArray[self.selectIndex][@"serial_number_"];
    NSDictionary *parma = @{@"serial_number_list_":@[serial_string]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/insert_readiness_situation" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"上传成功");
            RecommendViewController *recommend = [[RecommendViewController alloc] init];
            [weakSelf.navigationController pushViewController:recommend animated:YES];
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
