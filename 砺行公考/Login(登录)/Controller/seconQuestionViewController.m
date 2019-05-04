//
//  seconQuestionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "seconQuestionViewController.h"
#import "SelectCityViewController.h"

@interface seconQuestionViewController ()

//记录点击过的Button   方便清除
@property (nonatomic, strong) NSMutableArray *selectIndex;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation seconQuestionViewController

- (void)getData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/find_plan_test_list" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"][@"select_list"];
            [self setUI:responseObject[@"data"][@"select_list"]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectIndex = [NSMutableArray arrayWithCapacity:1];
    
    [self setBack];
    
    [self getData];
}

- (void)setUI:(NSArray *)titleArray {
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = SetFont(12);
    NSString *str = @"2/3";
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrDescribeStr addAttribute:NSFontAttributeName value:SetFont(18) range:[str rangeOfString:@"2"]];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[str rangeOfString:@"2"]];
    label.attributedText = attrDescribeStr;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(22);
    label1.text = @"您计划参加的考试有?";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"砺行依据您的目标智能匹配合适的课程体系";
    label2.textColor = SetColor(155, 155, 155, 1);
    label2.font = SetFont(14);
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"(多选)";
    label3.textColor = SetColor(155, 155, 155, 1);
    label3.font = SetFont(14);
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
//    NSArray *titleArr = @[@"国家公务员考试", @"省级公务员考试", @"其它考试"];
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
            make.top.equalTo(label3.mas_bottom).offset(20 + 70 * index);
            make.left.equalTo(weakSelf.view.mas_left).offset(30);
            make.right.equalTo(weakSelf.view.mas_right).offset(-30);
            make.height.mas_equalTo(50);
        }];
    }
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"(指:事业单位,银行,烟草,邮政,三大运营商等等)";
    label4.textColor = SetColor(155, 155, 155, 1);
    label4.font = SetFont(14);
    [self.view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(215);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
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
        if (index == button.tag && ![self.selectIndex containsObject:[NSString stringWithFormat:@"%ld", index]]) {
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button.layer setBorderColor:[UIColor blueColor].CGColor];
            [self.selectIndex addObject:[NSString stringWithFormat:@"%ld", index]];
        }else if(index == button.tag && [self.selectIndex containsObject:[NSString stringWithFormat:@"%ld", index]]) {
            [button setTitleColor:SetColor(155, 155, 155, 1) forState:UIControlStateNormal];
            [button.layer setBorderColor:SetColor(224, 224, 224, 1).CGColor];
            [self.selectIndex removeObject:[NSString stringWithFormat:@"%ld", index]];
        }
    }
}

//跳转选择省份
- (void)touchPush {
    //将选择的index  转成后台想要的数据
    NSMutableArray *serial_array = [NSMutableArray arrayWithCapacity:1];
    for (NSString *index_string in self.selectIndex) {
        NSInteger index = [index_string integerValue];
        [serial_array addObject:self.dataArray[index-200][@"serial_number_"]];
    }
    
    NSDictionary *parma = @{@"serial_number_list_":[serial_array copy]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/insert_plan_test" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"上传成功！！！！");
            SelectCityViewController *select = [[SelectCityViewController alloc] init];
            [weakSelf.navigationController pushViewController:select animated:YES];
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
