//
//  CustomSelectFuntionPicker.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/18.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "CustomSelectFuntionPicker.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "OptionalSettingModel.h"

@interface CustomSelectFuntionPicker ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIToolbar *tool;

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSString *select_function_string;

@property (nonatomic, assign) NSInteger row;

@end

@implementation CustomSelectFuntionPicker

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initViewUI];
        self.row = 0;
    }
    return self;
}

- (void)initViewUI {
    __weak typeof(self) weakSelf = self;
    self.tool = [[UIToolbar alloc] init];
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnAction)];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureBtnAction)];
    
    self.tool.items = @[leftbtn, centerSpace, rightbtn];

    [self addSubview:self.tool];
    [self.tool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    self.picker = [[UIPickerView alloc] init];
    self.picker.backgroundColor = WhiteColor;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self addSubview:self.picker];
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(40, 0, 0, 0));
    }];
    [self.picker reloadAllComponents];
    
}

#pragma mark --- picker delegate datasouce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    functionModel *model = self.dataArray[row];
//    return model.function_name;
    return self.dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.row = row;
}


- (void)cancelBtnAction {
    [self removeFromSuperview];
}

- (void)sureBtnAction {
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(returnSelectFunctionStringAtIndex:)]) {
        [_delegate returnSelectFunctionStringAtIndex:self.row];
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
