//
//  SugestBackViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SugestBackViewController.h"
#import <QBImagePickerController.h>
#import "TipsCollectionViewCell.h"

@interface SugestBackViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, QBImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UICollectionReusableView *header_view;

@property (nonatomic, strong) UIView *header_back_view;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UITextView *textview;

@end

@implementation SugestBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布评价";
    [self setBack];
    self.type = 1;
    
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    [self.imageArray addObject:[UIImage imageNamed:@"add_image"]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 20.0;
    CGFloat item_width = (SCREENBOUNDS.width - 20 * 5) / 4;
    layout.itemSize = CGSizeMake(item_width, item_width);
    layout.headerReferenceSize = CGSizeMake(SCREENBOUNDS.width, 370.0);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    
    UIButton *publish_button = [UIButton buttonWithType:UIButtonTypeCustom];
    publish_button.backgroundColor = SetColor(48, 132, 252, 1);
    [publish_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [publish_button setTitle:@"提交" forState:UIControlStateNormal];
    ViewRadius(publish_button, 20.0);
    [self.view addSubview:publish_button];
    [publish_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(40.0);
    }];
    [publish_button addTarget:self action:@selector(submitDataToService) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageview.image = self.imageArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    self.header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    [self.header_view addSubview:self.header_back_view];
    
    return self.header_view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self presentSelectImageVC];
    }
}

- (UIView *)header_back_view {
    if (!_header_back_view) {
        _header_back_view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 370.0)];
        [self setHeaderViewContent:_header_back_view];
    }
    return _header_back_view;
}

- (void)setHeaderViewContent:(UIView *)header_view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(32);
    label.text = @"意见反馈";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(5);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(14);
    label1.textColor = DetailTextColor;
    label1.text = @"请选择您的意见类型";
    [header_view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
    }];
    
    //建议
    CGFloat button_width = SCREENBOUNDS.width / 2;
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.tag = 100;
    self.button.titleLabel.font = SetFont(16);
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateNormal];
    [self.button setTitle:@"建议" forState:UIControlStateNormal];
    [self.button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [header_view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(20);
        make.left.equalTo(header_view.mas_left);
        make.size.mas_equalTo(CGSizeMake(button_width, 50.0));
    }];
    [self.button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) weakSelf = self;
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button1.tag = 200;
    self.button1.titleLabel.font = SetFont(16);
    [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button1 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
    [self.button1 setTitle:@"问题" forState:UIControlStateNormal];
    [self.button1 setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [header_view addSubview:self.button1];
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.button.mas_right);
        make.size.mas_equalTo(CGSizeMake(button_width, 50.0));
    }];
    [self.button1 addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textview = [[UITextView alloc] init];
    self.textview.backgroundColor = SetColor(246, 246, 246, 1);
    self.textview.font = SetFont(14);
    self.textview.textColor = DetailTextColor;
    self.textview.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.textview.text = @"请尽可能详细的描述意见或建议，以便我们快速更新～";
    ViewRadius(self.textview, 8.0);
    [header_view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.button.mas_bottom).offset(5);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(200);
    }];
}

#pragma mark --- select image
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
    [weakSelf.collectionview reloadData];
}

//点击取消回调
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeType:(UIButton *)sender {
    UIButton *button = (UIButton *)[self.header_back_view viewWithTag:100];
    UIButton *button1 = (UIButton *)[self.header_back_view viewWithTag:200];
    if (sender.tag == 100) {
        self.type = 1;
        [button setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
    }else {
        self.type = 2;
        [button setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateNormal];
    }
}

//提交数据
- (void)submitDataToService {
    [self.imageArray removeObjectAtIndex:0];
    NSDictionary *param = @{@"phone_":[[NSUserDefaults standardUserDefaults] objectForKey:@"account"],
                            @"type_":@(self.type),
                            @"content_":self.textview.text
                            };
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/user/insert_user_feedback" Dic:param imageArray:self.imageArray SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"上传问题成功！！！！");
        }else {
            NSLog(@"上传问题失败！！！！");
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
