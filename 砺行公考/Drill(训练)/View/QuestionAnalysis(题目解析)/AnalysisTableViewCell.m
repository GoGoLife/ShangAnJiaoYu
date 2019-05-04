//
//  AnalysisTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/9.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AnalysisTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "ErrorTagCollectionViewCell.h"
#import "ErrorTagModel.h"
#import "BaseViewController.h"

@interface AnalysisTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *back_view;

//点击解析Button
@property (nonatomic, strong) UIButton *button;

//解析Label
@property (nonatomic, strong) UILabel *label;

//用于显示错因标签
@property (nonatomic, strong) UICollectionView *collectionview;

//header 说明
@property (nonatomic, strong) UILabel *tagLabel;

//错因标签   编辑Button
@property (nonatomic, strong) UIButton *editButton;

//是否显示错因标签的编辑按钮
@property (nonatomic, assign) BOOL isEditErrorTag;

@property (nonatomic, strong) UIView *second_view;

@end

@implementation AnalysisTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.back_view];
        __weak typeof(self) weakSelf = self;
        [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.isEditErrorTag = NO;
        [self firstLayout];
    }
    return self;
}

//第一次布局
- (void)firstLayout {
    __weak typeof(self) weakSelf = self;
    [self.back_view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.back_view.mas_top).offset(10);
        make.left.equalTo(weakSelf.back_view.mas_left).offset(20);
    }];
    
    
    [self.back_view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.label.mas_left);
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
}

- (void)touchAnalysisAction {
    //传递点击事件   刷新页面
     self.touchAnslysisAction();
}

- (void)layoutSubviews {
    //进行二次布局
    if (self.bounds.size.height > ANALYSIS_FIRST_CELL_HEIGHT) {
        [self.button removeFromSuperview];
        [self startSecondLayout];
    }else {
        [self.second_view removeFromSuperview];
        [self firstLayout];
    }
}

//二次布局
- (void)startSecondLayout {
    __weak typeof(self) weakSelf = self;
    self.second_view = [[UIView alloc] init];
    self.second_view.backgroundColor = WhiteColor;
    [self.back_view addSubview:self.second_view];
    [self.second_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.back_view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //答案
    UILabel *answerLabel = [[UILabel alloc] init];
    answerLabel.font = SetFont(18);
    answerLabel.text = [NSString stringWithFormat:@"本题答案：%@", self.correct_answer_string];
    [self.second_view addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.label.mas_left);
    }];
    
    //砺行方法
    self.analysis_function_label = [[UILabel alloc] init];
    self.analysis_function_label.font = SetFont(16);
    self.analysis_function_label.textColor = SetColor(74, 74, 74, 1);
    self.analysis_function_label.numberOfLines = 0;
    self.analysis_function_label.text = self.analysis_function_string;
    [self.second_view addSubview:self.analysis_function_label];
    [self.analysis_function_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answerLabel.mas_bottom).offset(10);
        make.left.equalTo(answerLabel.mas_left);
        make.right.equalTo(weakSelf.second_view.mas_right).offset(-20);
    }];
    
    //答案解析
    self.analysisLabel = [[UILabel alloc] init];
    self.analysisLabel.font = SetFont(16);
    self.analysisLabel.textColor = SetColor(74, 74, 74, 1);
    self.analysisLabel.numberOfLines = 0;
    self.analysisLabel.text = self.analysisString;
    [self.second_view addSubview:self.analysisLabel];
    [self.analysisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.analysis_function_label.mas_bottom).offset(0);
        make.left.equalTo(answerLabel.mas_left);
        make.right.equalTo(weakSelf.second_view.mas_right).offset(-20);
    }];
    
    UILabel *stars_label = [[UILabel alloc] init];
    stars_label.font = SetFont(16);
    stars_label.textColor = SetColor(74, 74, 74, 1);
    stars_label.text = @"星级难度：";
    [self.second_view addSubview:stars_label];
    [stars_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.analysisLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.analysisLabel.mas_left);
    }];
    
    self.stars_view = [[StarsView alloc] initWithStarSize:CGSizeMake(15, 15) space:15 numberOfStar:5];
    self.stars_view.selectable = NO;
    self.stars_view.score = self.stars_score;
    [self.second_view addSubview:self.stars_view];
    [self.stars_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stars_label.mas_right).offset(20);
        make.centerY.equalTo(stars_label.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(SCREENBOUNDS.width - 100.0);
    }];
    
    //精解挑刺
    UIButton *analysisButton = [UIButton buttonWithType:UIButtonTypeCustom];
    analysisButton.titleLabel.font = SetFont(14);
    [analysisButton setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
    [analysisButton setTitle:@"精解挑刺" forState:UIControlStateNormal];
    ViewBorderRadius(analysisButton, 0.0, 0.5, SetColor(242, 242, 242, 1));
    [self.second_view addSubview:analysisButton];
    //按钮宽度
    CGFloat button_width = SCREENBOUNDS.width;
    [analysisButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.stars_view.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.second_view.mas_left);
        make.size.mas_equalTo(CGSizeMake(button_width, 50));
    }];
    [analysisButton addTarget:self action:@selector(touchFineSolutionAction) forControlEvents:UIControlEventTouchUpInside];
    
    //添加tips并保存到总结本
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.titleLabel.font = SetFont(14);
    [saveButton setTitleColor:SetColor(74, 74, 74, 1) forState:UIControlStateNormal];
    [saveButton setTitle:@"添加tips并保存到总结本" forState:UIControlStateNormal];
    ViewBorderRadius(saveButton, 0.0, 0.5, SetColor(242, 242, 242, 1));
    [self.second_view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(analysisButton.mas_bottom);
        make.left.equalTo(analysisButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREENBOUNDS.width, 50));
    }];
    [saveButton addTarget:self action:@selector(touchSaveTipsAction) forControlEvents:UIControlEventTouchUpInside];
    
    //错因标签
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[ErrorTagCollectionViewCell class] forCellWithReuseIdentifier:@"tagCell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.second_view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveButton.mas_bottom);
        make.left.equalTo(weakSelf.second_view.mas_left);
        make.right.equalTo(weakSelf.second_view.mas_right);
        make.bottom.equalTo(weakSelf.second_view.mas_bottom);
    }];
    
}

