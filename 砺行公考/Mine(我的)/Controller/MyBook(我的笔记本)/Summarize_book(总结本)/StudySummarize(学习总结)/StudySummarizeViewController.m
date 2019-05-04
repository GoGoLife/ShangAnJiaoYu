//
//  StudySummarizeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/4.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "StudySummarizeViewController.h"


#import "SummarizeBookViewController.h"

#import <QBImagePickerController.h>

@interface StudySummarizeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QBImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

//标题
@property (nonatomic, strong) NSString *title_string;

//考试状态
@property (nonatomic, strong) NSString *tpstatus_string;
//方法收获
@property (nonatomic, strong) NSString *tpget_string;
//考试困惑
@property (nonatomic, strong) NSString *tpconfuse_string;
//解决方案
@property (nonatomic, strong) NSString *tpsolve_string;
//自我提醒
@property (nonatomic, strong) NSString *tpremind_string;

@end

@implementation StudySummarizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.title = @"考试总结";
    
    self.tpstatus_string = @"考试状态";
    self.tpget_string = @"方法收获";
    self.tpconfuse_string = @"方法困惑";
    self.tpsolve_string = @"解决方案";
    self.tpremind_string = @"自我提醒";
    self.title_string = @"";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish_action)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    UIImage *first_image = [UIImage imageNamed:@"add_image"];
    [self.imageArray addObject:first_image];
    
    
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
    
    
    [self getHttpDataWithID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    if (self.study_id) {
//        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"no_image"]];
//    }else {
//        
//    }
    cell.imageview.image = self.imageArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 500);
    }
    return CGSizeZero;
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
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [weakSelf.imageArray addObject:result];
        }];
    }
    [weakSelf.collectionview reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

//点击取消回调
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    for (UIView *vv in header.subviews) {
        [vv removeFromSuperview];
    }
    [self setHeader_view:header];
    return header;
}

- (void)setHeader_view:(UICollectionReusableView *)header_view {
    self.title_textfield = [[UITextField alloc] init];
    self.title_textfield.delegate = self;
    self.title_textfield.font = SetFont(16);
    self.title_textfield.textColor = SetColor(192, 192, 192, 1);
    self.title_textfield.text = self.title_string;
    self.title_textfield.placeholder = @"标题";
    [header_view addSubview:self.title_textfield];
    [self.title_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    __weak typeof(self) weakSelf = self;
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.title_textfield.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.title_textfield.mas_left);
        make.right.equalTo(weakSelf.title_textfield.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = SetColor(192, 192, 192, 1);
    label.text = @"添加总结";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(line.mas_left);
    }];
    
//    self.tptime_string = [self.tptime_string isEqualToString:@"考试时间"] ? @"考试时间" : self.tptime_string;
    self.tpstatus_string = [self.tpstatus_string isEqualToString:@"考试状态"] ? @"考试状态" : self.tpstatus_string;//@"考试状态";
    self.tpget_string = [self.tpget_string isEqualToString:@"方法收获"] ? @"方法收获" : self.tpget_string;//@"方法收获";
    self.tpconfuse_string = [self.tpconfuse_string isEqualToString:@"方法困惑"] ? @"方法困惑" : self.tpconfuse_string;//@"方法困惑";
    self.tpsolve_string = [self.tpsolve_string isEqualToString:@"解决方案"] ? @"解决方案" : self.tpsolve_string;//@"解决方案";
    self.tpremind_string = [self.tpremind_string isEqualToString:@"自我提醒"] ? @"自我提醒" : self.tpremind_string;//@"自我提醒";
    NSArray *title_array = @[self.tpstatus_string, self.tpget_string, self.tpconfuse_string, self.tpsolve_string, self.tpremind_string];
    CGFloat height = 60.0;
    for (NSInteger index = 0; index < title_array.count; index++) {
        UITextView *textview = [[UITextView alloc] init];
        textview.tag = index + 100;
        textview.delegate = self;
        ViewBorderRadius(textview, 5.0, 1.0, SetColor(246, 246, 246, 1));
        textview.font = SetFont(14);
        textview.textColor = SetColor(192, 192, 192, 1);
        textview.text = title_array[index];
        [header_view addSubview:textview];
        [textview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(10 + (height + 10) * index);
            make.left.equalTo(line.mas_left);
            make.right.equalTo(line.mas_right);
            make.height.mas_equalTo(height);
        }];
    }
}

