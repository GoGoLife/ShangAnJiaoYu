//
//  BigFour_compareViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BigFour_compareViewController.h"
#import "BigFour_AnalyzeViewController.h"

@interface BigFour_compareViewController ()

@property (nonatomic, strong) UIScrollView *scroll;

@end

@implementation BigFour_compareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    __weak typeof(self) weakSelf = self;
    // Do any additional setup after loading the view.
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    
    
    self.scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scroll];
    
    NSString *content_string = self.seleted_bast_yinyan;
    CGFloat height = [self calculateRowHeight:content_string fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    
    //承载视图
    UIView *back_view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, height + 600)];
    back_view.backgroundColor = WhiteColor;
    [self.scroll addSubview:back_view];
    self.scroll.contentSize = CGSizeMake(0, back_view.frame.size.height);
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    label.text = @"第四步：布局总括-引言";
    [back_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(10);
        make.centerX.equalTo(back_view.mas_centerX);
    }];
    
    UILabel *system_label = [[UILabel alloc] init];
    system_label.font = SetFont(14);
    system_label.textColor = DetailTextColor;
    system_label.text = @"系统最佳引言段";
    [back_view addSubview:system_label];
    [system_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UILabel *system_label1 = [[UILabel alloc] init];
    system_label1.textColor = ButtonColor;
    system_label1.font = SetFont(14);
    system_label1.text = @"【最佳标题】";
    [back_view addSubview:system_label1];
    [system_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(system_label.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UILabel *system_label2 = [[UILabel alloc] init];
    system_label2.font = SetFont(14);
    system_label2.textColor = SetColor(74, 74, 74, 1);
    system_label2.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_bast_title"];
    [back_view addSubview:system_label2];
    [system_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(system_label1.mas_bottom).offset(10);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UILabel *system_label3 = [[UILabel alloc] init];
    system_label3.textColor = ButtonColor;
    system_label3.font = SetFont(14);
    system_label3.text = @"【最佳引言段】";
    [back_view addSubview:system_label3];
    [system_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(system_label2.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UILabel *system_label4 = [[UILabel alloc] init];
    system_label4.font = SetFont(14);
    system_label4.textColor = SetColor(74, 74, 74, 1);
    system_label4.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    system_label4.numberOfLines = 0;
    system_label4.text = content_string;
    [back_view addSubview:system_label4];
    [system_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(system_label3.mas_bottom).offset(10);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.height.mas_equalTo(height);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [back_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(system_label4.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left);
        make.right.equalTo(back_view.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(14);
    label1.textColor = DetailTextColor;
    label1.text = @"根据自己的标题，对比模板修改引言段";
    [back_view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UILabel *my_label = [[UILabel alloc] init];
    my_label.font = SetFont(14);
    my_label.textColor = DetailTextColor;
    my_label.text = @"我的标题";
    [back_view addSubview:my_label];
    [my_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UILabel *my_label1 = [[UILabel alloc] init];
    my_label1.backgroundColor = SetColor(246, 246, 246, 1);
    my_label1.font = SetFont(14);
    ViewRadius(my_label1, 8.0);
    my_label1.text = [[NSUserDefaults standardUserDefaults] objectForKey:BigEssayTests_my_title];//@"哈分类点击分类数据发逻辑撒";
    [back_view addSubview:my_label1];
    [my_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(my_label.mas_bottom).offset(10);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *my_label2 = [[UILabel alloc] init];
    my_label2.font = SetFont(14);
    my_label2.textColor = DetailTextColor;
    my_label2.text = @"引言";
    [back_view addSubview:my_label2];
    [my_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(my_label1.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UITextView *my_label3 = [[UITextView alloc] init];
    my_label3.backgroundColor = SetColor(246, 246, 246, 1);
    my_label3.font = SetFont(14);
    ViewRadius(my_label3, 8.0);
    NSString *yinyan_string = [NSString stringWithContentsOfFile:YinYan_data_file encoding:NSUTF8StringEncoding error:nil];
    my_label3.text = yinyan_string;
    [back_view addSubview:my_label3];
    [my_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(my_label2.mas_bottom).offset(10);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.height.mas_equalTo(150);
    }];
}

- (void)nextAction {
    //对比完成以后跳转到填写分析总括句页面
    BigFour_AnalyzeViewController *analyze = [[BigFour_AnalyzeViewController alloc] init];
    analyze.type = SUPER_VC_TYPE_ANALYZE;
    [self.navigationController pushViewController:analyze animated:YES];
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
