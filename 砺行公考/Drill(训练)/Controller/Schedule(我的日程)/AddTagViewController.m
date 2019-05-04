//
//  AddTagViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/30.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AddTagViewController.h"
#import "ScheduleCollectionViewCell.h"
#import "ScheduleTagModel.h"

@interface AddTagViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSArray *dataArray;

//输入的标签名称
@property (nonatomic, strong) NSString *tag_string;

//选择的颜色位置
@property (nonatomic, assign) NSInteger select_index;

@end

@implementation AddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tag_string = @"";
    self.select_index = -1;
    self.title = @"添加标签";
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"queding"] style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self formatData];
    
    [self setViewUI];
    
}

- (void)formatData {
    self.dataArray = @[
                       @[@"9", @"0", @"137"],
                       @[@"243", @"129", @"129"],
                       @[@"249", @"237", @"105"],
                       @[@"38", @"78", @"134"],
                       @[@"252", @"227", @"138"],
                       @[@"240", @"138", @"93"],
                       @[@"0", @"116", @"228"],
                       @[@"234", @"255", @"208"],
                       @[@"184", @"59", @"94"],
                       @[@"116", @"219", @"239"],
                       @[@"149", @"225", @"211"],
                       @[@"106", @"44", @"112"],
                       @[@"255", @"207", @"223"],
                       @[@"206", @"255", @"241"],
                       @[@"255", @"182", @"185"],
                       @[@"254", @"253", @"202"],
                       @[@"172", @"231", @"239"],
                       @[@"250", @"227", @"217"],
                       @[@"224", @"249", @"181"],
                       @[@"166", @"172", @"236"],
                       @[@"187", @"222", @"214"],
                       @[@"165", @"222", @"229"],
                       @[@"165", @"108", @"193"],
                       @[@"97", @"192", @"191"],
                       ];
}

- (void)setViewUI {
    UITextField *textF = [[UITextField alloc] init];
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    textF.delegate = self;
    textF.font = SetFont(16);
    textF.textColor = SetColor(203, 203, 203, 1);
    textF.placeholder = @"输入名称";
    [self.view addSubview:textF];
    __weak typeof(self) weakSelf = self;
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(12);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textF.mas_bottom);
        make.left.equalTo(textF.mas_left);
        make.right.equalTo(textF.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.textColor = SetColor(203, 203, 203, 1);
    label.text = @"选择颜色";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(12);
        make.left.equalTo(line.mas_left);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 40, 10, 40);
    layout.minimumLineSpacing = 20.0;
    layout.minimumInteritemSpacing = 20.0;
    CGFloat item_width = (SCREENBOUNDS.width - 120) / 3;
    layout.itemSize = CGSizeMake(item_width, 27);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[ScheduleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ViewRadius(cell, 5.0);
    NSArray *color_array = self.dataArray[indexPath.row];
    cell.backgroundColor = SetColor([color_array[0] integerValue], [color_array[1] integerValue], [color_array[2] integerValue], 1);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCollectionViewCell *cell = (ScheduleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSecelt = YES;
    self.select_index = indexPath.row;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCollectionViewCell *cell = (ScheduleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSecelt = NO;
}

//确定
- (void)confirmAction {
    if ([self.tag_string isEqualToString:@""]) {
        [self showHUDWithTitle:@"标签名称不能为空"];
        return;
    }
    
    if (self.select_index == -1) {
        [self showHUDWithTitle:@"请选择标签颜色"];
        return;
    }
    
    NSArray *color_array = self.dataArray[self.select_index];
    if ([_delegate respondsToSelector:@selector(returnTag_content:Color_R:Color_G:Color_B:)]) {
        [_delegate returnTag_content:self.tag_string Color_R:color_array[0] Color_G:color_array[1] Color_B:color_array[2]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark --- textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.tag_string = textField.text;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
