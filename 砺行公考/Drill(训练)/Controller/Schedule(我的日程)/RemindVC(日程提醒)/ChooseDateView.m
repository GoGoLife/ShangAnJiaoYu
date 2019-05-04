//
//  ChooseDateView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/26.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ChooseDateView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "OptionalSettingModel.h"

@interface ChooseDateView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIToolbar *tool;

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSString *select_function_string;

@property (nonatomic, strong) NSMutableArray *selectRowArray;

@end

@implementation ChooseDateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initViewUI];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    //初始化
    self.selectRowArray = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < _dataArray.count; index++) {
        [self.selectRowArray addObject:@{@"component":[NSString stringWithFormat:@"%ld", index],@"row":@"0"}];
    }
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
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataArray[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArray[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *component_string = [NSString stringWithFormat:@"%ld", component];
    NSString *row_string = [NSString stringWithFormat:@"%ld", row];
    [self.selectRowArray replaceObjectAtIndex:component withObject:@{@"component":component_string,@"row":row_string}];
}


- (void)cancelBtnAction {
    [self removeFromSuperview];
}

- (void)sureBtnAction {
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(returnSelectFunctionStringAtIndex:)]) {
        [_delegate returnSelectFunctionStringAtIndex:self.selectRowArray];
    }
}

@end
