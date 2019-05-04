//
//  AddCustomMaterialsView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/16.
//  Copyright © 2018 钟文斌. All rights reserved.
//       加入采点视图

#import "AddCustomMaterialsView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "MOLoadHTTPManager.h"

@interface AddCustomMaterialsView()<UITextFieldDelegate>

//确认加入的是那个采点标签
@property (nonatomic, strong) NSString *tips_id;

//保存传过来的采点数据
@property (nonatomic, strong) NSString *content_string;

//保存注解词
@property (nonatomic, strong) NSString *note_;

@property (nonatomic, strong) UITextField *input_field;

@end

@implementation AddCustomMaterialsView

//self  添加在Window上   透明度为0.5
- (instancetype)initWithFrame:(CGRect)frame AndTips_ID:(NSString *)tip_id AndContent_string:(NSString *)content_string {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        self.tips_id = tip_id;
        self.content_string = content_string;
        [self set_content_view:self AndTips_ID:tip_id AndContent_string:content_string];
    }
    return self;
}

- (void)set_content_view:(UIView *)back_view AndTips_ID:(NSString *)tip_id AndContent_string:(NSString *)content_string {
    UIView *content_view = [[UIView alloc] init];
    content_view.alpha = 1;
    content_view.backgroundColor = WhiteColor;
    ViewRadius(content_view, 5.0);
    [back_view addSubview:content_view];
    [content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(140, 50, 180, 50));
    }];
    
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(16);
    title_label.text = @"预备采点";
    [content_view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content_view.mas_top).offset(20);
        make.centerX.equalTo(content_view.mas_centerX);
    }];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.backgroundColor = RandomColor;
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [content_view addSubview:cancel];
    [content_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(content_view.mas_right).offset(-20);
        make.centerY.equalTo(title_label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *tag_label = [[UILabel alloc] init];
    tag_label.backgroundColor = SetColor(255, 134, 37, 1);
    tag_label.font = SetFont(14);
    tag_label.textColor = WhiteColor;
    tag_label.textAlignment = NSTextAlignmentCenter;
    tag_label.text = @"表现";
    ViewRadius(tag_label, 5.0);
    [content_view addSubview:tag_label];
    [tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_bottom).offset(20);
        make.left.equalTo(content_view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(86, 32));
    }];
    
    UITextView *textview = [[UITextView alloc] init];
    textview.editable = NO;
    textview.font = SetFont(14);
    textview.textColor = SetColor(74, 74, 74, 1);
    textview.text = content_string;
    [content_view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tag_label.mas_bottom).offset(20);
        make.left.equalTo(content_view.mas_left).offset(20);
        make.right.equalTo(content_view.mas_right).offset(-20);
        make.height.mas_equalTo(100);
    }];
    
    self.input_field = [[UITextField alloc] init];
    self.input_field.delegate = self;
    self.input_field.backgroundColor = SetColor(246, 246, 246, 1);
    self.input_field.placeholder = @"添加注解词（最多10个字）";
    self.input_field.font = SetFont(14);
    ViewRadius(self.input_field, 8.0);
    [content_view addSubview:self.input_field];
    [self.input_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textview.mas_bottom).offset(20);
        make.left.equalTo(textview.mas_left);
        make.right.equalTo(textview.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    __weak typeof(self) weakSelf = self;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.backgroundColor = ButtonColor;
    addButton.titleLabel.font = SetFont(18);
    [addButton setTitle:@"加入采点" forState:UIControlStateNormal];
    [addButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    ViewRadius(addButton, 23.0);
    [addButton addTarget:self action:@selector(addMaterialsAction) forControlEvents:UIControlEventTouchUpInside];
    [content_view addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.input_field.mas_bottom).offset(20);
        make.centerX.equalTo(content_view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(140, 46));
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.note_ = textField.text;
}

- (void)cancelAction {
    [self removeFromSuperview];
}

//添加采点信息到数据库
- (void)addMaterialsAction {
    NSString *id_ = @"";
    NSString *content_ = @"";
    if ([self.tips_id isEqualToString:@"0"]) {
        id_ = @"00000000000000000001001400010000";
        content_ = [@"【表现】" stringByAppendingString:self.content_string];
    }else if ([self.tips_id isEqualToString:@"1"]) {
        id_ = @"00000000000000000001001400020000";
        content_ = [@"【效果】" stringByAppendingString:self.content_string];
    }else if ([self.tips_id isEqualToString:@"2"]) {
        id_ = @"00000000000000000001001400030000";
        content_ = [@"【原因】" stringByAppendingString:self.content_string];
    }else if ([self.tips_id isEqualToString:@"3"]) {
        id_ = @"00000000000000000001001400040000";
        content_ = [@"【对策】" stringByAppendingString:self.content_string];
    }else if ([self.tips_id isEqualToString:@"4"]) {
        id_ = @"00000000000000000001001400050000";
        content_ = [@"【背景】" stringByAppendingString:self.content_string];
    }
    NSDictionary *parma = @{
                            @"id_":id_,
                            @"content_":content_,
                            @"note_":self.input_field.text
                            };
    NSLog(@"parma === %@", parma);
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_question_catch" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"添加成功 == %@", responseObject);
        //添加成功之后  运行的一个Block
        weakSelf.addMaterialsDataFinishBlock();
        [weakSelf cancelAction];
    } FailureBlock:^(id error) {
        NSLog(@"添加失败");
    }];
}
@end
