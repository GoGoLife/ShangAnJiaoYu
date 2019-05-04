//
//  VideoDetailViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "CommentHeaderView.h"
#import "CommentTableViewCell.h"
#import "CommentFooterView.h"
#import "CommentModel.h"
#import "DigestView.h"
#import "CreatBookView.h"
#import <QBImagePickerController.h>
#import <SJVideoPlayer.h>
#import "TextViewMenu.h"

@interface VideoDetailViewController ()<UITableViewDelegate, UITableViewDataSource, QBImagePickerControllerDelegate, SJVideoPlayerControlLayerDelegate, SJVideoPlayerControlLayerDataSource, TextViewMenuDelegate>

@property (nonatomic, strong) UITableView *tableview;

//视频详解字符串
@property (nonatomic, strong) NSString *textString;

//所有评论数据
@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, strong) UIView *bottom_tool;

//展示详细内容   提供摘记入口
@property (nonatomic, strong) TextViewMenu *text;

//灰色遮罩层
@property (nonatomic, strong) UIView *background_view;

//创建笔记本
@property (nonatomic, strong) CreatBookView *creat_book;

//摘记本
@property (nonatomic, strong) DigestView *digest;

//视频播放器
@property (nonatomic, strong) SJVideoPlayer *videoPlayer;

//点击播放按钮
@property (nonatomic, strong) UIButton *play_button;

@end

@implementation VideoDetailViewController

StringHeight();

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textString = @"在这里发酵第六届法律框架的法律就暗示法律的框架阿迪宫颈癌施蒂利克烦死你了萨姆，。MVC，门口拉法大飞机快来撒封面，你看了时间啊辅导老师骄傲了开发商，封面，子女可垃圾风口浪尖安防机二手打开了几个卡拉是疯狂拉升女模，总分类进奥拉夫看见爱上离开房间诶绿山咖啡卢卡斯法萨芬疯狂拉升加点覅偶尔我经历过卡设计稿；家里积分卡酸辣粉及偶尔文件反馈了电视剧阿弗莱克 就打卡丽枫酒店时间啊覅而我给你撒";
//    self.commentArray = [NSMutableArray arrayWithCapacity:1];
//    for (NSInteger index = 0; index < 4; index++) {
//        CommentModel *model = [[CommentModel alloc] init];
//        model.headerURL = @"";
//        model.nickName = @"王八犊子";
//        model.tagString = @"初入茅庐";
//        model.dateString = @"22分钟前";
//        model.contentString = @"这道题很难哈哈哈哈哈哈哈哈这道题很难哈哈哈哈哈哈哈哈这道题很难哈哈哈哈哈哈哈哈这道题很难哈哈哈哈哈哈哈哈这道题很难哈哈哈哈哈哈哈哈这道题很难哈哈哈哈哈哈哈哈";
////        model.replyString = @"你说啥：房间爱搜附近阿里斯柯达结构设计冯老师世纪东方额偶奇偶解放东路设计稿就撒飞机哦IE忘记了卡公司";
//        //点赞数量
//        model.soptString = @"200";
//        //子评论数据
//        NSMutableArray *cell_comment_array = [NSMutableArray arrayWithCapacity:1];
//        for (NSInteger j = 0; j < 4; j++) {
//            CommentCellModel *cellModel = [[CommentCellModel alloc] init];
//            cellModel.cell_comment_id = @"";
//            cellModel.cell_user_name = @"评论人";
//            cellModel.cell_parent_name = @"被评论人";
//            cellModel.cell_comment_content = @"你说啥：房间爱搜附近阿里斯柯达结构设计冯老师世纪东方额偶奇偶解放东路设计稿就撒飞机哦IE忘记了卡公司";
//            [cell_comment_array addObject:cellModel];
//        }
//        model.cellCommentData = [cell_comment_array copy];
////        [self.commentArray addObject:model];
//    }
    
    [self setUI];
    
    [self setBack];
}

