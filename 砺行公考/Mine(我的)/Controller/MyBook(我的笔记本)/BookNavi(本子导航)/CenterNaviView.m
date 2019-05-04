//
//  CenterNaviView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CenterNaviView.h"
#import "BookNaviTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "FuncNivaModel.h"

@interface CenterNaviView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation CenterNaviView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self creatViewUI];
    }
    return self;
}

- (void)setCenter_data_array:(NSArray *)center_data_array {
    _center_data_array = center_data_array;
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
    return self.center_data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *textString = @"";
//    if ([self.center_data_array[indexPath.row] isKindOfClass:[NSString class]]) {
//        textString = self.center_data_array[indexPath.row];
//    }else {
//        
//        textString = model.func_name;
//    }
    FuncNivaModel *model = self.center_data_array[indexPath.row];
    BookNaviTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.content_label.text = model.func_name;
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
    if ([_delegate respondsToSelector:@selector(centerViewSelectRow:DataString:)]) {
        [_delegate centerViewSelectRow:indexPath.row DataString:self.center_data_array[indexPath.row]];
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
