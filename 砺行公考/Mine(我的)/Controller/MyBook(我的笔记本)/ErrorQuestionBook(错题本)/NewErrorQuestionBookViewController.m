//
//  NewErrorQuestionBookViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "NewErrorQuestionBookViewController.h"
#import "BookContentTableViewCell.h"
#import "ErrorBook_Question_Model.h"
#import "ErrorBookNaviViewController.h"

@interface NewErrorQuestionBookViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page_number;

@property (nonatomic, assign) NSInteger select_index;

@end

@implementation NewErrorQuestionBookViewController

/**
 获取随机错题
 */
- (void)getRandomData {
    [self.dataArray removeAllObjects];
    NSDictionary *parma = @{@"size_":@"15"};
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_rand_pitfalls_question" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                ErrorBook_Question_Model *model = [[ErrorBook_Question_Model alloc] init];
                model.errorBook_question_id = dic[@"id_"];
                model.errorBook_question_content = dic[@"title_"];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableview reloadData];
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        
    }];
}

/**
 获取最近错题

 @param page_number 页码数
 */
- (void)getLatelyData:(NSString *)page_number {
    [self.dataArray removeAllObjects];
    NSDictionary *parma = @{@"page_number":page_number,
                            @"page_size":@"15"
                            };
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_recent_pitfalls_question" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                ErrorBook_Question_Model *model = [[ErrorBook_Question_Model alloc] init];
                model.errorBook_question_id = dic[@"id_"];
                model.errorBook_question_content = dic[@"title_"];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableview reloadData];
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //百度统计
    NSString *class_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"class_name"] ?: @"";
    [[BaiduMobStat defaultStat] logEvent:@"OpenErrorBook000" eventLabel:@"错题优题本打开次数" attributes:@{@"class":class_name}];
    
    self.title = @"错题本";
    [self setBack];
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.page_number = 1;
    //默认点击的是随机错题
    self.select_index = 0;
    
//    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"换一批" target:self action:@selector(rightAction)];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"换一批" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(naviAction)];
    
    self.navigationItem.rightBarButtonItems = @[right, right1];
    
    [self initViewUI];
    
    //默认加载随机错题
    [self getRandomData];
}

- (void)initViewUI {
    CGFloat buttonWidth = (SCREENBOUNDS.width - 70) / 2;
    CGFloat buttonHeight = 40.0;
    NSArray *titleArr = @[@"随机错题", @"最近错题"];
    __weak typeof(self) weakSelf = self;
    for (NSInteger index = 0; index < titleArr.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.backgroundColor = SetColor(246, 246, 246, 1);
        button.titleLabel.font = SetFont(14);
        [button setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
        [button setTitle:titleArr[index] forState:UIControlStateNormal];
        if (index == 0) {
            button.backgroundColor = ButtonColor;
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
        ViewRadius(button, 5.0);
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view.mas_top).offset(10);
            make.left.equalTo(weakSelf.view.mas_left).offset(20 + (buttonWidth + 30) * index);
            make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
        }];
        [button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BookContentTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ErrorBook_Question_Model *model = self.dataArray[indexPath.row];
    BookContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isHiddenTitle = NO;
    cell.isHiddenStarlevel = YES;
    cell.content_lable.text = model.errorBook_question_content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark --- button action
- (void)touchButtonAction:(UIButton *)sender {
    for (UIButton *button in self.view.subviews) {
        if (![button isKindOfClass:[UIButton class]]) {
            continue;
        }
        if (button.tag == sender.tag) {
            button.backgroundColor = ButtonColor;
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.select_index = sender.tag;
            if (self.select_index == 0) {
                [self getRandomData];
            }else {
                [self getLatelyData:[NSString stringWithFormat:@"%ld", self.page_number]];
            }
        }else {
            button.backgroundColor = SetColor(246, 246, 246, 1);
            [button setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
        }
    }
}

/**
 换一批
 */
- (void)rightAction {
    if (self.select_index == 0) {
        //表示当前是随机错题
        [self getRandomData];
        
    }else {
        //表示当前是最近错题
        self.page_number++;
        [self getLatelyData:[NSString stringWithFormat:@"%ld", self.page_number]];
        
    }
}

//导航
- (void)naviAction {
    ErrorBookNaviViewController *navi = [[ErrorBookNaviViewController alloc] init];
    [self.navigationController pushViewController:navi animated:YES];
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
