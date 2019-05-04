//
//  Tips_AddSummarizeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Tips_AddSummarizeViewController.h"
#import "TipsCollectionViewCell.h"
#import "SummarizeBookTableViewCell.h"
#import "AddQuestionViewController.h"
#import "SummarizeBookViewController.h"
//选择图片
#import <QBImagePickerController.h>

#import "QuestionModel.h"
#import "AnswerModel.h"

@interface Tips_AddSummarizeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, QBImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableview;

//是否需要选择题目进行删除操作
@property (nonatomic, assign) BOOL isChooseQuestion;

@property (nonatomic, strong) UIButton *edit_button;

//将要删除的题目列表
@property (nonatomic, strong) NSMutableArray *selected_delete_array;

@property (nonatomic, strong) NSString *textview_tipsID_string;

@end

@implementation Tips_AddSummarizeViewController

- (void)setTableview_data_array:(NSMutableArray *)tableview_data_array {
    _tableview_data_array = tableview_data_array;
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    UIImage *first_image = [UIImage imageNamed:@"add_image"];
    [self.imageArray addObject:first_image];
    
    //初始化
    self.selected_delete_array = [NSMutableArray arrayWithCapacity:1];
    
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish_action)];
    self.navigationItem.rightBarButtonItem = right;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 20.0;
    CGFloat item_width = (SCREENBOUNDS.width - 20 * 5) / 4;
    layout.itemSize = CGSizeMake(item_width, item_width);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getTipsNotesDetails];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageview.image = self.imageArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 300);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 200);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            [self setCollectionviewHeader_view:header_view];
        }
        return header_view;
    }
    UICollectionReusableView *footer_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        for (UIView *vv in footer_view.subviews) {
            [vv removeFromSuperview];
        }
        [self setCollectionviewFooter_view:footer_view];
    }
    return footer_view;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self presentSelectImageVC];
    }
}

//跳转选择图片页面
- (void)presentSelectImageVC {
    QBImagePickerController *imagePicker = [[QBImagePickerController alloc] init];
    imagePicker.allowsMultipleSelection = YES;
    imagePicker.showsNumberOfSelectedAssets = YES;
    imagePicker.mediaType = QBImagePickerMediaTypeImage;
    imagePicker.delegate = self;
    imagePicker.automaticallyAdjustsScrollViewInsets = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark --- QBImagePickerController delegate
//选取图片完成回调
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.imageArray removeAllObjects];
        UIImage *first_image = [UIImage imageNamed:@"add_image"];
        [weakSelf.imageArray addObject:first_image];
        for (PHAsset *asset in assets) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            // 同步获得图片, 只会返回1张图片
            options.synchronous = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [weakSelf.imageArray addObject:result];
            }];
        }
        [weakSelf.collectionview reloadSections:[NSIndexSet indexSetWithIndex:1]];
    }];
}

//点击取消回调
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//设置collectionview的header上的tableview
- (void)setCollectionviewHeader_view:(UICollectionReusableView *)header_view {
    [header_view addSubview:self.tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setCollectionviewFooter_view:(UICollectionReusableView *)footer_view {
    self.textview = [[UITextView alloc] init];
    self.textview.textColor = DetailTextColor;
    self.textview.font = SetFont(14);
    if (self.tips_id) {
        self.textview.text = self.textview_tipsID_string;
    }else {
        self.textview.text = @"总结";
    }
    [footer_view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
}

#pragma mark --- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableview_data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionModel *model = self.tableview_data_array[indexPath.row];
    SummarizeBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.isHiddenSummarizeLabel = YES;
    cell.isSupportSelect = self.isChooseQuestion;
    cell.content_label.text = model.question_content;
    cell.answer_label_A.text = [NSString stringWithFormat:@"A:%@", ((AnswerModel *)model.answer_array[0]).answer_content];
    cell.answer_label_B.text = [NSString stringWithFormat:@"B:%@", ((AnswerModel *)model.answer_array[1]).answer_content];
    cell.answer_label_C.text = [NSString stringWithFormat:@"C:%@", ((AnswerModel *)model.answer_array[2]).answer_content];
    cell.answer_label_D.text = [NSString stringWithFormat:@"D:%@", ((AnswerModel *)model.answer_array[3]).answer_content];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.0;
}

//设置tableview Footer  content
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = WhiteColor;
    UIButton *add_more = [UIButton buttonWithType:UIButtonTypeCustom];
    add_more.titleLabel.font = SetFont(14);
    ViewBorderRadius(add_more, 5.0, 1.0, ButtonColor);
    [add_more setTitleColor:ButtonColor forState:UIControlStateNormal];
    [add_more setTitle:@"添加更多" forState:UIControlStateNormal];
    [add_more addTarget:self action:@selector(chooseMoreQuestionAction) forControlEvents:UIControlEventTouchUpInside];
    [footer_view addSubview:add_more];
    [add_more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer_view.mas_left).offset(20);
        make.centerY.equalTo(footer_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(240, 30));
    }];
    
    
    [footer_view addSubview:self.edit_button];
    [self.edit_button setTitle:@"编辑" forState:UIControlStateNormal];
    [self.edit_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(add_more.mas_right).offset(20);
        make.centerY.equalTo(footer_view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //若是可选择状态  进行删除   若不是   则进行跳转
    if (self.isChooseQuestion) {
        __weak typeof(self) weakSelf = self;
        QuestionModel *model = self.tableview_data_array[indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否删除" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定删除");
            [weakSelf.tableview_data_array removeObject:model];
            [weakSelf.tableview reloadData];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消删除");
        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        self.isChooseQuestion = NO;
        [self.edit_button setSelected:NO];
        [self.edit_button setTitle:@"编辑" forState:UIControlStateNormal];
        [self.tableview reloadData];
    } else {
        //点击进行跳转到解析界面
    }
}

//懒加载   编辑按钮
- (UIButton *)edit_button {
    if (!_edit_button) {
        _edit_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _edit_button.titleLabel.font = SetFont(14);
        _edit_button.backgroundColor = ButtonColor;
        [_edit_button setTitleColor:WhiteColor forState:UIControlStateNormal];
        ViewRadius(_edit_button, 5.0);
        [_edit_button addTarget:self action:@selector(edit_button_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _edit_button;
}

#pragma mark ----- tableview
//懒加载    防止刷新collectionview的时间  重复创建
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 140.0;
        [_tableview registerClass:[SummarizeBookTableViewCell class] forCellReuseIdentifier:@"tableCell"];
    }
    return _tableview;
}

//编辑方法
- (void)edit_button_action:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.edit_button setTitle:@"确定" forState:UIControlStateSelected];
        self.isChooseQuestion = YES;
        [self.tableview reloadData];
    }else {
        [self.edit_button setTitle:@"编辑" forState:UIControlStateNormal];
        self.isChooseQuestion = NO;
        [self.tableview reloadData];
    }
}

