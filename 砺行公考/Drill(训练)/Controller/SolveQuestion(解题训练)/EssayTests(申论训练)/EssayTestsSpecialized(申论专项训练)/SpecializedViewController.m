//
//  SpecializedViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SpecializedViewController.h"
#import "SpecializedTableViewCell.h"
#import "LookDefaultAnswerView.h"
#import "EssayTestSpecializedModel.h"

@interface SpecializedViewController ()<UITableViewDelegate, UITableViewDataSource, SpecializedTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *tagArray;

@property (nonatomic, strong) NSString *current_tag_string;

@end

@implementation SpecializedViewController

- (void)getAllTagHttpData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_essay_classification_label" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
//            NSMutableArray *tag_array = [NSMutableArray arrayWithCapacity:1];
//            NSMutableArray *data_array = [NSMutableArray arrayWithCapacity:1];
//            for (NSDictionary *dic in responseObject[@"data"]) {
//
//            }
            
            
            
//            weakSelf.tagArray = @[
//                                  @{
//                                      @"content_":responseObject[@"data"][1][@"content_"],
//                                      @"serial_number_":responseObject[@"data"][1][@"serial_number_"]
//                                    },
//                                  @{
//                                      @"content_":responseObject[@"data"][2][@"content_"],
//                                      @"serial_number_":responseObject[@"data"][2][@"serial_number_"]
//                                    },
//                                  @{
//                                      @"content_":@"行政公文",
//                                      @"serial_number_":responseObject[@"data"][1][@"serial_number_"]
//                                    },
//                                  @{
//                                      @"content_":@"解决问题",
//                                      @"serial_number_":responseObject[@"data"][1][@"serial_number_"]
//                                    }
//                                  ];
            weakSelf.tagArray = responseObject[@"data"];
            [weakSelf getHttpData:responseObject[@"data"][0][@"serial_number_"]];
            [weakSelf setTagContent];
        }
    } FailureBlock:^(id error) {
        
    }];
}

/**
 通过标签获取题目数据
 */
- (void)getHttpData:(NSString *)tagString {
    NSDictionary *parma = @{
                            @"classification_label":tagString,
                            @"page_number":@"1",
                            @"page_size":@"50"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_essay_special" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"]) {
                EssayTestSpecializedModel *model = [[EssayTestSpecializedModel alloc] init];
                model.specialized_id = dic[@"id_"];
                model.specialized_content_list = dic[@"content_list_"];
                model.specialized_parsing_list = dic[@"parsing_list_"];
                model.specialized_content_file_list = dic[@"content_file_list_"];
                model.specialized_parsing_file_list = dic[@"parsing_file_list_"];
                model.user_answer = @"请填写答案";
                [array addObject:model];
            }
            weakSelf.dataArray = [array copy];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"专项训练";
    [self setBack];
    
//    [self initViewUI];
//    
//    [self getAllTagHttpData];
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[SpecializedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
}

- (void)setTagContent {
    CGFloat buttonWidth = (SCREENBOUNDS.width - 70) / 4;
    CGFloat buttonHeight = 40.0;
    __weak typeof(self) weakSelf = self;
    for (NSInteger index = 0; index < self.tagArray.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.backgroundColor = SetColor(246, 246, 246, 1);
        button.titleLabel.font = SetFont(14);
        [button setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
        [button setTitle:self.tagArray[index][@"content_"] forState:UIControlStateNormal];
        if (index == 0) {
            button.backgroundColor = ButtonColor;
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
        ViewRadius(button, 5.0);
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view.mas_top).offset(10);
            make.left.equalTo(weakSelf.view.mas_left).offset(20 + (buttonWidth + 10) * index);
            make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
        }];
        [button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EssayTestSpecializedModel *model = self.dataArray[indexPath.row];
    SpecializedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.content_label.text = model.finish_content;
    cell.answer_textview.text = model.user_answer;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EssayTestSpecializedModel *model = self.dataArray[indexPath.row];
    return model.finish_content_height + 150.0;
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
            self.current_tag_string = self.tagArray[sender.tag][@"serial_number_"];
            [self getHttpData:self.current_tag_string];
        }else {
            button.backgroundColor = SetColor(246, 246, 246, 1);
            [button setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
        }
    }
}

#pragma mark ---- Specialized tableviewcell delegate
- (void)returnCellIndexPath:(NSIndexPath *)indexPath {
    EssayTestSpecializedModel *model = self.dataArray[indexPath.row];
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LookDefaultAnswerView *answer_view = [[LookDefaultAnswerView alloc] initWithFrame:app_delegate.window.bounds];
    answer_view.content_label.text = model.finish_prasing;
    [app_delegate.window addSubview:answer_view];
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
