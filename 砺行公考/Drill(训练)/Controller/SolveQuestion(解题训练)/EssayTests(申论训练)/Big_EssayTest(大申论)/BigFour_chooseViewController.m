//
//  BigFour_chooseViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BigFour_chooseViewController.h"
#import "SystemAnswerTableViewCell.h"
#import "SystemAnswerModel.h"
#import "BigFour_compareViewController.h"

//选完分析之后跳转到写对策界面
#import "BigFour_AnalyzeViewController.h"

//对策选完了之后   到第五步
#import "BigFiveViewController.h"

@interface BigFour_chooseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

/**
 所选择的最佳的引言段
 */
@property (nonatomic, strong) NSString *select_bast_yinyan;

@end

@implementation BigFour_chooseViewController

- (void)getAnalysisData {
    NSString *require_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"big_essayTest_require_id"];
    NSDictionary *parma = @{@"require_id_":require_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_big_essay_introduction" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"require data === %@", responseObject);
            [weakSelf formatData:responseObject[@"data"] WithType:weakSelf.type];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//根据不同的type  整理数据
- (void)formatData:(NSDictionary *)dic WithType:(SUPER_VIEW_TYPE)type {
    NSArray *yinyan_array = @[];
    if (type == SUPER_VIEW_TYPE_WRITE_INTRODUCTION) {
        //引言
        //整理数据
        yinyan_array = dic[@"introduction_"];
    }else if (type == SUPER_VIEW_TYPE_ANALYZE) {
        //分析
        yinyan_array = dic[@"analysis_"];
    }else if (type == SUPER_VIEW_TYPE_COUNTERMEASURE) {
        //对策
        yinyan_array = dic[@"countermeasures_"];
    }
    
    //将数据转换成model
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < yinyan_array.count; index++) {
        SystemAnswerModel *model = [[SystemAnswerModel alloc] init];
        model.content_string = yinyan_array[index];
        [mutableArr addObject:model];
    }
    self.dataArray = [mutableArr copy];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    if (self.type == SUPER_VIEW_TYPE_WRITE_INTRODUCTION) {
        label.text = @"第四步：布局总括-引言";
    }else if (self.type == SUPER_VIEW_TYPE_ANALYZE) {
        label.text = @"第四步：布局总括-分析";
    }else {
        label.text = @"第四步：布局总括-对策";
    }
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[SystemAnswerTableViewCell class] forCellReuseIdentifier:@"system"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    //获取数据
    [self getAnalysisData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemAnswerModel *model = self.dataArray[indexPath.row];
    SystemAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"system"];
    if (self.type == SUPER_VIEW_TYPE_WRITE_INTRODUCTION) {
        cell.top_label.text = [NSString stringWithFormat:@"引言段%ld", indexPath.row + 1];
    }else if (self.type == SUPER_VIEW_TYPE_ANALYZE) {
        cell.top_label.text = [NSString stringWithFormat:@"分析段%ld", indexPath.row + 1];
    }else {
        cell.top_label.text = [NSString stringWithFormat:@"对策段%ld", indexPath.row + 1];
    }
    cell.content_label.text = model.content_string;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemAnswerModel *model = self.dataArray[indexPath.row];
    return model.content_string_height + 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DetailTextColor;
    label.font = SetFont(14);
    if (self.type == SUPER_VIEW_TYPE_WRITE_INTRODUCTION) {
        label.text = @"请选出你认为最棒的引言段";
    }else if (self.type == SUPER_VIEW_TYPE_ANALYZE) {
        label.text = @"请选出你认为最棒的分析段";
    }else {
        label.text = @"请选出你认为最棒的对策段";
    }
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == SUPER_VIEW_TYPE_WRITE_INTRODUCTION) {
        SystemAnswerTableViewCell *cell = (SystemAnswerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.back_view.backgroundColor = ButtonColor;
        cell.top_label.textColor = WhiteColor;
        cell.content_label.textColor = WhiteColor;
        SystemAnswerModel *model = self.dataArray[indexPath.row];
        self.select_bast_yinyan = model.content_string;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemAnswerTableViewCell *cell = (SystemAnswerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.back_view.backgroundColor = SetColor(246, 246, 246, 1);
    cell.top_label.textColor = ButtonColor;
    cell.content_label.textColor = SetColor(74, 74, 74, 1);
}

- (void)nextAction {
    switch (self.type) {
        case SUPER_VIEW_TYPE_WRITE_INTRODUCTION:
        {
            //选完了引言段  跳转到填写分析总括句页面
            BigFour_compareViewController *compare = [[BigFour_compareViewController alloc] init];
            compare.seleted_bast_yinyan = self.select_bast_yinyan;
            [self.navigationController pushViewController:compare animated:YES];
        }
            break;
        case SUPER_VIEW_TYPE_ANALYZE:
        {
            NSInteger type = [[[NSUserDefaults standardUserDefaults] objectForKey:Big_EssayTests_Do_type] integerValue];
            //判断做题类型   类型一  跳转写对策   类型二   跳转第五步
            if (type) {
                //选择完分析段   跳转到填写对策总括句页面
                BigFour_AnalyzeViewController *analyze = [[BigFour_AnalyzeViewController alloc] init];
                analyze.type = SUPER_VC_TYPE_COUNTERMEASURE;
                [self.navigationController pushViewController:analyze animated:YES];
            }else {
                BigFiveViewController *five = [[BigFiveViewController alloc] init];
                [self.navigationController pushViewController:five animated:YES];
            }
            
        }
            break;
        case SUPER_VIEW_TYPE_COUNTERMEASURE:
        {
            NSLog(@"最后是选完了对策");
            BigFiveViewController *five = [[BigFiveViewController alloc] init];
            [self.navigationController pushViewController:five animated:YES];
        }
            break;
            
        default:
            break;
    }
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
