//
//  ChangeOrCreatBookViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ChangeOrCreatBookViewController.h"
#import <QBImagePickerController.h>
#import <UIImageView+WebCache.h>

@interface ChangeOrCreatBookViewController ()<QBImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView *book_header_image;

//选择的图片  用于上传
@property (nonatomic, strong) UIImage *result_image;

@property (nonatomic, strong) UITextField *book_name_textF;

@property (nonatomic, strong) UITextView *detail_textview;

@end

@implementation ChangeOrCreatBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    if (self.type == BOOK_TYPE_CREATE) {
        self.title = @"新建笔记本";
    }else {
        self.title = @"编辑笔记本";
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(removeBookAction)];
        [right setTintColor:[UIColor redColor]];
        self.navigationItem.rightBarButtonItem = right;
    }
    
    self.book_name_textF = [[UITextField alloc] init];
    self.book_name_textF.font = SetFont(16);
    if (self.type == BOOK_TYPE_CHANGE) {
        self.book_name_textF.text = self.book_name;
        self.book_name_textF.textColor = [UIColor blackColor];
    }
    self.book_name_textF.placeholder = @"笔记本名称";
    [self.view addSubview:self.book_name_textF];
    __weak typeof(self) weakSelf = self;
    [self.book_name_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.book_name_textF.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.book_name_textF.mas_left);
        make.right.equalTo(weakSelf.book_name_textF.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    self.detail_textview = [[UITextView alloc] init];
    self.detail_textview.font = SetFont(16);
    if (self.type == BOOK_TYPE_CHANGE) {
        self.detail_textview.text = self.book_details;
        self.detail_textview.textColor = [UIColor blackColor];
    }else {
        self.detail_textview.text = @"笔记本描述";
        self.detail_textview.textColor = SetColor(192, 192, 192, 1);
    }
    [self.view addSubview:self.detail_textview];
    [self.detail_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(line.mas_left);
        make.right.equalTo(line.mas_right);
        make.height.mas_equalTo(100);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = @"选择/修改封面";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detail_textview.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.detail_textview.mas_left);
    }];
    
    self.book_header_image = [[UIImageView alloc] init];
    ViewRadius(self.book_header_image, 8.0);
    [self.view addSubview:self.book_header_image];
    //新建笔记本
    if (self.type == BOOK_TYPE_CREATE) {
        [self.book_header_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(20);
            make.left.equalTo(label.mas_left);
            make.size.mas_equalTo(CGSizeMake(0, 70));
        }];
    }else {
        //修改
        [self.book_header_image sd_setImageWithURL:[NSURL URLWithString:self.book_image_url] placeholderImage:[UIImage imageNamed:@"no_image"]];
        [self.book_header_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(20);
            make.left.equalTo(label.mas_left);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
    }
    
    //添加图片
    UIButton *add_image_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [add_image_button setImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
    [add_image_button addTarget:self action:@selector(add_image_button_action) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(add_image_button, 8.0);
    [self.view addSubview:add_image_button];
    [add_image_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.book_header_image.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.book_header_image.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    
    UIButton *submit_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    submit_button.backgroundColor = ButtonColor;
    if (self.type == BOOK_TYPE_CREATE) {
        [submit_button setTitle:@"确认新建" forState:UIControlStateNormal];
    }else {
        [submit_button setTitle:@"确认修改" forState:UIControlStateNormal];
    }
    ViewRadius(submit_button, 25.0);
    [submit_button addTarget:self action:@selector(submitBookInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit_button];
    [submit_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(add_image_button.mas_bottom).offset(40);
        make.left.equalTo(line.mas_left);
        make.right.equalTo(line.mas_right);
        make.height.mas_equalTo(50.0);
    }];
}


//调用选择图片方法
- (void)add_image_button_action {
    QBImagePickerController *imagePicker = [[QBImagePickerController alloc] init];
    imagePicker.maximumNumberOfSelection = 1;
    imagePicker.allowsMultipleSelection = YES;
    imagePicker.showsNumberOfSelectedAssets = YES;
    imagePicker.mediaType = QBImagePickerMediaTypeImage;
    imagePicker.delegate = self;
    imagePicker.automaticallyAdjustsScrollViewInsets = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
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
        if (weakSelf.type == BOOK_TYPE_CREATE) {
            [weakSelf.book_header_image mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(70);
            }];
        }
        weakSelf.book_header_image.image = result;
        weakSelf.result_image = result;
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击取消回调
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//删除笔记本
- (void)removeBookAction {
    NSDictionary *parma = @{@"id_":self.book_id};
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_note" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
//            [weakSelf showHUDWithTitle:@"删除笔记本成功"];
            [weakSelf hidden];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
//            [weakSelf showHUDWithTitle:@"删除失败"];
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
}

//提交修改  新增信息
- (void)submitBookInfoAction {
    if (self.type == BOOK_TYPE_CHANGE) {
        //修改
        if (!self.result_image) {
//            [self showHUDWithTitle:@"请选择笔记本封面"];
//            return;
            NSLog(@"未改变笔记本封面图片");
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.book_image_url]];
            self.result_image = [UIImage imageWithData:imageData];
        }
        
        NSDictionary *parma = @{
                                @"id_" : self.book_id,
                                @"name_":self.book_name_textF.text,
                                @"desc_":self.detail_textview.text
//                                @"type_":self.book_type
                                };
        __weak typeof(self) weakSelf = self;
        [self showHUD];
        [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/update_note" Dic:parma imageArray:@[self.result_image] SuccessBlock:^(id responseObject) {
            NSLog(@"success === %@", responseObject);
            [weakSelf hidden];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } FailureBlock:^(id error) {
            NSLog(@"error === %@", error);
            [weakSelf hidden];
        }];
        
    }else {
        //新增
        if (!self.result_image) {
            [self showHUDWithTitle:@"请选择笔记本封面"];
            return;
        }
        NSDictionary *parma = @{
                                @"name_":self.book_name_textF.text,
                                @"desc_":self.detail_textview.text,
                                @"type_":self.book_type
                                };
        __weak typeof(self) weakSelf = self;
        [self showHUD];
        [MOLoadHTTPManager PostHttpFormWithUrlStr:@"/app_user/ass/insert_note" Dic:parma imageArray:@[self.result_image] SuccessBlock:^(id responseObject) {
            NSLog(@"success === %@", responseObject);
            [weakSelf hidden];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } FailureBlock:^(id error) {
            NSLog(@"error === %@", error);
            [weakSelf hidden];
        }];
    }
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
