//
//  CreatBookView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/8.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CreatBookView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "MOLoadHTTPManager.h"
#import <MBProgressHUD.h>
#import <QBImagePickerController.h>

@interface CreatBookView()<QBImagePickerControllerDelegate>

@property (nonatomic, strong) UITextField *textF;

@end

@implementation CreatBookView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = SetColor(39, 39, 39, 0.5);
        [self setContentToView:self];
    }
    return self;
}

- (void)setContentToView:(UIView *)back_view {
    UIView *small_view = [[UIView alloc] init];
    small_view.backgroundColor = WhiteColor;
    [back_view addSubview:small_view];
    [small_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(130, 50, 130, 50));
    }];
    
    //返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.backgroundColor = [UIColor blackColor];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [small_view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(small_view.mas_top).offset(20);
        make.left.equalTo(small_view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = SetFont(16);
    titleLabel.text = @"新建摘记本";
    [small_view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backButton.mas_top);
        make.centerX.equalTo(small_view.mas_centerX);
    }];
    
    //保存
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    saveButton.backgroundColor = [UIColor redColor];
    [saveButton setImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(returnBookName) forControlEvents:UIControlEventTouchUpInside];
    [small_view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(small_view.mas_top).offset(20);
        make.right.equalTo(small_view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    //摘记本名称
    self.textF = [[UITextField alloc] init];
    self.textF.font = SetFont(14);
    self.textF.placeholder = @"摘记本名称...";
    self.textF.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(self.textF, 8.0);
    [small_view addSubview:self.textF];
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.equalTo(small_view.mas_left).offset(20);
        make.right.equalTo(small_view.mas_right).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @"摘记本封面";
    [small_view addSubview:label];
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textF.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.textF.mas_left);
    }];
    
    self.book_header_image = [[UIImageView alloc] init];
    self.book_header_image.backgroundColor = RandomColor;
    ViewRadius(self.book_header_image, 8.0);
    [small_view addSubview:self.book_header_image];
    //新建笔记本
    if (!self.result_image) {
        [self.book_header_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(20);
            make.left.equalTo(label.mas_left);
            make.size.mas_equalTo(CGSizeMake(0, 70));
        }];
    }else {
        [self.book_header_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(20);
            make.left.equalTo(label.mas_left);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
    }
    
    //添加图片
    self.add_image_button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    add_image_button.backgroundColor = RandomColor;
    [self.add_image_button setImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
    ViewRadius(self.add_image_button, 8.0);
    [self.add_image_button addTarget:self action:@selector(selectHeaderImageAction) forControlEvents:UIControlEventTouchUpInside];
    [small_view addSubview:self.add_image_button];
    [self.add_image_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.book_header_image.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.book_header_image.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
}

- (void)selectHeaderImageAction {
    [self add_image_creat_header];
}

#pragma mark ---- 创建笔记本的选择图片的系列方法
//调用选择图片方法
- (void)add_image_creat_header {
    self.hidden = YES;
    QBImagePickerController *imagePicker = [[QBImagePickerController alloc] init];
    imagePicker.maximumNumberOfSelection = 1;
    imagePicker.allowsMultipleSelection = YES;
    imagePicker.showsNumberOfSelectedAssets = YES;
    imagePicker.mediaType = QBImagePickerMediaTypeImage;
    imagePicker.delegate = self;
    imagePicker.automaticallyAdjustsScrollViewInsets = NO;
    [[self getCurrentVC] presentViewController:imagePicker animated:YES completion:nil];
}

//选取的图片回调
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(PHAsset *)asset {
    NSLog(@"select  select");
    
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    PHAsset *asset = [assets firstObject];
    __weak typeof(self) weakSelf = self;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [weakSelf.book_header_image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
        }];
        weakSelf.book_header_image.image = result;
        weakSelf.result_image = result;
    }];
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:^{
        weakSelf.hidden = NO;
    }];
}



//保存方法    将数据上传到服务器  并返回到上一个界面
- (void)returnBookName {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    //新增
    if (!self.result_image) {
        hud.labelText = @"请选择封面";
        [hud hide:YES afterDelay:1.0];
        return;
    }
    NSDictionary *parma = @{
                            @"name_":self.textF.text,
                            @"desc_":@"",
                            @"type_": self.type == 1 ? @"1" : @"4"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_note" Dic:parma imageArray:@[self.result_image] SuccessBlock:^(id responseObject) {
        NSLog(@"success === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [hud hide:YES];
            weakSelf.returnBookNameBlock(weakSelf.textF.text);
        }else {
            hud.labelText = responseObject[@"msg"];
            [hud hide:YES];
        }
    } FailureBlock:^(id error) {
        hud.labelText = @"接口出错";
        [hud hide:YES];
        NSLog(@"error === %@", error);
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

- (void)removeView {
    self.backBlock();
//    [self removeFromSuperview];
}

@end
