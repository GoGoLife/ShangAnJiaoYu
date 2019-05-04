//
//  DigestContentViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DigestContentViewController.h"
#import "ChangeBookIndexView.h"
#import "DigestView.h"
#import "CreatBookView.h"
#import <QBImagePickerController.h>
#import "LookContentViewController.h"
#import "ChatViewController.h"
#import "SearchDigestViewController.h"

@interface DigestContentViewController ()<UITableViewDelegate, UITableViewDataSource, ChangeBookIndexViewDelegate, QBImagePickerControllerDelegate, DigestViewDelegate>

@property (nonatomic, strong) ChangeBookIndexView *changeBookIndex_view;

@property (nonatomic, strong) DigestView *digest;

@property (nonatomic, strong) CreatBookView *creat_book;

@property (nonatomic, strong) ChatViewController *chatVC;

@end

@implementation DigestContentViewController

//获取笔记本下的数据
- (void)getHttpData {
//    NSLog(@"zhaijiben   book_id === %@", self.book_id);
    NSDictionary *parma = @{
        @"id_":self.book_id,
        @"is_sorting_":@"1"
    };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_abstract" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"responseobject === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    //初始化
    self.seleted_array = [NSMutableArray arrayWithCapacity:1];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(right_action)];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_search_action)];
    self.navigationItem.rightBarButtonItems = @[right, right1];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BookContentTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.view addSubview:self.changeBookIndex_view];
    self.changeBookIndex_view.hidden = YES;
    [self.changeBookIndex_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom);
        make.left.equalTo(weakSelf.tableview.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.tableview.mas_right);
    }];
    
    [self getHttpData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    BookContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isHiddenTitle = YES;
    cell.isHiddenStarlevel = NO;
    cell.isCanSelect = self.isEdit;
    cell.content_lable.text = dic[@"content_"];
    //摘记标签
    NSArray *label_array = dic[@"label_result_"];
    NSString *label_string = [label_array componentsJoinedByString:@","];
    cell.date_label.text = [NSString stringWithFormat:@"%@  %@", dic[@"create_time_"], label_string];
    cell.starLevel_view.score = [dic[@"star_"] floatValue];
    if ([self.seleted_array containsObject:dic[@"id_"]]) {
        cell.select_image.image = [UIImage imageNamed:@"select_yes"];
    }else {
        cell.select_image.image = [UIImage imageNamed:@"select_no"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString *string = [NSString stringWithFormat:@"简介：%@", self.book_details];
        CGFloat height = [self calculateRowHeight:string fontSize:16 withWidth:SCREENBOUNDS.width - 40];
        return height + 210;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    if (section == 0) {
        header_view.backgroundColor = WhiteColor;
        [self setHeaderView:header_view];
    }
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (self.isEdit) {
        BookContentTableViewCell *cell = (BookContentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (self.isSend) {
            if ([self.seleted_array containsObject:dataDic]) {
                [self.seleted_array removeObject:dataDic];
                cell.select_image.image = [UIImage imageNamed:@"select_no"];
            }else {
                [self.seleted_array addObject:dataDic];
                cell.select_image.image = [UIImage imageNamed:@"select_yes"];
            }
        }else {
            NSString *digest_id = dataDic[@"id_"];
            if ([self.seleted_array containsObject:digest_id]) {
                [self.seleted_array removeObject:digest_id];
                cell.select_image.image = [UIImage imageNamed:@"select_no"];
            }else {
                [self.seleted_array addObject:digest_id];
                cell.select_image.image = [UIImage imageNamed:@"select_yes"];
            }
        }
    }else {
        LookContentViewController *content = [[LookContentViewController alloc] init];
//        content.contentDic = dataDic;
        content.digest_id = dataDic[@"id_"];
        [self.navigationController pushViewController:content animated:YES];
    }
}

//开始编辑
- (void)right_action {
    UIBarButtonItem *right_one = self.navigationItem.rightBarButtonItems[0];
    if (self.isSend) {
//        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(right_send_action)];
//        self.navigationItem.rightBarButtonItem = right;
        right_one.title = @"发送";
        right_one.action = @selector(right_send_action);
        self.isEdit = YES;
        [self.tableview reloadData];
        return;
    }
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel_edit_action)];
//    self.navigationItem.rightBarButtonItem = right;
    right_one.title = @"取消";
    right_one.action = @selector(cancel_edit_action);
    self.isEdit = YES;
    self.changeBookIndex_view.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-50);
    }];
    [self.tableview reloadData];
}

