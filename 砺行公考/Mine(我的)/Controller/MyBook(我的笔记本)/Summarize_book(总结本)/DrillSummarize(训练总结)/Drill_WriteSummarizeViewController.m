//
//  Drill_WriteSummarizeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Drill_WriteSummarizeViewController.h"
#import "SummarizeBookViewController.h"
//选择图片
#import <QBImagePickerController.h>
#import "BottomShowMaterialsView.h"
#import "QuanZhenTestModel.h"

@interface Drill_WriteSummarizeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QBImagePickerControllerDelegate>

//题目内容
@property (nonatomic, strong) NSString *question_content_string;

//通过ID获取的总结内容
@property (nonatomic, strong) NSString *summarize_string;

@property (nonatomic, strong) UIView *back_view;

@property (nonatomic, strong) NSString *answerString;

@property (nonatomic, strong) NSArray *meterial_array;

@end

@implementation Drill_WriteSummarizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    UIImage *first_image = [UIImage imageNamed:@"add_image"];
    [self.imageArray addObject:first_image];
    
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
    [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //通过Drill_id 获取详情
    [self getHttpDataWithDrillID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageview.image = self.imageArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
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
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.imageArray removeAllObjects];
    UIImage *first_image = [UIImage imageNamed:@"add_image"];
    [self.imageArray addObject:first_image];
    __weak typeof(self) weakSelf = self;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    for (PHAsset *asset in assets) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [weakSelf.imageArray addObject:result];
        }];
    }
    [weakSelf.collectionview reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

//点击取消回调
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat height = [self calculateRowHeight:self.dataModel.drill_question_content fontSize:16 withWidth:SCREENBOUNDS.width - 40];
        return CGSizeMake(SCREENBOUNDS.width, height + 310);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [self setHeader_view:header];
    return header;
}

- (void)setHeader_view:(UICollectionReusableView *)header_view {
    UIButton *look_answer_button = [UIButton buttonWithType:UIButtonTypeCustom];
    look_answer_button.titleLabel.font = SetFont(14);
    [look_answer_button setTitleColor:SetColor(58, 58, 58, 1) forState:UIControlStateNormal];
    [look_answer_button setTitle:@"查看答案" forState:UIControlStateNormal];
    ViewBorderRadius(look_answer_button, 15.0, 1.0, ButtonColor);
    [header_view addSubview:look_answer_button];
    [look_answer_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(85, 30));
    }];
    [look_answer_button addTarget:self action:@selector(lookAnswerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *look_material_button = [UIButton buttonWithType:UIButtonTypeCustom];
    look_material_button.titleLabel.font = SetFont(14);
    [look_material_button setTitleColor:SetColor(58, 58, 58, 1) forState:UIControlStateNormal];
    [look_material_button setTitle:@"查看材料" forState:UIControlStateNormal];
    ViewBorderRadius(look_material_button, 15.0, 1.0, ButtonColor);
    [header_view addSubview:look_material_button];
    [look_material_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(look_answer_button.mas_right).offset(40);
        make.size.mas_equalTo(CGSizeMake(85, 30));
    }];
    [look_material_button addTarget:self action:@selector(lookMaterialsAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *choose_question_button = [UIButton buttonWithType:UIButtonTypeCustom];
    choose_question_button.titleLabel.font = SetFont(14);
    [choose_question_button setTitleColor:SetColor(58, 58, 58, 1) forState:UIControlStateNormal];
    [choose_question_button setTitle:@"选择试题" forState:UIControlStateNormal];
    ViewBorderRadius(choose_question_button, 15.0, 1.0, ButtonColor);
    [header_view addSubview:choose_question_button];
    [choose_question_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(look_material_button.mas_right).offset(40);
        make.size.mas_equalTo(CGSizeMake(85, 30));
    }];
    choose_question_button.hidden = YES;//self.isShowSelectQuestion;
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(look_answer_button.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(10);
    label.textColor = SetColor(79, 79, 79, 1);
    label.text = @"浙江省2017年 副省级 A卷 27题";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(line.mas_left);
    }];
    
    UILabel *content_label = [[UILabel alloc] init];
    content_label.font = SetFont(16);
    content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    content_label.numberOfLines = 0;
    if (self.Drill_details_id) {
        content_label.text = self.question_content_string;
    }else {
        content_label.text = self.dataModel.drill_question_content;
    }
    [header_view addSubview:content_label];
    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(line.mas_left);
        make.right.equalTo(line.mas_right);
    }];
    
    self.textview = [[UITextView alloc] init];
    self.textview.textColor = SetColor(192, 192, 192, 1);
    self.textview.font = SetFont(14);
    if (self.Drill_details_id) {
        self.textview.text = self.summarize_string;
    }else {
        self.textview.text = @"添加总结";
    }
    [header_view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content_label.mas_bottom).offset(20);
        make.left.equalTo(content_label.mas_left);
        make.right.equalTo(content_label.mas_right);
        make.bottom.equalTo(header_view.mas_bottom).offset(-10);
    }];
}