- (void)setUI {
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(collectionAction)];
//    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(shareAction)];
//    self.navigationItem.rightBarButtonItems = @[right, right1];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"comment"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    self.bottom_tool = [[UIView alloc] init];
//    self.bottom_tool.backgroundColor = SetColor(238, 238, 238, 1);
////    [self.view addSubview:self.bottom_tool];
//    [self.bottom_tool mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.right.equalTo(weakSelf.view.mas_right);
//        make.bottom.equalTo(weakSelf.view.mas_bottom);
//        make.height.mas_equalTo(50);
//    }];
//
//    //添加输入框和表情按钮
//    [self setToolBarContent:self.bottom_tool];
    
    //注册按钮通知
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    /* 增加监听（当键盘退出时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setToolBarContent:(UIView *)tool {
    //表情按钮
    UIButton *emoijBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emoijBtn.backgroundColor = RandomColor;
    ViewRadius(emoijBtn, 15.0);
    [tool addSubview:emoijBtn];
    [emoijBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tool.mas_top).offset(10);
        make.right.equalTo(tool.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //评论输入框
    UITextField *textF = [[UITextField alloc] init];
    textF.backgroundColor = WhiteColor;
    
    textF.leftViewMode = UITextFieldViewModeAlways;
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 10, 10)];
    textF.leftView = left_label;
    
    textF.placeholder = @"写评论";
    ViewRadius(textF, 17.0);
    [tool addSubview:textF];
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tool.mas_top).offset(8);
        make.left.equalTo(tool.mas_left).offset(20);
        make.bottom.equalTo(tool.mas_bottom).offset(-8);
        make.right.equalTo(emoijBtn.mas_left).offset(-20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commentArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    CommentModel *model = self.commentArray[section - 1];
    return model.cellCommentData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    }
    CommentModel *model = self.commentArray[indexPath.section - 1];
    CommentCellModel *cellModel = model.cellCommentData[indexPath.row];
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
    }
    cell.content_label.text = cellModel.finish_comment_string;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.0;
    }
    CommentModel *model = self.commentArray[indexPath.section - 1];
    CommentCellModel *cellModel = model.cellCommentData[indexPath.row];
    return cellModel.cell_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat height = [self calculateRowHeight:self.textString fontSize:14 withWidth:SCREENBOUNDS.width - 40];
        return height + 210 + 50;
    }
    CommentModel *model = self.commentArray[section - 1];
    return model.header_view_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header_view = [[UIView alloc] init];
        header_view.backgroundColor = WhiteColor;
        [self setHeaderView:header_view];
        return header_view;
    }else {
        CommentModel *model = self.commentArray[section - 1];
        CommentHeaderView *header_view = [[CommentHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, model.header_view_height)];
        header_view.content_label.text = model.contentString;
        return header_view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header_view = [[UIView alloc] init];
        header_view.backgroundColor = WhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(16);
        label.text = @"评论（18）";
        [header_view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
        }];
        return header_view;
    }
    CommentModel *model = self.commentArray[section - 1];
    CommentFooterView *footer_view = [[CommentFooterView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40.0)];
    footer_view.parise_numbers_string = model.soptString;
    return footer_view;
}

#pragma mark ----  first headerview  video + detailsString
- (void)setHeaderView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(22);
    label.text = @"题库的使用指南,仅为你存在的视频";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(5);
        make.left.equalTo(view.mas_left).offset(20);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = SetFont(12);
    detailLabel.text = @"2017-08-01     砺行教材部";
    [view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.left.equalTo(label.mas_left);
    }];
    
    //视频播放器
    self.videoPlayer.controlLayerDelegate = self;
    self.videoPlayer.controlLayerDataSource = self;
    self.videoPlayer.view.frame = FRAME(20, 60, SCREENBOUNDS.width - 40, 180);
    [view addSubview:self.videoPlayer.view];
    self.videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://lixingjiaoyu.oss-cn-hangzhou.aliyuncs.com/test/picture/1544002208873.mp4"]];
    self.videoPlayer.autoPlay = NO;
    
    //添加点击播放按钮
    self.play_button = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.play_button.backgroundColor = [UIColor grayColor];
    [self.play_button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.play_button addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.play_button];
    __weak typeof(self) weakSelf = self;
    [self.play_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(weakSelf.videoPlayer.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.text = [[TextViewMenu alloc] initWithType:actionType_Digest];
    self.text.CustomDelegate = self;
    self.text.editable = NO;
    self.text.font = SetFont(14);
    self.text.text = self.textString;
    
    [view addSubview:self.text];
    CGFloat height = [self calculateRowHeight:self.textString fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLabel.mas_bottom).offset(180);
        make.left.equalTo(view.mas_left).offset(20);
        make.right.equalTo(view.mas_right).offset(-20);
        make.height.mas_equalTo(height + 20);
    }];
}

//键盘出现    实现方法
/**
 *  键盘弹出
 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    self.tableview.scrollEnabled = NO;
}

/**
 *  键盘退出
 */
