//
//  ProveViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/22.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ProveViewController.h"
#import "ProveReusableView.h"
#import <QBImagePickerController.h>
#import "TipsCollectionViewCell.h"

@interface ProveViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, QBImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSMutableArray *imageArray;

/** 个人信息 */
@property (nonatomic, strong) NSMutableArray *info_array;

/** 是否接受条例 */
@property (nonatomic, assign) BOOL isAccept;

@end

@implementation ProveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"经济困难学生认证服务";
    [self setBack];
    
    self.isAccept = NO;
    
    self.info_array = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 6; i++) {
        [self.info_array addObject:@""];
    }
    
    [self setleftOrRight:@"right" BarButtonItemWithImage:[UIImage imageNamed:@"mine_4"] target:self action:@selector(touchRightItemAction)];
    
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    [self.imageArray addObject:[UIImage imageNamed:@"add_image"]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 20.0;
    CGFloat item_width = (SCREENBOUNDS.width - 20 * 5) / 4;
    layout.itemSize = CGSizeMake(item_width, item_width);
    layout.headerReferenceSize = CGSizeMake(SCREENBOUNDS.width, PROVE_HEIGHT);
    layout.footerReferenceSize = CGSizeMake(SCREENBOUNDS.width, 170.0);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionview registerClass:[ProveReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
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
    if (kind == UICollectionElementKindSectionHeader) {
        ProveReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        //获取填写的个人信息
        __weak typeof(self) weakSelf = self;
        header_view.returnTextfieldContentAndIndex = ^(NSString * _Nonnull content, NSInteger index) {
            //替换空字符串
            [weakSelf.info_array replaceObjectAtIndex:index withObject:content];
        };
        return header_view;
    }else {
        UICollectionReusableView *footer_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        [self setFooterContent:footer_view];
        return footer_view;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self presentSelectImageVC];
    }
}

#pragma mark ---- set footer view
- (void)setFooterContent:(UICollectionReusableView *)footerview {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"mine_5"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"mine_3"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(changeButtonStateAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerview.mas_top).offset(30);
        make.left.equalTo(footerview.mas_left).offset(60);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @"我已阅读并接受《砺行教育贫困生条例》";
    [footerview addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right).offset(5);
        make.centerY.equalTo(button.mas_centerY);
    }];
    
    UIButton *submit_button = [UIButton buttonWithType:UIButtonTypeCustom];
    submit_button.titleLabel.font = SetFont(14);
    submit_button.backgroundColor = SetColor(48, 132, 252, 1);
    [submit_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [submit_button setTitle:@"确认无误，提交审核" forState:UIControlStateNormal];
    ViewRadius(submit_button, 20.0);
    [footerview addSubview:submit_button];
    [submit_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.centerX.equalTo(footerview.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREENBOUNDS.width / 2, 40.0));
    }];
    [submit_button addTarget:self action:@selector(touchSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *detailsLabel = [[UILabel alloc] init];
    detailsLabel.font = SetFont(12);
    detailsLabel.textColor = DetailTextColor;
    detailsLabel.text = @"审核结果将在三个工作日内通知您，请耐心等待，谢谢配合！";
    [footerview addSubview:detailsLabel];
    [detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(footerview.mas_bottom).offset(-20);
        make.centerX.equalTo(footerview.mas_centerX);
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

- (void)touchRightItemAction {
    
}

- (void)changeButtonStateAction:(UIButton *)sender {
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"mine_3"] forState:UIControlStateNormal];
        self.isAccept = YES;
    }else {
        [sender setImage:[UIImage imageNamed:@"mine_5"] forState:UIControlStateNormal];
        self.isAccept = NO;
    }
    sender.selected = !sender.selected;
}

- (void)touchSubmitAction {
    BOOL isComplate = NO;
    for (NSString *string in self.info_array) {
        if ([string isEqualToString:@""]) {
            isComplate = NO;
            break;
        }
        isComplate = YES;
    }
    
    if (!isComplate) {
        //表明信息填写不完整
        [self showHUDWithTitle:@"请填写完整信息"];
    }else {
        [self submitDataToService:self.info_array];
    }
}

- (void)submitDataToService:(NSArray *)info {
    if (!self.isAccept) {
        [self showHUDWithTitle:@"请同意《砺行条例》"];
        return;
    }
    
    [self.imageArray removeObjectAtIndex:0];
    
    if (self.imageArray.count == 0) {
        [self showHUDWithTitle:@"请上传相关材料"];
        return;
    }
    
    NSDictionary *parma = @{@"name_":info[0],
                            @"birth_":[KPDateTool getTimeStrWithString:[info[1] stringByAppendingString:@" 00:00:00"]],
                            @"sex_":[info[2] isEqualToString:@"男"] ? @"1" : @"2",
                            @"nation_":info[3],
                            @"number_":info[4],
                            @"class_":info[5]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_poors" Dic:parma imageArray:self.imageArray SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [weakSelf showHUDWithTitle:@"上传失败"];
            [weakSelf.imageArray insertObject:[UIImage imageNamed:@"add_image"] atIndex:0];
        }
    } FailureBlock:^(id error) {
        [weakSelf showHUDWithTitle:@"上传失败"];
        [weakSelf.imageArray insertObject:[UIImage imageNamed:@"add_image"] atIndex:0];
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
