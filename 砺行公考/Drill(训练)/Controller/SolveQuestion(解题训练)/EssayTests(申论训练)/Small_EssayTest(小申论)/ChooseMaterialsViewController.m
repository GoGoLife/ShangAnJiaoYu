//
//  ChooseMaterialsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ChooseMaterialsViewController.h"
#import "ChooseMaterialsTableViewCell.h"
//采点数据Model
#import "CustomMaterialsModel.h"

@interface ChooseMaterialsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArr;

//选中的数据
@property (nonatomic, strong) NSMutableArray *selected_array;

@end

@implementation ChooseMaterialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selected_array = [NSMutableArray arrayWithCapacity:1];
    
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self getHttpData];
    
    [self setViewUI];
}

- (void)getHttpData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_question_catch" Dic:@{} SuccessBlock:^(id responseObject) {
//        NSLog(@"data === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf formatHttpData:responseObject[@"data"]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)formatHttpData:(NSArray *)dataArr {
    //整理数据
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in dataArr) {
        CustomMaterialsModel *model = [[CustomMaterialsModel alloc] init];
        model.materials_id = dic[@"id_"];
        model.tag_string_id = dic[@"tips_id_"];
        model.content_string = [dic[@"content_"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];;//@"如果你无法简随便看了封建时代雷锋精神理念就是厉害；六块腹肌克莱斯勒福克斯老骥伏枥开始康复科了时间洁的表达，你的想法如果你无法简太好气哦外婆家鹅礼物哦我洁。";
        model.tag_string = dic[@"note_"];//@"注解词";
        model.tag_type_string = dic[@"tips_content_"];
        model.isSelected = NO;
        [mutableArr addObject:model];
    }
    self.dataArr = [mutableArr copy];
    [self.tableview reloadData];
}

- (void)setViewUI {
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ChooseMaterialsTableViewCell class] forCellReuseIdentifier:@"chooseCell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomMaterialsModel *model = self.dataArr[indexPath.row];
    ChooseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell"];
//    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:model.content_string];
//    [attributed addAttribute:NSForegroundColorAttributeName value:RandomColor range:NSMakeRange(0, 4)];
//    cell.content_label.attributedText = attributed;
    cell.content_label.text = [NSString stringWithFormat:@"%@：%@", model.tag_type_string, model.content_string];
//    cell.tag_label.text = model.tag_string;
    cell.isSelected = model.isSelected;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomMaterialsModel *model = self.dataArr[indexPath.row];
    return model.content_string_height + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomMaterialsModel *model = self.dataArr[indexPath.row];
    model.isSelected = !model.isSelected;
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (model.isSelected) {
        [self.selected_array addObject:model];
    }else {
        [self.selected_array removeObject:model];
    }
}

//点击右上角完成    将选择是数组数据传出
- (void)finishAction {
    NSLog(@"selected  data === %@", self.selected_array);
    self.returnSelectedData([self.selected_array copy]);
    [self.navigationController popViewControllerAnimated:YES];
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
