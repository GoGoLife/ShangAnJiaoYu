//
//  chooseTitleView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/19.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "chooseTitleView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "MOLoadHTTPManager.h"

@interface chooseTitleView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *selected_array;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *right_label;

//标题数据
@property (nonatomic, strong) NSArray *dataArr;

//返回的最优标题
@property (nonatomic, strong) NSArray *bast_title_array;

@end

@implementation chooseTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.selected_array = [NSMutableArray arrayWithCapacity:1];
        [self creatViewUI];
    }
    return self;
}

//- (void)setBig_essayTest_id:(NSString *)big_essayTest_id {
//    _big_essayTest_id = big_essayTest_id;
//    [self getHttpData];
//}
//
//- (void)getHttpData {
//    if (!self.big_essayTest_id) {
//        NSLog(@"大申论ID不存在");
//        return;
//    }
//    __weak typeof(self) weakSelf = self;
//    NSDictionary *parma = @{@"question_topic_id_":self.big_essayTest_id};
//    NSLog(@"title parma == %@", parma);
//    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_essay_title" Dic:parma SuccessBlock:^(id responseObject) {
//        NSLog(@"title  response === %@", responseObject);
//        weakSelf.dataArr = responseObject[@"data"][@"essay_title_result"];
//        weakSelf.bast_title_array = responseObject[@"data"][@"best_title_result"];
//        [weakSelf.tableview reloadData];
//    } FailureBlock:^(id error) {
//        NSLog(@"error === %@", error);
//    }];
//
//}

- (void)creatViewUI {
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BOOL isSelected = NO;
    if ([self.selected_array containsObject:indexPath]) {
        isSelected = YES;
    }else {
        isSelected = NO;
    }
    [self setCellContent:cell AndIndexPath:indexPath withIsSelected:isSelected];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    [self setHeader_view:header_view];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selected_array containsObject:indexPath]) {
        [self.selected_array removeObject:indexPath];
    }else {
        [self.selected_array addObject:indexPath];
    }
    [self.tableview reloadData];
}

- (void)setHeader_view:(UIView *)header_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"您的标题为：我们的祖国是花园";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    UIButton *finish = [UIButton buttonWithType:UIButtonTypeCustom];
    finish.titleLabel.font = SetFont(14);
    [finish setTitleColor:ButtonColor forState:UIControlStateNormal];
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [header_view addSubview:finish];
    [finish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(238, 238, 238, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.leading.trailing.equalTo(header_view).offset(10);
        make.height.mas_equalTo(2);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(14);
    label1.textColor = DetailTextColor;
    label1.text = @"从下列标题中选出你觉得最合适的3项：";
    [header_view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
    }];
}

- (void)setCellContent:(UITableViewCell *)cell AndIndexPath:(NSIndexPath *)indexPath withIsSelected:(BOOL)isSelected {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *vv in cell.contentView.subviews) {
        [vv removeFromSuperview];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = SetFont(16);
    self.titleLabel.text = [NSString stringWithFormat:@"%ld、%@", indexPath.row+1, dic[@"title_"]];
    [cell.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(20);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    
    self.right_label = [[UILabel alloc] init];
    ViewBorderRadius(self.right_label, 10.0, 1.0, DetailTextColor);
    if (isSelected) {
        self.right_label.backgroundColor = ButtonColor;
    }else {
        self.right_label.backgroundColor = WhiteColor;
    }
    [cell.contentView addSubview:self.right_label];
    [self.right_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView.mas_right).offset(-20);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

#pragma mark ----- custom action
- (void)finishAction {
    if ([_delegate respondsToSelector:@selector(returnChooseTitleArray:)]) {
        [self removeFromSuperview];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in self.dataArray) {
            NSInteger isBast = [dic[@"answer_"] integerValue];
            if (isBast) {
                [array addObject:dic[@"title_"]];
            }
        }
        [_delegate returnChooseTitleArray:[array copy]];
    }
}

@end