#pragma mark --- 懒加载
- (UIView *)back_view {
    if (!_back_view) {
        _back_view = [[UIView alloc] init];
        _back_view.userInteractionEnabled = YES;
        _back_view.backgroundColor = WhiteColor;
    }
    return _back_view;
}

#pragma mark --- collection delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.errorTagArry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ErrorTagModel *model = self.errorTagArry[indexPath.row];
    ErrorTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagCell" forIndexPath:indexPath];
    cell.contentLable.text = model.tagString;
    if (self.isEditErrorTag) {
        cell.isShowEditButton = YES;
    }else {
        cell.isShowEditButton = NO;
    }
    return cell;
}

#pragma mark --- flowlayout delegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ErrorTagModel *model = self.errorTagArry[indexPath.row];
    if (self.isEditErrorTag) {
        return CGSizeMake(model.tagWidth + 44, 30);
    }
    return CGSizeMake(model.tagWidth + 30, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENBOUNDS.width, 40.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [self setCollectionViewHeader:header_view];
    return header_view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.errorTagArry.count - 1) {
        //点击最后一个是添加
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"添加标签" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"输入标签";
        }];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *tag_string = alert.textFields.firstObject.text;
            
            [weakSelf addNewErrorTag:tag_string];
            
        }]];
        [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
        
    }else {
        ErrorTagModel *model = self.errorTagArry[indexPath.row];
        BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
        [baseVC showHUDWithTitle:model.tagString];
    }
}

- (void)setCollectionViewHeader:(UIView *)header {
    [header addSubview:self.tagLabel];
    self.tagLabel.text = @"错因标签";
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_top).offset(10);
        make.left.equalTo(header.mas_left).offset(20);
    }];
    
    __weak typeof(self) weakSelf = self;
    [header addSubview:self.editButton];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(touchEditAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header.mas_right).offset(-20);
        make.centerY.equalTo(weakSelf.tagLabel.mas_centerY);
    }];
}

//点击编辑错因标签
- (void)touchEditAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.isEditErrorTag = YES;
        [self.editButton setTitle:@"确认" forState:UIControlStateSelected];
        [self.collectionview reloadData];
    }else {
        self.isEditErrorTag = NO;
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.collectionview reloadData];
    }
}

#pragma mark --- 懒加载
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = SetFont(14);
        _label.textColor = DetailTextColor;
        _label.text = @"解析";
    }
    return _label;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = SetFont(14);
        [_button setTitle:@"点击查看精解" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        ViewBorderRadius(_button, 5.0, 1.0, SetColor(240, 240, 240, 1));
        [_button addTarget:self action:@selector(touchAnalysisAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = SetFont(14);
        _tagLabel.textColor = DetailTextColor;
    }
    return _tagLabel;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitleColor:SetColor(48, 132, 252, 1) forState:UIControlStateNormal];
        _editButton.titleLabel.font = SetFont(14);
    }
    return _editButton;
}

//点击精解挑刺按钮
- (void)touchFineSolutionAction {
    if ([_delegate respondsToSelector:@selector(touchFineSolutionAction)]) {
        [_delegate touchFineSolutionAction];
    }
}

//点击添加到tips总结
- (void)touchSaveTipsAction {
    if ([_delegate respondsToSelector:@selector(touchSaveToSummarizeBook)]) {
        [_delegate touchSaveToSummarizeBook];
    }
}

- (void)addNewErrorTag:(NSString *)text {
    NSDictionary *param = @{@"question_choice_id_":self.question_id,
                            @"label_list_":@[text]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_user_error_label" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
            [baseVC showHUDWithTitle:@"添加成功"];
            //block
            weakSelf.AddErrorTagSuccessAction();
        }
    } FailureBlock:^(id error) {
        
    }];
}

//获取Window当前显示的ViewController
- (UIViewController*)getCurrentVC{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
