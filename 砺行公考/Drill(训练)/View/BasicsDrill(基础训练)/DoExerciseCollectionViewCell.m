//
//  DoExerciseCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DoExerciseCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "ExerciseTableViewCell.h"
#import "AnswerModel.h"

@interface DoExerciseCollectionViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, assign) NSInteger result;

@property (nonatomic, strong) NSMutableArray *result_array;

@end

@implementation DoExerciseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.result_array = [NSMutableArray arrayWithCapacity:1];
        [self setCellUI];
    }
    return self;
}

- (void)setCellUI {
    __weak typeof(self) weakSelf = self;
    self.label = [[UILabel alloc] init];
    self.label.font = SetFont(14);
    self.label.textColor = DetailTextColor;
    self.label.text = @"单选题";
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = SetFont(14);
    self.numberLabel.textColor = DetailTextColor;
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.label.mas_centerY);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = SetFont(16);
    self.titleLabel.textColor = SetColor(74, 74, 74, 1);
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
    
    self.next = [UIButton buttonWithType:UIButtonTypeCustom];
    self.next.backgroundColor = SetColor(36, 111, 245, 1);
    [self.next setTitle:@"下一题" forState:UIControlStateNormal];
    [self.next setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.next addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(self.next, 25.0);
    [self.contentView addSubview:self.next];
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-40);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(40);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-40);
        make.height.mas_equalTo(50);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //隐藏tableview的分割线
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ExerciseTableViewCell class] forCellReuseIdentifier:@"exerciseCell"];
    [self.contentView addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.bottom.equalTo(weakSelf.next.mas_top).offset(-10);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.indexPath.row == self.question_num - 1) {
        [self.next setTitle:@"提交" forState:UIControlStateNormal];
    }
}

#pragma mark ------- tableview   delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.answer_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnswerModel *model = self.answer_array[indexPath.row];
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exerciseCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftLabel.text = @[@"A", @"B", @"C", @"D"][indexPath.row];
    cell.contentLabel.attributedText = model.answer_content;
    
    NSLog(@"是否复用 === %d", [self.select_answer_array containsObject:model.answer_id]);
    
    if ([self.select_answer_array containsObject:model.answer_id]) {
        cell.leftLabel.backgroundColor = SetColor(48, 132, 252, 1);
        cell.contentLabel.textColor = SetColor(48, 132, 252, 1);
    }
    
    //根据题目type    判断是否隐藏下一题按钮
    if ([self.label.text isEqualToString:@"单选题"]) {
        //隐藏下一题按钮
        self.next.hidden = YES;
    }else {
        
        self.next.hidden = NO;
    }
    
//    if ([self.result_array containsObject:indexPath]) {
//        cell.leftLabel.textColor = WhiteColor;
//        cell.leftLabel.backgroundColor = SetColor(48, 132, 252, 1);
//        cell.contentLabel.textColor = SetColor(48, 132, 252, 1);
//    }else {
//        cell.leftLabel.backgroundColor = WhiteColor;
//        cell.leftLabel.textColor = DetailTextColor;
//        cell.contentLabel.textColor = SetColor(74, 74, 74, 1);
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnswerModel *model = self.answer_array[indexPath.row];
    return model.answer_height;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
////    return 
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExerciseTableViewCell *cell = (ExerciseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([self.label.text isEqualToString:@"单选题"]) {
        [self.result_array removeAllObjects];
        [self.result_array addObject:indexPath];
//        cell.leftLabel.textColor = WhiteColor;
        cell.leftLabel.backgroundColor = SetColor(48, 132, 252, 1);
        cell.contentLabel.textColor = SetColor(48, 132, 252, 1);
        
        
        //单选题自动跳到下一题
        if ([_delegate respondsToSelector:@selector(returnSelectResult:withIndexPath:)]) {
            [_delegate returnSelectResult:[self.result_array copy] withIndexPath:self.indexPath];
        }
        
    }else if ([self.label.text isEqualToString:@"多选题"]) {
        if ([self.result_array containsObject:indexPath]) {
            [self.result_array removeObject:indexPath];
//            cell.leftLabel.backgroundColor = WhiteColor;
            cell.leftLabel.textColor = DetailTextColor;
            cell.contentLabel.textColor = SetColor(74, 74, 74, 1);
        }else {
            [self.result_array addObject:indexPath];
//            cell.leftLabel.textColor = WhiteColor;
            cell.leftLabel.backgroundColor = SetColor(48, 132, 252, 1);
            cell.contentLabel.textColor = SetColor(48, 132, 252, 1);
        }
        
        //隐藏下一题按钮
        self.next.hidden = NO;
    }
    
    
}

//delegate   返回选择结果
- (void)nextAction {
    if ([_delegate respondsToSelector:@selector(returnSelectResult:withIndexPath:)]) {
        [_delegate returnSelectResult:[self.result_array copy] withIndexPath:self.indexPath];
    }
}

@end
