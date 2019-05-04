//
//  BigEssayTestAnalysisViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/20.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigEssayTestAnalysisViewController.h"
#import "EssayTestAnalysisModel.h"
#import "AnalysisForLabelTableViewCell.h"
#import "AnalysisForImageTableViewCell.h"
#import "AnalysisForWKWebviewTableViewCell.h"
#import "SaveMessageViewController.h"
#import "BigFiveViewController.h"

@interface BigEssayTestAnalysisViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BigEssayTestAnalysisViewController

- (void)getHttpDdata {
    NSString *require_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"big_essayTest_require_id"];
    NSDictionary *parma = @{@"require_id_":require_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/real_question_essay_answer" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"big essaytest === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf formatData:responseObject[@"data"]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)formatData:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    EssayTestAnalysisModel *model = [[EssayTestAnalysisModel alloc] init];
    model.Analysis_model_string = @"我的答案";
    model.Analysis_content = dic[@"user_answer_"];
    
    EssayTestAnalysisModel *model1 = [[EssayTestAnalysisModel alloc] init];
    model1.Analysis_model_string = @"点评";
    model1.Analysis_content = dic[@"review_"];
    
    EssayTestAnalysisModel *model2 = [[EssayTestAnalysisModel alloc] init];
    model2.Analysis_model_string = @"逻辑树图";
    model2.Analysis_content = dic[@"thinking_map_list_"][0];
    
    [array addObject:model];
    [array addObject:model1];
    [array addObject:model2];
    
    
    //范文
    for (NSInteger index = 0; index < [dic[@"parsing_list_"] count]; index++) {
        EssayTestAnalysisModel *model3 = [[EssayTestAnalysisModel alloc] init];
        model3.Analysis_model_string = [NSString stringWithFormat:@"范文%ld", index + 1];
        model3.Analysis_content = dic[@"parsing_list_"][index];
        [array addObject:model3];
    }
    
    self.dataArray = [array copy];
    [self.tableview reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"解析";
    [self setBack];
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"完成" target:self action:@selector(rightAction)];
    
    [self initViewUI];
    
    [self getHttpDdata];
}

- (void)initViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[AnalysisForLabelTableViewCell class] forCellReuseIdentifier:@"labelCell"];
    [self.tableview registerClass:[AnalysisForImageTableViewCell class] forCellReuseIdentifier:@"imageCell"];
    [self.tableview registerClass:[AnalysisForWKWebviewTableViewCell class] forCellReuseIdentifier:@"webviewCell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EssayTestAnalysisModel *model = self.dataArray[indexPath.section];
    if ([model.Analysis_model_string isEqualToString:@"逻辑树图"]) {
        AnalysisForImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        [cell.image_view sd_setImageWithURL:[NSURL URLWithString:model.Analysis_content] placeholderImage:[UIImage imageNamed:@"no_image"]];
        return cell;
    }else {
        AnalysisForLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
        cell.content_label.text = model.Analysis_content;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EssayTestAnalysisModel *model = self.dataArray[indexPath.section];
    return model.analysis_content_height + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    EssayTestAnalysisModel *model = self.dataArray[section];
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.textColor = DetailTextColor;
    label.text = model.Analysis_model_string;
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    
    return footer_view;
}

- (void)rightAction {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否需要修改答案" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SaveMessageViewController *message = [[SaveMessageViewController alloc] init];
        [weakSelf.navigationController pushViewController:message animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[BigFiveViewController class]]) {
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