#pragma mark ---- textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.title_string = textField.text;
}

#pragma mark ------- textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    switch (textView.tag - 100) {
        case 0:
            self.tpstatus_string = textView.text;
            break;
        case 1:
            self.tpget_string = textView.text;
            break;
        case 2:
            self.tpconfuse_string = textView.text;
            break;
        case 3:
            self.tpsolve_string = textView.text;
            break;
        case 4:
            self.tpremind_string = textView.text;
            break;
            
        default:
            break;
    }
}

//提交数据
- (void)finish_action {
    //如果有ID的话  就删除总结记录  重新添加数据
    if (self.study_id) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *parma = @{@"id_":self.study_id};
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_total_note" Dic:parma SuccessBlock:^(id responseObject) {
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
    if ([self.title_string isEqualToString:@""] &&
        [self.tpstatus_string isEqualToString:@"考试状态"] &&
        [self.tpget_string isEqualToString:@"方法收获"] &&
        [self.tpconfuse_string isEqualToString:@"方法困惑"] &&
        [self.tpsolve_string isEqualToString:@"解决方案"] &&
        [self.tpremind_string isEqualToString:@"自我提醒"] &&
        self.imageArray.count == 1) {
        [self showHUDWithTitle:@"请填写考试总结内容"];
        return;
    }
    
    NSDictionary *parma = @{
                            @"title_":[self.title_string isEqualToString:@""] ? @" " : self.title_string,
                            @"tp_time_":@" ",
                            @"tp_status_":[self.tpstatus_string isEqualToString:@"考试状态"] ? @" " : self.tpstatus_string,
                            @"tp_get_":[self.tpget_string isEqualToString:@"方法收获"] ? @" " : self.tpget_string,
                            @"tp_confuse_":[self.tpconfuse_string isEqualToString:@"方法困惑"] ? @" " : self.tpconfuse_string,
                            @"tp_solve_":[self.tpsolve_string isEqualToString:@"解决方案"] ? @" " : self.tpsolve_string,
                            @"tp_remind_":[self.tpremind_string isEqualToString:@"自我提醒"] ? @" " : self.tpremind_string,
                            @"type_":@"3",
                            };
    
    NSLog(@"xuexi parma == %@", parma);
    
    [self.imageArray removeObjectAtIndex:0];
    
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_exam_total" Dic:parma imageArray:self.imageArray SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            //百度统计
            NSString *class_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"class_name"] ?: @"";
            [[BaiduMobStat defaultStat] logEvent:@"WriteSummarize000" eventLabel:@"总结撰写次数" attributes:@{@"class":class_name}];
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
            UIButton *button = (UIButton *)[summarize.view viewWithTag:102];
            [summarize changeBookType:button];
        }
    }
}

- (void)getHttpDataWithID {
    if (!self.study_id) {
        return;
    }
    [self.imageArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    NSDictionary *parma = @{@"id_":self.study_id};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_total_detail" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.title_string = responseObject[@"data"][@"total_content_"][0][@"title_"];
            weakSelf.tpstatus_string = responseObject[@"data"][@"total_content_"][0][@"tp_status_"];
            weakSelf.tpget_string = responseObject[@"data"][@"total_content_"][0][@"tp_get_"];
            weakSelf.tpconfuse_string = responseObject[@"data"][@"total_content_"][0][@"tp_confuse_"];
            weakSelf.tpsolve_string = responseObject[@"data"][@"total_content_"][0][@"tp_solve_"];
            weakSelf.tpremind_string = responseObject[@"data"][@"total_content_"][0][@"tp_remind_"];
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