- (void)keyboardWillHide:(NSNotification *)aNotification  {
    self.tableview.scrollEnabled = YES;
}

- (void)touchDigestAction {
//    [self.text resignFirstResponder];
    NSLog(@"text range == %@",   [self.text selectedTextRange]);
    
    NSLog(@"selected  text == %@",   [self.text textInRange:[self.text selectedTextRange]]);
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.digest = [[DigestView alloc] init];
    self.digest.type = OPRATION_TYPE_CREATE;
    self.digest.digest_content_string = [self.text textInRange:[self.text selectedTextRange]];
    [app.window addSubview:self.digest];
    [self.digest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    __weak typeof(self) weakSelf = self;
    //    __block DigestView *block_digest = digest;
    //点击了新建摘记本按钮的回调
    self.digest.creatBookBlock = ^{
        weakSelf.digest.hidden = YES;
        [weakSelf addCreatBookView];
    };
}

//展示摘记本页面
- (void)didClickCustomMenuAction {
    [self.text resignFirstResponder];
    NSLog(@"text range == %@",   [self.text selectedTextRange]);
    
    NSLog(@"selected  text == %@",   [self.text textInRange:[self.text selectedTextRange]]);
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.digest = [[DigestView alloc] init];
    self.digest.type = OPRATION_TYPE_CREATE;
    self.digest.digest_content_string = [self.text textInRange:[self.text selectedTextRange]];
    [app.window addSubview:self.digest];
    [self.digest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    __weak typeof(self) weakSelf = self;
//    __block DigestView *block_digest = digest;
    //点击了新建摘记本按钮的回调
    self.digest.creatBookBlock = ^{
        weakSelf.digest.hidden = YES;
        [weakSelf addCreatBookView];
    };
}

//新建摘记本
- (void)addCreatBookView {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.creat_book = [[CreatBookView alloc] init];
    self.creat_book.type = 1;
//    [self.creat_book.add_image_button addTarget:self action:@selector(add_image_creat_header) forControlEvents:UIControlEventTouchUpInside];
    //返回输入的摘记本的name
    //        __block CreatBookView *block_creat = weakSelf.creat_book;
    __weak typeof(self) weakSelf = self;
    self.creat_book.backBlock = ^{
        [weakSelf.creat_book removeFromSuperview];
        weakSelf.digest.hidden = NO;
    };
    
    
    self.creat_book.returnBookNameBlock = ^(NSString *name) {
//        NSLog(@"name === %@", name);
        [weakSelf.creat_book removeFromSuperview];
        weakSelf.digest.hidden = NO;
        [weakSelf.digest getHttpData];
    };
    [app.window addSubview:self.creat_book];
    [self.creat_book mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


//收藏
- (void)collectionAction {
    
}

//分享
- (void)shareAction {
    
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

#pragma mark ----- 懒加载
- (SJVideoPlayer *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[SJVideoPlayer alloc] init];
        _videoPlayer.disableAutoRotation = YES;
    }
    return _videoPlayer;
}

#pragma mark ---- SJVideoPlayer  delegate    datasource
//NO  === 停用播放器所有手势
- (BOOL)triggerGesturesCondition:(CGPoint)location {
    return NO;
}

// YES ==== 隐藏控制层
- (BOOL)controlLayerDisappearCondition {
    return NO;
}

- (UIView *)controlView {
    return nil;
}

- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer statusDidChanged:(SJVideoPlayerPlayStatus)status {
    if (status == 5) {
        NSLog(@"paused paused");
        if (videoPlayer.inactivityReason == SJVideoPlayerInactivityReasonPlayEnd) {
            NSLog(@"end   end  end");
            self.play_button.hidden = NO;
        }
        self.play_button.hidden = NO;
    }
}

- (void)controlLayerNeedAppear:(__kindof SJBaseVideoPlayer *)videoPlayer {
    
}

- (void)controlLayerNeedDisappear:(__kindof SJBaseVideoPlayer *)videoPlayer {
    
}

//点击开始播放视频
- (void)playVideoAction {
    self.play_button.hidden = YES;
    [self.videoPlayer play];
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
