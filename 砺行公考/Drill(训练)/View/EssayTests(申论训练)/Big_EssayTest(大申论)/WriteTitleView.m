//
//  WriteTitleView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/19.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "WriteTitleView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface WriteTitleView()<UITextFieldDelegate>

//标题
@property (nonatomic, strong) UITextField *field;

@end

@implementation WriteTitleView

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
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(150, 0, 150, 0));
    }];
    
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(14);
    title_label.textColor = DetailTextColor;
    title_label.text = @"请拟定您心中的标题";
    [back_view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back_view.mas_top).offset(10);
        make.centerX.equalTo(back_view.mas_centerX);
    }];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.backgroundColor = RandomColor;
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.centerY.equalTo(title_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.field = [[UITextField alloc] init];
    self.field.delegate = self;
    self.field.tag = 100;
    self.field.backgroundColor = SetColor(246, 246, 246, 1);
    self.field.font = SetFont(14);
    self.field.placeholder = @"在此输入标题";
    ViewRadius(self.field, 8.0);
    [back_view addSubview:self.field];
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    UITextField *field1 = [[UITextField alloc] init];
    field1.backgroundColor = SetColor(246, 246, 246, 1);
    field1.font = SetFont(14);
    field1.placeholder = @"在此输入副标题(如有)";
    ViewRadius(field1, 8.0);
    [back_view addSubview:field1];
    [field1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.field.mas_bottom).offset(20);
        make.left.equalTo(back_view.mas_left).offset(20);
        make.right.equalTo(back_view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.backgroundColor = ButtonColor;
    [next setTitleColor:WhiteColor forState:UIControlStateNormal];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    ViewRadius(next, 25.0);
    [next addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(field1.mas_bottom).offset(20);
        make.left.equalTo(field1.mas_left);
        make.right.equalTo(field1.mas_right);
        make.height.mas_equalTo(50);
    }];
}

- (void)cancelAction {
    [self removeFromSuperview];
}

- (void)nextAction {
    if ([self.field.text isEqualToString:@""]) {
        [self.field becomeFirstResponder];
        NSLog(@"请输入标题");
        return;
    }
    self.nextBlock();
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:BigEssayTests_my_title];
    }
}

@end
