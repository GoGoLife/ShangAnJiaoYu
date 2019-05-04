//
//  PublishDynamicViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "PublishDynamicViewController.h"
#import "TipsCollectionViewCell.h"
#import <QBImagePickerController.h>

@interface PublishDynamicViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, QBImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSString *content;

@end

@implementation PublishDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发布考伴动态";
    
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    UIImage *first_image = [UIImage imageNamed:@"add_image"];
    [self.imageArray addObject:first_image];
    
    [self setBack];
    
    self.content = @"请填写考伴动态内容";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publichAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    CGFloat width = (SCREENBOUNDS.width - 70) / 4;
    layout.itemSize = CGSizeMake(width, width);
    layout.headerReferenceSize = CGSizeMake(SCREENBOUNDS.width, 200);
    
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
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
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
    UICollectionReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    for (UIView *vv in header_view.subviews) {
        [vv removeFromSuperview];
    }
    UITextView *textview = [[UITextView alloc] init];
    textview.delegate = self;
    textview.font = SetFont(16);
    textview.textColor = [UIColor grayColor];
    textview.text = self.content;//@"请填写考伴动态内容";
    [header_view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    return header_view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
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

#pragma mark --- textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请填写考伴动态内容"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"请填写考伴动态内容";
        textView.textColor = [UIColor grayColor];
    }else {
        self.content = textView.text;
    }
}



//发布动态方法
- (void)publichAction {
    if ([self.content isEqualToString:@"请填写考伴动态内容"]) {
        [self showHUDWithTitle:@"请填写考伴动态内容"];
        return;
    }
    
    [self.imageArray removeObjectAtIndex:0];
    
    NSDictionary *parma = @{@"content_":self.content};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_moment" Dic:parma imageArray:self.imageArray SuccessBlock:^(id responseObject) {
        NSLog(@"response === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHUDWithTitle:@"发布成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } FailureBlock:^(id error) {
        NSLog(@"error === %@", error);
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
