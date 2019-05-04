//
//  ShowBastTitleView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/21.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShowBastTitleView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "Bast_TitleTableViewCell.h"

@interface ShowBastTitleView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation ShowBastTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        [self creatViewUI];
    }
    return self;
}

- (void)creatViewUI {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = WhiteColor;
    ViewRadius(back_view, 8.0);
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(100, 30, 100, 30));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(22);
//    label.textColor = WhiteColor;
    label.text = @"最佳标题";
    [back_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(20);
        make.centerX.equalTo(back_view.mas_centerX);
    }];
    
//    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancel.backgroundColor = RandomColor;
//    [self addSubview:cancel];
//    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.mas_right).offset(-20);
//        make.centerY.equalTo(label.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//    }];
    
    //开始采点按钮
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.titleLabel.font = SetFont(18);
    startBtn.backgroundColor = ButtonColor;
    [startBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [startBtn setTitle:@"很棒，开始采点" forState:UIControlStateNormal];
    ViewRadius(startBtn, 25.0);
    [startBtn addTarget:self action:@selector(touchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(back_view.mas_bottom).offset(-20);
        make.left.equalTo(back_view.mas_left).offset(30);
        make.right.equalTo(back_view.mas_right).offset(-30);
        make.height.mas_equalTo(50);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[Bast_TitleTableViewCell class] forCellReuseIdentifier:@"cell"];
    [back_view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.bottom.equalTo(startBtn.mas_top).offset(-20);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Bast_TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.topLabel.text = [NSString stringWithFormat:@"NO.%ld", indexPath.row + 1];
    cell.title_label.text = self.dataArr[indexPath.row];
    cell.details_label.text = @"这个标题为什么好说明这个标题为什么好说明这个标题为什么好说明";
    return cell;
}

StringHeight()
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dic = self.dataArr[indexPath.row];
    CGFloat height = [self calculateRowHeight:@"这个标题为什么好说明这个标题为什么好说明这个标题为什么好说明" fontSize:14 withWidth:SCREENBOUNDS.width - 100];
    return height + 100;
}

- (void)touchButtonAction {
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(touchStartButtonAction)]) {
        [_delegate touchStartButtonAction];
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