//提交数据
- (void)finish_action {
    //如果有ID的话  就删除总结记录  重新添加数据
    if (self.Drill_details_id) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *parma = @{@"id_":self.Drill_details_id};
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

- (void)submitDataToService {
    NSLog(@"model  id  === %@", self.dataModel.drill_question_id);
    if ([self.textview.text isEqualToString:@"添加总结"]) {
        [self showHUDWithTitle:@"请填写总结内容"];
    }else {
        //选择的题目ID数组
        NSMutableArray *id_array = [NSMutableArray arrayWithCapacity:1];
        [id_array addObject:self.dataModel.drill_question_id ?: self.Drill_question_id];
        
        NSLog(@"id_array == %@", id_array);
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:id_array options:kNilOptions error:&error];

        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

//        NSLog(@"id_array string === %@", jsonString);
        
        //整理图片数组
        [self.imageArray removeObjectAtIndex:0];
        NSDictionary *parma = @{
                                @"content_":self.textview.text,
                                @"question_id_":jsonString,
                                @"type_":@"4"
                                };
        __weak typeof(self) weakSelf = self;
        [self showHUD];
        [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_tips_total" Dic:parma imageArray:self.imageArray SuccessBlock:^(id responseObject) {
            NSLog(@"add drill result == %@", responseObject);
            [weakSelf hidden];
            if ([responseObject[@"state"] integerValue] == 1) {
                [weakSelf backToSummarizeBookHomeWithLookDrilSummarize];
            }
        } FailureBlock:^(id error) {
            [weakSelf hidden];
        }];
    }
}


//返回到总结本首页   并查看训练总结
- (void)backToSummarizeBookHomeWithLookDrilSummarize {
    for (UIViewController *control in self.navigationController.viewControllers) {
        if ([control isKindOfClass:[SummarizeBookViewController class]]) {
            SummarizeBookViewController *sum = (SummarizeBookViewController *)control;
            [self.navigationController popToViewController:sum animated:YES];
            UIButton *button = (UIButton *)[sum.view viewWithTag:103];
            [sum changeBookType:button];
        }
    }
}

//通过训练ID获取训练总结本内容
- (void)getHttpDataWithDrillID {
    if (!self.Drill_details_id) {
//        [self showHUDWithTitle:@"drillID为空"];
        return;
    }
    [self.imageArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    NSDictionary *parma = @{@"id_":self.Drill_details_id};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_total_detail" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"drill details == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            
            NSArray *require_list = responseObject[@"data"][@"essay_result"][@"content_list_"];
            NSString *require_string = require_list.count == 0 ? @"\n" : [@"\n" stringByAppendingString: require_list[0]];
            weakSelf.question_content_string = [responseObject[@"data"][@"essay_result"][@"title_"] stringByAppendingString:require_string];
            weakSelf.summarize_string = responseObject[@"data"][@"content_"];
            
            weakSelf.answerString = [responseObject[@"data"][@"essay_result"][@"parsing_list_"] count] == 0 ? @"" : responseObject[@"data"][@"essay_result"][@"parsing_list_"][0];
            
            
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"question_material_result"]) {
                EssayTestQuanZhenMaterialsModel *model = [[EssayTestQuanZhenMaterialsModel alloc] init];
                model.materials_id = dic[@"id_"];
                model.materials_content = dic[@"content_"];
                model.materials_image_array = dic[@"question_material_picture_"];
                [data addObject:model];
            }
            weakSelf.meterial_array = [data copy];
            
            
            for (NSString *image_url in responseObject[@"data"][@"total_picture_result_"]) {
                //将图片链接  转换成data
                NSData *image_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:image_url]];
                UIImage *image = [UIImage imageWithData:image_data];
                [weakSelf.imageArray addObject:image];
            }
            [weakSelf.imageArray insertObject:[UIImage imageNamed:@"add_image"] atIndex:0];
            [weakSelf.collectionview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

/** 查看答案 */
- (void)lookAnswerButtonAction {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.back_view = [[UIView alloc] initWithFrame:app.window.bounds];
    self.back_view.backgroundColor = SetColor(155, 155, 155, 0.8);
    [app.window addSubview:self.back_view];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAnswerView)];
    self.back_view.userInteractionEnabled = YES;
    [self.back_view addGestureRecognizer:tapGes];
    
    __weak typeof(self) weakSelf = self;
    UILabel *answer_label = [[UILabel alloc] init];
    answer_label.font = SetFont(14);
    answer_label.numberOfLines = 0;
    answer_label.text = self.answerString;
    [self.back_view addSubview:answer_label];
    [answer_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.back_view.mas_left).offset(20);
        make.bottom.equalTo(weakSelf.back_view.mas_bottom).offset(-20);
        make.right.equalTo(weakSelf.back_view.mas_right).offset(-20);
    }];
}

- (void)removeAnswerView {
    [self.back_view removeFromSuperview];
}

/**
 查看材料
 */
- (void)lookMaterialsAction {
    [self showMaterialsView:self.meterial_array];
}

//显示材料
- (void)showMaterialsView:(NSArray *)array {
    [self.view endEditing:YES];
    AppDelegate *current_window = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BottomShowMaterialsView *materials_view = [[BottomShowMaterialsView alloc] initWithFrame:current_window.window.bounds];
    materials_view.dataArray = array;
    [current_window.window addSubview:materials_view];
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
