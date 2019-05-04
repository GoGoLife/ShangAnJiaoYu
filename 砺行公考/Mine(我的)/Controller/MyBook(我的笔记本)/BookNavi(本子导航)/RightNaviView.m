//
//  RightNaviView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "RightNaviView.h"
#import "BookNaviTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "FuncNivaModel.h"

@interface RightNaviView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation RightNaviView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self creatViewUI];
    }
    return self;
}

- (void)setRight_data_array:(NSArray *)right_data_array {
    _right_data_array = right_data_array;
    [self.tableview reloadData];
}

- (void)creatViewUI {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BookNaviTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.right_data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FuncIndexModel *model = self.right_data_array[indexPath.row];
    BookNaviTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.content_label.text = model.func_index_name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(rightViewSelectRow:DataString:)]) {
        [_delegate rightViewSelectRow:indexPath.row DataString:self.right_data_array[indexPath.row]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
