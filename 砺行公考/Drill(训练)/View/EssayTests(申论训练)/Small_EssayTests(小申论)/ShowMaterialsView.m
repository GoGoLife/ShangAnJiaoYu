//
//  ShowMaterialsView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/19.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShowMaterialsView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "ChooseMaterialsTableViewCell.h"
#import "CustomMaterialsModel.h"
#import "MOLoadHTTPManager.h"

@interface ShowMaterialsView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ShowMaterialsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        [self creatViewUI];
    }
    return self;
}

- (void)setPoints_array:(NSArray *)points_array {
    _points_array = points_array;
    [self.tableview reloadData];
}

- (void)creatViewUI {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = WhiteColor;
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(200, 0, 0, 0));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @"我的采点";
    [back_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
    }];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ChooseMaterialsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [back_view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left);
        make.bottom.equalTo(back_view.mas_bottom);
        make.right.equalTo(back_view.mas_right);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.points_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomMaterialsModel *model = self.points_array[indexPath.row];
    ChooseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isHiddenRightImage = YES;
    cell.content_label.text = model.content_string;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomMaterialsModel *model = self.points_array[indexPath.row];
    if ([_delegate respondsToSelector:@selector(touchPointAction:)]) {
        [_delegate touchPointAction:model.content_string];
    }
    
    [self removeFromSuperview];
}

StringHeight()
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomMaterialsModel *model = self.points_array[indexPath.row];
    CGFloat height = [self calculateRowHeight:model.content_string fontSize:14 withWidth:SCREENBOUNDS.width - 40] + 20.0;
    return height;
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

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    CustomMaterialsModel *model = self.dataArr[indexPath.row];
//    NSDictionary *parma = @{
//                            @"id_":model.materials_id
//                            };
//    __weak typeof(self) weakSelf = self;
//    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_question_catch" Dic:parma SuccessBlock:^(id responseObject) {
//        if ([responseObject[@"state"] integerValue] == 1) {
//            [weakSelf getHttpData];
//        }
//    } FailureBlock:^(id error) {
//
//    }];
//}


#pragma mark ---- custom action
- (void)cancelAction {
    [self removeFromSuperview];
}

//- (void)getHttpData {
//    __weak typeof(self) weakSelf = self;
//    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_question_catch" Dic:@{} SuccessBlock:^(id responseObject) {
//        if ([responseObject[@"state"] integerValue] == 1) {
//            [weakSelf formatHttpData:responseObject[@"data"]];
//        }
//    } FailureBlock:^(id error) {
//
//    }];
//}
//
//- (void)formatHttpData:(NSArray *)dataArr {
//    //整理数据
//    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
//    for (NSDictionary *dic in dataArr) {
//        CustomMaterialsModel *model = [[CustomMaterialsModel alloc] init];
//        model.materials_id = dic[@"id_"];
//        model.tag_string_id = dic[@"question_material_tips_id_"];
//        model.content_string = dic[@"content_"];//@"如果你无法简随便看了封建时代雷锋精神理念就是厉害；六块腹肌克莱斯勒福克斯老骥伏枥开始康复科了时间洁的表达，你的想法如果你无法简太好气哦外婆家鹅礼物哦我洁。";
//        model.tag_string = dic[@"note_"];//@"注解词";
//        model.isSelected = NO;
//        [mutableArr addObject:model];
//    }
//    self.dataArr = [mutableArr copy];
//    [self.tableview reloadData];
//}

@end