//取消编辑
- (void)cancel_edit_action {
//    self.navigationItem.rightBarButtonItem = nil;
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(right_action)];
//    self.navigationItem.rightBarButtonItem = right;
    UIBarButtonItem *right_one = self.navigationItem.rightBarButtonItems[0];
    right_one.title = @"编辑";
    right_one.action = @selector(right_action);
    self.isEdit = NO;
    self.changeBookIndex_view.hidden = YES;
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(0);
    }];
    [self.tableview reloadData];
}

- (void)right_send_action {
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(right_action)];
    self.navigationItem.rightBarButtonItem = right;
    self.isEdit = NO;
    [self.tableview reloadData];
    
    NSMutableArray *messageArr = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *data in self.seleted_array) {
        [messageArr addObject:@{@"type":@"摘记",
                                @"id":data[@"id_"],
                                @"message":data[@"content_"],
                                @"type_":@"",
                                @"id__":data[@"id_"],
                                @"message_attr_is_excerpt_content":data[@"content_"],
                                @"message_attr_is_excerpt":@(1)
                                }];
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChatViewController class]]) {
            self.chatVC =(ChatViewController *)controller;
            
            for (NSDictionary *dic in messageArr) {
                [self.chatVC sendRecommendFriend:dic];
            }

            [self.navigationController popToViewController:self.chatVC animated:YES];
        }
    }
}

- (void)setHeaderView:(UIView *)header_view {
    UIImageView *header_image = [[UIImageView alloc] init];
    [header_image sd_setImageWithURL:[NSURL URLWithString:self.book_image_url] placeholderImage:[UIImage imageNamed:@"no_image"]];
    ViewRadius(header_image, 8.0);
    [header_view addSubview:header_image];
    [header_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(20);
        make.centerX.equalTo(header_view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    label.text = self.book_name;//@"特别有感觉的句子";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header_view.mas_centerX);
        make.top.equalTo(header_image.mas_bottom).offset(10);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(12);
    label1.textColor = DetailTextColor;
    label1.text = [NSString stringWithFormat:@"已收录%@条", self.book_numbers];//@"已收录213条";
    [header_view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header_view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(10);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = SetFont(16);
    label2.textColor = DetailTextColor;
    label2.numberOfLines = 0;
    label2.text = [NSString stringWithFormat:@"简介：%@", self.book_details];//@"简介：里面都是一些我觉得特别有感觉的.......句子，相当的感觉的.......句子，相当的感觉的.......句子，相当的感觉的.......句子，相当的棒...";
    [header_view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
    }];
}

/** 搜索 */
- (void)rightItem_search_action {
    __weak typeof(self) weakSelf = self;
    SearchDigestViewController *searchDigest = [[SearchDigestViewController alloc] init];
    searchDigest.returnSearchContentWithTagID = ^(NSString * _Nonnull content, NSArray * _Nonnull tag_id_array, NSString * _Nonnull type) {
        [weakSelf getDataWithSearchContent:content withTagIDArray:tag_id_array withType:type];
    };
    [self.navigationController pushViewController:searchDigest animated:YES];
}

- (void)getDataWithSearchContent:(NSString *)content withTagIDArray:(NSArray *)array withType:(NSString *)type {
    NSDictionary *param = @{@"content":content,
                            @"note_id":self.book_id,
                            @"label_id_list":array,
                            @"type":type,
                            @"sidx":@"create_time_",
                            @"sort":@"desc",
                            @"page_number":@"1",
                            @"page_size":@"100"};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_abstract_list" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"][@"rows"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
    }];
}

