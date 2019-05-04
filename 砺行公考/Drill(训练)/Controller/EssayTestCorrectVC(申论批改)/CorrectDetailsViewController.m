//
//  CorrectDetailsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/24.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CorrectDetailsViewController.h"
#import "CorrectDetailsHeaderView.h"
#import "CorrectDetailsFooterView.h"
#import <YYText.h>
#import "CorrectModel.h"

@interface CorrectDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *data_array;

@property (nonatomic, strong) UIView *back_view;

@end

@implementation CorrectDetailsViewController

- (void)getCorrectDetailsData {
    NSDictionary *parma = @{@"correcting_id_":self.correct_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/training/find_app_correcting_details" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            NSLog(@"correct details === %@", responseObject);
            for (NSDictionary *dic in responseObject[@"data"]) {
                CorrectModel *model = [[CorrectModel alloc] init];
                model.test_string = dic[@"exam_title_"];
                model.question_string = dic[@"require_title_"];
                model.user_name_string = [dic[@"name_"] isEqualToString:@""] ? [NSString stringWithFormat:@"作者%@", dic[@"login_name_"]] : [NSString stringWithFormat:@"作者%@", dic[@"name_"]];
                model.level_string = [NSString stringWithFormat:@"等级%@", dic[@"level_"]];
                model.text_string = dic[@"correcting_"];
                model.correct_array = dic[@"correcting_content"];
                [array addObject:model];
            }
            weakSelf.data_array = [array copy];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"批改详情";
    [self setBack];
    
    [self initViewUI];
    
    [self getCorrectDetailsData];
    
}

- (void)initViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data_array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = SetColor(246, 246, 246, 1);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CorrectModel *model = self.data_array[section];
    return model.question_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CorrectModel *model = self.data_array[section];
    return model.finish_text_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CorrectModel *model = self.data_array[section];
    CorrectDetailsHeaderView *header_view = [[CorrectDetailsHeaderView alloc] init];
    header_view.test_title_label.text = model.test_string;
    header_view.question_title_label.text = model.question_string;
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CorrectDetailsFooterView *footer_view = [[CorrectDetailsFooterView alloc] init];
    footer_view.content_label.attributedText = [self formatYYTextwithSection:section];
    return footer_view;
}

- (NSMutableAttributedString *)formatYYTextwithSection:(NSInteger)section {
    CorrectModel *model = self.data_array[section];
    NSString *string = model.text_string;
    NSMutableAttributedString *attri_string = [[NSMutableAttributedString alloc] initWithString:string];
    attri_string.yy_lineSpacing = 10.0;
    attri_string.yy_font = SetFont(14);
    __weak typeof(self) weakSelf = self;
    for (NSString *replce in model.replace_array) {
        [attri_string yy_setTextHighlightRange:[string rangeOfString:replce] color:[UIColor redColor] backgroundColor:[UIColor redColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSInteger index = [model.replace_array indexOfObject:replce];
            NSLog(@"pizhu ---- %@", model.correct_array[index][@"notation_"]);
            [weakSelf showCorrectInfo:model.correct_array[index][@"notation_"]];
        }];
    }
    return attri_string;
}

- (void)showCorrectInfo:(NSString *)correct_string {
    CGFloat height = [self calculateRowHeight:correct_string fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.back_view = [[UIView alloc] initWithFrame:app_delegate.window.bounds];
    self.back_view.backgroundColor = SetColor(155, 155, 155, 0.8);
    self.back_view.userInteractionEnabled = YES;
    [app_delegate.window addSubview:self.back_view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackViewAction)];
    [self.back_view addGestureRecognizer:tap];
    
    UITextView *label = [[UITextView alloc] init];
    label.scrollEnabled = NO;
    label.backgroundColor = WhiteColor;
    label.font = SetFont(14);
    label.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    label.text = correct_string;
    [self.back_view addSubview:label];
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.back_view.mas_left).offset(0);
        make.right.equalTo(weakSelf.back_view.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.back_view.mas_bottom).offset(0);
        make.height.mas_equalTo(height + 60);
    }];
}

- (void)removeBackViewAction {
    [self.back_view removeFromSuperview];
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
