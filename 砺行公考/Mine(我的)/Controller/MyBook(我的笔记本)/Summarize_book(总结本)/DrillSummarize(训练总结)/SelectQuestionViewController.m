//
//  SelectQuestionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SelectQuestionViewController.h"
#import "SummarizeBookTableViewCell.h"
#import "Drill_WriteSummarizeViewController.h"
#import "DrillSummarizeModel.h"

@interface SelectQuestionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) DrillSummarizeModel *selected_model;

@end

@implementation SelectQuestionViewController


- (void)getHttpData {
    NSDictionary *parma = @{
                            @"page_number":@"1",
                            @"page_size":@"20"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_all_essay_question" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"shenlun  ===== %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                DrillSummarizeModel *model = [[DrillSummarizeModel alloc] init];
                model.drill_question_id = dic[@"id_"];
                model.drill_question_content = dic[@"title_"];
                model.drill_question_require = dic[@"require_"];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[SummarizeBookTableViewCell class] forCellReuseIdentifier:@"summarize"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //获取数据
    [self getHttpData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrillSummarizeModel *model = self.dataArray[indexPath.row];
    SummarizeBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"summarize"];
    cell.isHiddenSummarizeLabel = YES;
    cell.isSupportSelect = YES;
    cell.answer_label_A.text = @"";
    cell.answer_label_B.text = @"";
    cell.answer_label_C.text = @"";
    cell.answer_label_D.text = @"";
    cell.content_label.text = model.drill_question_content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selected_model = self.dataArray[indexPath.row];
    SummarizeBookTableViewCell *cell = (SummarizeBookTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.select_image.backgroundColor = [UIColor redColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    SummarizeBookTableViewCell *cell = (SummarizeBookTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.select_image.backgroundColor = RandomColor;
}

//右上角完成方法
- (void)finishAction {
    if (self.selected_model) {
        Drill_WriteSummarizeViewController *write = [[Drill_WriteSummarizeViewController alloc] init];
        write.dataModel = self.selected_model;
        [self.navigationController pushViewController:write animated:YES];
    }else {
        [self showHUDWithTitle:@"请选择一题"];
    }
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