#pragma mark ---- //懒加载 ----
- (ChangeBookIndexView *)changeBookIndex_view {
    if (!_changeBookIndex_view) {
        _changeBookIndex_view = [[ChangeBookIndexView alloc] init];
        _changeBookIndex_view.delegate = self;
    }
    return _changeBookIndex_view;
}

#pragma mark ---- change book index delegate

/**
 改变笔记位置的代理方法

 @param changeType 100 === 删除   200 ==== 移动   300 === 复制
 */
- (void)ChangeBookIndexAction:(NSInteger)changeType {
    if (changeType == 100) {
        //将数组转为json格式
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.seleted_array options:kNilOptions error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"jsonstring === %@", jsonString);
        NSLog(@"selected array === %@", self.seleted_array);
        
        
        NSDictionary *parma = @{@"id_":self.seleted_array};
        NSLog(@"parma === %@", parma);
        __weak typeof(self) weakSelf = self;
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/delete_abstract" Dic:parma SuccessBlock:^(id responseObject) {
            NSLog(@"response == %@", responseObject);
            if ([responseObject[@"state"] integerValue] == 1) {
                [weakSelf showHUDWithTitle:@"删除成功"];
                [weakSelf.seleted_array removeAllObjects];
                [weakSelf getHttpData];
            }
        } FailureBlock:^(id error) {
            NSLog(@"error == %@", error);
        }];
    }else if (changeType == 200) {
        //移动
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.digest = [[DigestView alloc] init];
        self.digest.type = OPRATION_TYPE_MOVE;
        self.digest.delegate = self;
        //赋值
        self.digest.moveOrCopy_data_array = [self.seleted_array copy];
        [app.window addSubview:self.digest];
        [self.digest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(app.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        __weak typeof(self) weakSelf = self;
        //点击了新建摘记本按钮的回调
        self.digest.creatBookBlock = ^{
            weakSelf.digest.hidden = YES;
            [weakSelf addCreatBookView];
        };
    }else {
        //复制
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.digest = [[DigestView alloc] init];
        self.digest.type = OPRATION_TYPE_COPY;
        self.digest.delegate = self;
        //赋值
        self.digest.moveOrCopy_data_array = [self.seleted_array copy];
        [app.window addSubview:self.digest];
        [self.digest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(app.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        __weak typeof(self) weakSelf = self;
        //点击了新建摘记本按钮的回调
        self.digest.creatBookBlock = ^{
            weakSelf.digest.hidden = YES;
            [weakSelf addCreatBookView];
        };
    }
}

//新建摘记本
- (void)addCreatBookView {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.creat_book = [[CreatBookView alloc] init];
    [self.creat_book.add_image_button addTarget:self action:@selector(add_image_creat_header) forControlEvents:UIControlEventTouchUpInside];
    //返回输入的摘记本的name
    //        __block CreatBookView *block_creat = weakSelf.creat_book;
    __weak typeof(self) weakSelf = self;
    self.creat_book.returnBookNameBlock = ^(NSString *name) {
        //        NSLog(@"name === %@", name);
        [weakSelf.creat_book removeView];
        weakSelf.digest.hidden = NO;
        [weakSelf.digest getHttpData];
    };
    [app.window addSubview:self.creat_book];
    [self.creat_book mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark ==================== DigestView delegate
- (void)finishOprationAction {
    [self.seleted_array removeAllObjects];
    [self getHttpData];
    [self cancel_edit_action];
}

#pragma mark ---- 创建笔记本的选择图片的系列方法
//调用选择图片方法
- (void)add_image_creat_header {
    self.creat_book.hidden = YES;
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
        [weakSelf.creat_book.book_header_image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
        }];
        weakSelf.creat_book.book_header_image.image = result;
        weakSelf.creat_book.result_image = result;
    }];
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.creat_book.hidden = NO;
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
