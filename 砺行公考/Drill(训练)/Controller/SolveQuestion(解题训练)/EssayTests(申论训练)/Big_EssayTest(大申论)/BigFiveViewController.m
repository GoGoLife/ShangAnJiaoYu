//
//  BigFiveViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BigFiveViewController.h"
#import "ShowAndWriteTableViewCell.h"

#import "BigFive_FinishViewController.h"
#import "FinishAnswerModel.h"

@interface BigFiveViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    NSArray *section_title_array;
}

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation BigFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取大申论做题方式
    NSInteger type = [[[NSUserDefaults standardUserDefaults] objectForKey:Big_EssayTests_Do_type] integerValue];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    //填写的引言总括句数据   array
    NSString *YinYanString = [NSString stringWithContentsOfFile:YinYan_data_file encoding:NSUTF8StringEncoding error:nil];
    //填写的分析总括句数据   array
    NSArray *FenXiArray = [NSArray arrayWithContentsOfFile:FenXi_data_file];
    //填写的对策总括句数据   array
    NSArray *DuiCeArray = [NSArray arrayWithContentsOfFile:DuiCe_data_file];
    
    if (type) {
        for (NSInteger index = 0; index < 5; index++) {
            FinishAnswerModel *model = [[FinishAnswerModel alloc] init];
            model.section_string = @[@"引言段", @"分析段", @"承接段", @"对策段", @"结尾段"][index];
            switch (index) {
                case 0:
                    model.answer_string = YinYanString;
                    break;
                case 1:
                    model.answer_string = [FenXiArray componentsJoinedByString:@""];
                    break;
                case 2:
                    model.answer_string = @"请填写承接段";
                    break;
                case 3:
                    model.answer_string = [DuiCeArray componentsJoinedByString:@""];
                    break;
                case 4:
                    model.answer_string = @"请填写结尾段";
                    break;
                    
                default:
                    break;
            }
            [array addObject:model];
        }
        section_title_array = [array copy];
    }else {
//        NSArray *FenXiArray = [NSArray arrayWithContentsOfFile:FenXi_data_file];
//        NSLog(@"fenxi_array === %@", FenXiArray);
        FinishAnswerModel *model = [[FinishAnswerModel alloc] init];
        model.section_string = @"引言段";
        model.answer_string = YinYanString;
        [array addObject:model];
        for (NSInteger index = 0; index < FenXiArray.count; index++) {
            FinishAnswerModel *model = [[FinishAnswerModel alloc] init];
            model.section_string = [NSString stringWithFormat:@"分析段%ld", index + 1];
            model.answer_string = FenXiArray[index];
            [array addObject:model];
        }
        FinishAnswerModel *model1 = [[FinishAnswerModel alloc] init];
        model1.section_string = @"结尾段";
        model1.answer_string = @"请填写结尾段";
        [array addObject:model1];
        section_title_array = [array copy];
    }
    
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self setBack];
    
    __weak typeof(self) weakSelf = self;
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    label.text = @"第五步：逻辑树图";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(14);
    label1.textColor = DetailTextColor;
    label1.text = @"请写下承接段和结尾段";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = SetFont(14);
    label2.textColor = DetailTextColor;
    label2.text = @"我的标题";
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(20);
        make.left.equalTo(label1.mas_left);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.font = SetFont(14);
    label3.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(label3, 8.0);
    label3.text = [@"    " stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:BigEssayTests_my_title]];//@"    发了第三方吉安市解放路撒快递费";
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.left.equalTo(label2.mas_left);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowAndWriteTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return section_title_array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinishAnswerModel *model = section_title_array[indexPath.section];
    ShowAndWriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textview.delegate = self;
    cell.textview.tag = indexPath.section;
    cell.textview.text = model.answer_string;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ShowAndWrite_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 60.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    [self setHeader_view:header_view WithSection:section];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //最后一个分区的footer 加   按钮
    if (section == section_title_array.count - 1) {
        UIView *footer_view = [[UIView alloc] init];
        footer_view.backgroundColor = WhiteColor;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:ButtonColor forState:UIControlStateNormal];
        [button setTitle:@"点此进入完成稿写作" forState:UIControlStateNormal];
        ViewBorderRadius(button, 20.0, 1.0, ButtonColor);
        [footer_view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(10, 30, 10, 30));
        }];
        return footer_view;
    }
    return nil;
}

- (void)setHeader_view:(UIView *)header_view WithSection:(NSInteger)section {
    FinishAnswerModel *model = section_title_array[section];
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = model.section_string;
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
}

//完成
- (void)nextAction {
    FinishAnswerModel *model = section_title_array[2];
    FinishAnswerModel *model1 = section_title_array[4];
    if ([model.answer_string isEqualToString:@"请填写承接段"] || [model1.answer_string isEqualToString:@"请填写结尾段"]) {
        [self showHUDWithTitle:@"请完整作答"];
        return;
    }
    
    //拼接最终答案数据
    NSString *finish_string = @"答案：";
    for (FinishAnswerModel *model in section_title_array) {
        finish_string = [finish_string stringByAppendingString:model.answer_string];
    }
    NSLog(@"finish_string === %@", finish_string);
    
    BigFive_FinishViewController *finish = [[BigFive_FinishViewController alloc] init];
    finish.result_string = finish_string;
    [self.navigationController pushViewController:finish animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSInteger index = textView.tag;
    FinishAnswerModel *model = section_title_array[index];
    model.answer_string = textView.text;
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
