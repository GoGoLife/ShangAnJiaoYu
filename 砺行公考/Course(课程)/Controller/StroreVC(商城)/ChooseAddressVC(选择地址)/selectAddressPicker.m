//
//  selectAddressPicker.m
//  ZBT
//
//  Created by 钟文斌 on 2018/7/9.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "selectAddressPicker.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface selectAddressPicker()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSInteger _provinceIndex;   // 省份选择 记录
    NSInteger _cityIndex;       // 市选择 记录
    NSInteger _districtIndex;   // 区选择 记录
}

@property (nonatomic, strong) UIToolbar *tool;

@property (nonatomic, strong) UIPickerView *pickerV;

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray * arrayDS;

@end

@implementation selectAddressPicker

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = BaseViewColor;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    [self addSubview:self.tool];
    [self addSubview:self.pickerV];
    
    __weak typeof(self) weakSelf = self;
    [self.tool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
    [self.pickerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tool.mas_bottom);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
}

-(void)initData
{
    _provinceIndex = _cityIndex = _districtIndex = 0;
}

#pragma mark - Load DataSource

// 读取本地Plist加载数据源
-(NSArray *)arrayDS
{
    if(!_arrayDS){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
        _arrayDS = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _arrayDS;
}

-(void)resetPickerSelectRow
{
    [self.pickerV selectRow:_provinceIndex inComponent:0 animated:YES];
    [self.pickerV selectRow:_cityIndex inComponent:1 animated:YES];
    [self.pickerV selectRow:_districtIndex inComponent:2 animated:YES];
}

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 每列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return self.arrayDS.count;
    }
    else if (component == 1){
        return [self.arrayDS[_provinceIndex][@"citys"] count];
    }
    else{
        return [self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"] count];
    }
}

// 返回每一行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        return self.arrayDS[row][@"province"];
    }
    else if (component == 1){
        return self.arrayDS[_provinceIndex][@"citys"][row][@"city"];
    }
    else{
        return self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = SetFont(14);
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

// 滑动或点击选择，确认pickerView选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component == 0){
        _provinceIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        [self.pickerV reloadComponent:1];
        [self.pickerV reloadComponent:2];
    }
    else if (component == 1){
        _cityIndex = row;
        _districtIndex = 0;
        
        [self.pickerV reloadComponent:2];
    }
    else{
        _districtIndex = row;
    }
    
    // 重置当前选中项
    [self resetPickerSelectRow];
}

#pragma mark ----- 懒加载
- (UIToolbar *)tool {
    if (_tool == nil) {
        _tool = [[UIToolbar alloc] init];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        
        UIBarButtonItem *centerItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
        
        _tool.items = @[leftItem, centerItem, rightItem];
        
    }
    return _tool;
}

- (UIPickerView *)pickerV {
    if (_pickerV == nil) {
        _pickerV = [[UIPickerView alloc] init];
        _pickerV.delegate = self;
        _pickerV.dataSource = self;
        [self initData];
        // 默认Picker状态
        [self resetPickerSelectRow];
    }
    return _pickerV;
}

- (void)cancelAction {
    [self removeFromSuperview];
}

- (void)finishAction {
    NSString *address = [NSString stringWithFormat:@"%@-%@-%@", self.arrayDS[_provinceIndex][@"province"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex]];
    self.stringblockr(address);
    [self cancelAction];
}

@end