//添加更多
- (void)chooseMoreQuestionAction {
//    self.AddMoreQuestionBlock(self.tableview_data_array);
//    [self.navigationController popViewControllerAnimated:YES];
    AddQuestionViewController *add = [[AddQuestionViewController alloc] init];
    add.selected_array = self.tableview_data_array;
    add.isNewCreat = NO;
    [self.navigationController pushViewController:add animated:YES];
}

//提交数据
- (void)finish_action {
    //如果有ID的话  就删除总结记录  重新添加数据
    if (self.tips_id) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *parma = @{@"id_":self.tips_id};
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_total_note" Dic:parma SuccessBlock:^(id responseObject) {
            NSLog(@"delete === %@", responseObject);
            if ([responseObject[@"state"] integerValue] == 1) {
                [weakSelf submitDataToService];
            }
        } FailureBlock:^(id error) {
            
        }];
    }else {
        [self submitDataToService];
    }
}

//导航栏左侧完成方法
- (void)submitDataToService {
    //选择的题目ID数组
    NSMutableArray *id_array = [NSMutableArray arrayWithCapacity:1];
    for (QuestionModel *model in self.tableview_data_array) {
        [id_array addObject:model.question_id];
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:id_array options:kNilOptions error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSLog(@"id_array string === %@", jsonString);
    
    //整理图片数组
    [self.imageArray removeObjectAtIndex:0];
    
    NSLog(@"imageArray == %@", self.imageArray);
    
    NSDictionary *parma = @{
                            @"content_":self.textview.text,
                            @"question_id_":jsonString,
                            @"type_":@"1"
                            };
    NSLog(@"parma === %@", parma);
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_tips_total" Dic:parma imageArray:self.imageArray SuccessBlock:^(id responseObject) {
        NSLog(@"add tips result == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf backSummarizeBookHomeVC];
        }
    } FailureBlock:^(id error) {
        
    }];
    
    
}

- (void)backSummarizeBookHomeVC {
    for (UIViewController *control in self.navigationController.viewControllers) {
        if ([control isKindOfClass:[SummarizeBookViewController class]]) {
            SummarizeBookViewController *summarize = (SummarizeBookViewController *)control;
            [self.navigationController popToViewController:summarize animated:YES];
            UIButton *button = (UIButton *)[summarize.view viewWithTag:100];
            [summarize changeBookType:button];
        }
    }
}

//获取tips笔记的详情
- (void)getTipsNotesDetails {
    if (!self.tips_id) {
        [self showHUDWithTitle:@"tipsID为空"];
        return;
    }
    NSDictionary *parma = @{@"id_":self.tips_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_total_detail" Dic:parma SuccessBlock:^(id responseObject) {
//        NSLog(@"tips details == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *dataMutable = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *question_data in responseObject[@"data"][@"question_rows"]) {
                QuestionModel *model = [[QuestionModel alloc] init];
                model.question_id = question_data[@"id_"];                          //ID
                model.question_type = @"单选题";//question_data[@"tp_module_title_"];           //单选多选
                model.question_content = question_data[@"content_"];                //题干
                model.question_picture_array = question_data[@"question_choice_picture_result"];
                //答案数据转Model
                NSMutableArray *answer_array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *answer_data in question_data[@"tp_options_result"]) {
                    AnswerModel *answer_model = [[AnswerModel alloc] init];
                    answer_model.answer_id = answer_data[@"id_"];
                    answer_model.answer_content_image = answer_data[@"question_picture_id_"];
                    answer_model.answer_content = answer_data[@"content_"];
                    [answer_array addObject:answer_model];
                }
                model.answer_array = [answer_array copy];
                [dataMutable addObject:model];
            }
            weakSelf.tableview_data_array = [dataMutable copy];
            [weakSelf.tableview reloadData];
            
            weakSelf.textview_tipsID_string = responseObject[@"data"][@"total_content_"];
            
            for (NSString *image_base64_string in responseObject[@"data"][@"total_picture_result_"]) {
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:image_base64_string]];
                UIImage *image = [UIImage imageWithData:imageData];
                [weakSelf.imageArray addObject:image];
            }
//            [weakSelf.imageArray insertObject:[UIImage imageNamed:@"add_image"] atIndex:0];
            [weakSelf.collectionview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
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
