//
//  TraningFooterView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/10.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TraningFooterView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "ExerciseTableViewCell.h"

@interface TraningFooterView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation TraningFooterView

+ (instancetype)creatTraningHeaderView:(UICollectionView *)collectionview Identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath withModel:(TraningAnswerModel *)model {
//    static NSString *identifier = @"footer";
    TraningFooterView *footer_view = [collectionview dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
    [footer_view creatHeaderViewUI:model];
    return footer_view;
}

- (void)creatHeaderViewUI:(TraningAnswerModel *)model {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ExerciseTableViewCell class] forCellReuseIdentifier:@"cell"];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.leftLabel.text = @[@"A",@"B",@"C",@"D"][indexPath.row];
    cell.contentLabel.text = @"答案答案答案";
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

@end
