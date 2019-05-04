//
//  ProveReusableView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ProveReusableView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface ProveReusableView ()

@property (nonatomic, strong) UIImageView *imageview;

/** 简介 */
@property (nonatomic, strong) UILabel *intro_label;

@property (nonatomic, strong) UILabel *content_label;

@property (nonatomic, strong) UIButton *look_more_button;

@property (nonatomic, strong) UILabel *submit_label;

@property (nonatomic, strong) UITextField *name_field;

/** 出生年月日 */
@property (nonatomic, strong) UITextField *year_field;

@property (nonatomic, strong) UITextField *sex_field;

/** 民族 */
@property (nonatomic, strong) UITextField *nation_field;

@property (nonatomic, strong) UITextField *phone_field;

/** 学历 */
@property (nonatomic, strong) UITextField *education_field;

@end

@interface ProveReusableView ()<UITextFieldDelegate>

@end

@implementation ProveReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
    }
    return self;
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    self.imageview = [[UIImageView alloc] init];
//    self.imageview.backgroundColor = RandomColor;
    self.imageview.image = [UIImage imageNamed:@"mine_1"];
    [self addSubview:self.imageview];
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.height.mas_equalTo(200);
    }];
    
    self.intro_label = [[UILabel alloc] init];
    self.intro_label.font = SetFont(16);
    self.intro_label.text = @"· 简介";
    [self addSubview:self.intro_label];
    [self.intro_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageview.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.imageview.mas_left).offset(20);
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    self.content_label.numberOfLines = 6;
    self.content_label.text = @"“不忘初心，牢记使命。” 砺行教育的贫困生项目是坚持贯彻落实我党十九大精神的公益项目，旨在为家庭经济条件有限的同学提供一个良好的学习环境。就像我党的十九大是一次不忘初心、牢记使命、高举旗帜、团结奋进的历史性盛会，极大地鼓舞了全党全国人民……";
    [self addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.intro_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.intro_label.mas_left);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
    
    self.look_more_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.look_more_button.titleLabel.font = SetFont(14);
    [self.look_more_button setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [self.look_more_button setTitle:@"查看更多" forState:UIControlStateNormal];
    [self addSubview:self.look_more_button];
    [self.look_more_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.content_label.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    //提交审核
    self.submit_label = [[UILabel alloc] init];
    self.submit_label.font = SetFont(16);
    self.submit_label.text = @"· 提交审核";
    [self addSubview:self.submit_label];
    [self.submit_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.look_more_button.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
    }];
    
    NSArray *titleArray = @[@"请在此输入姓名", @"出生年月(YYYY-MM-DD)", @"性别", @"民族", @"手机号码", @"就读大学/大专/职校及院系班级"];
    for (NSInteger index = 0; index < titleArray.count; index++) {
        UITextField *field = [[UITextField alloc] init];
        field.font = SetFont(14);
        field.placeholder = titleArray[index];
        ViewBorderRadius(field, 5.0, 1.0, SetColor(179, 176, 176, 1));
        field.tag = index;
        field.delegate = self;
        
        UILabel *left = [[UILabel alloc] initWithFrame:FRAME(0, 0, 10, 0)];
        field.leftView = left;
        field.leftViewMode = UITextFieldViewModeAlways;
        
        [self addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.submit_label.mas_bottom).offset(10 + (40 + 10) * index);
            make.left.equalTo(weakSelf.submit_label.mas_left);
            make.right.equalTo(weakSelf.mas_right).offset(-45);
            make.height.mas_equalTo(40);
        }];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.image = [UIImage imageNamed:@"mine_2"];
        [self addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right).offset(-15);
            make.centerY.equalTo(field.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(12);
    label.textColor = DetailTextColor;
    label.text = @"请上传身份证正反面及证明材料图片";
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"111111111111");
    NSInteger index = textField.tag;
    self.returnTextfieldContentAndIndex(textField.text, index);
}

@end
