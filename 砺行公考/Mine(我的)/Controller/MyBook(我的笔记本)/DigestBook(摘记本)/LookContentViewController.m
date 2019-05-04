//
//  LookContentViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "LookContentViewController.h"
#import "DigestTagCollectionViewCell.h"
#import "DigestTagTableViewCell.h"

@interface LookContentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DigestTagCollectionViewCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) UIView *back_view;

@property (nonatomic, strong) UIView *data_view;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *data_array;

/** 选择的要绑定的摘记的标签ID */
@property (nonatomic, strong) NSString *choose_bind_tag_id;

@end

@implementation LookContentViewController

StringHeight()

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithImage:[UIImage imageNamed:@"schedule_add"] target:self action:@selector(addDigestTagAction)];
    
    [self initViewUI];
}

- (void)getDigestDetails {
    NSDictionary *param = @{@"id_":self.digest_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_abstract_detail" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataDic = responseObject[@"data"];
            [weakSelf.collectionview reloadData];
            [weakSelf.collectionview.mj_header endRefreshing];
        }else {
            [weakSelf.collectionview.mj_header endRefreshing];
        }
    } FailureBlock:^(id error) {
        [weakSelf.collectionview.mj_header endRefreshing];
    }];
}

- (void)initViewUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.itemSize = CGSizeMake((SCREENBOUNDS.width - 100) / 4, 20);
    layout.minimumLineSpacing = 20.0;
    layout.minimumInteritemSpacing = 20.0;
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionview registerClass:[DigestTagCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDigestDetails];
    }];
    [self.collectionview.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataDic[@"label_result_"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DigestTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.tag_label.text = self.dataDic[@"label_result_"][indexPath.row][@"content_"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = [self calculateRowHeight:self.dataDic[@"content_"] fontSize:16 withWidth:SCREENBOUNDS.width - 40];
    return CGSizeMake(SCREENBOUNDS.width, height + 60.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    for (UIView *vv in header.subviews) {
        [vv removeFromSuperview];
    }
    
    UILabel *time_label = [[UILabel alloc] init];
    time_label.textColor = DetailTextColor;
    time_label.font = SetFont(14);
    time_label.text = [NSString stringWithFormat:@"创建时间：%@", self.dataDic[@"create_time_"]];
    [header addSubview:time_label];
    [time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_top).offset(10);
        make.left.equalTo(header.mas_left).offset(20);
    }];
    
    UILabel *content_label = [[UILabel alloc] init];
    content_label.font = SetFont(16);
    content_label.textColor = SetColor(74, 74, 74, 1);
    content_label.numberOfLines = 0;
    content_label.text = self.dataDic[@"content_"];
    [header addSubview:content_label];
    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(time_label.mas_bottom).offset(10);
        make.left.equalTo(header.mas_left).offset(20);
        make.right.equalTo(header.mas_right).offset(-20);
        make.bottom.equalTo(header.mas_bottom).offset(-10);
    }];
    return header;
}

//解绑绑定的标签
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否删除" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf determineRemoveBindTagWithDigest:indexPath];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 删除绑定的标签
 
 @param indexPath 标签位置
 */
- (void)determineRemoveBindTagWithDigest:(NSIndexPath *)indexPath {
    NSString *select_tag_id = self.dataDic[@"label_result_"][indexPath.row][@"id_"];
    NSDictionary *param = @{@"id_":self.digest_id,
                            @"label_id_":select_tag_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/remove_abstract_label" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf.collectionview.mj_header beginRefreshing];
        }
    } FailureBlock:^(id error) {
        
    }];
}

/** 添加绑定标签 */
- (void)addDigestTagAction {
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.back_view = [[UIView alloc] initWithFrame:app_delegate.window.bounds];
    self.back_view.backgroundColor = SetColor(155, 155, 155, 0.8);
    [app_delegate.window addSubview:self.back_view];
    
    [self showBindTagInView:self.back_view withData:@[]];
}

- (void)showBindTagInView:(UIView *)view withData:(NSArray *)dataArray {
    [self lookDigestTagWithPersonal];
    self.data_view = [[UIView alloc] init];
    self.data_view.backgroundColor = WhiteColor;
    ViewRadius(self.data_view, 8.0);
    [view addSubview:self.data_view];
    [self.data_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREENBOUNDS.width - 40, (SCREENBOUNDS.height) / 3 * 2));
    }];
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"选择标签";
    [self.data_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.data_view.mas_centerX);
        make.top.equalTo(weakSelf.data_view.mas_top).offset(10);
    }];
    
    UIButton *add_tag_button = [UIButton buttonWithType:UIButtonTypeCustom];
    add_tag_button.titleLabel.font = SetFont(14);
    add_tag_button.backgroundColor = WhiteColor;
    [add_tag_button setTitleColor:SetColor(191, 191, 191, 1) forState:UIControlStateNormal];
    [add_tag_button setTitle:@"添加标签" forState:UIControlStateNormal];
    [add_tag_button setImage:[UIImage imageNamed:@"schedule_add"] forState:UIControlStateNormal];
    [add_tag_button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self setBorderLine:add_tag_button withFrame:FRAME(0, 0, SCREENBOUNDS.width - 80, 46)];
    [self.data_view addSubview:add_tag_button];
    [add_tag_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.data_view.mas_left).offset(20);
        make.right.equalTo(weakSelf.data_view.mas_right).offset(-20);
        make.height.mas_equalTo(46.0);
    }];
    [add_tag_button addTarget:self action:@selector(addDigestNewTagAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[DigestTagTableViewCell class] forCellReuseIdentifier:@"tableCell"];
    [self.data_view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(add_tag_button.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.data_view.mas_left);
        make.right.equalTo(weakSelf.data_view.mas_right);
        make.bottom.equalTo(weakSelf.data_view.mas_bottom).offset(-40);
    }];
    
    CGFloat width = (SCREENBOUNDS.width - 40) / 2;
    UIButton *cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_button.backgroundColor = WhiteColor;
    [cancel_button setTitleColor:SetColor(242, 68, 89, 1) forState:UIControlStateNormal];
    [cancel_button setTitle:@"取消" forState:UIControlStateNormal];
    [self.data_view addSubview:cancel_button];
    [cancel_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom);
        make.left.equalTo(weakSelf.data_view.mas_left);
        make.bottom.equalTo(weakSelf.data_view.mas_bottom);
        make.width.mas_equalTo(width);
    }];
    [cancel_button addTarget:self action:@selector(removeDataView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirm_button = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm_button.backgroundColor = WhiteColor;
    [confirm_button setTitleColor:SetColor(193, 193, 193, 1) forState:UIControlStateNormal];
    [confirm_button setTitle:@"确认" forState:UIControlStateNormal];
    [self.data_view addSubview:confirm_button];
    [confirm_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom);
        make.left.equalTo(cancel_button.mas_right);
        make.bottom.equalTo(weakSelf.data_view.mas_bottom);
        make.width.mas_equalTo(width);
    }];
    [confirm_button addTarget:self action:@selector(bindTagToDigestAction) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.data_array[indexPath.row];
    DigestTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.tag_label.text = dataDic[@"content_"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.data_array[indexPath.row];
    self.choose_bind_tag_id = dic[@"id_"];
}

/**
 移除显示标签的视图
 */
- (void)removeDataView {
    [self.back_view removeFromSuperview];
}

/** 添加新标签 */
- (void)addDigestNewTagAction {
    self.back_view.hidden = YES;
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"添加标签" preferredStyle:UIAlertControllerStyleAlert];
    
    //定义第一个输入框；
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入标签名称";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *tag_content = alert.textFields.firstObject;
        if ([tag_content.text isEqualToString:@""]) {
            return;
        }else {
            //请求接口   添加新标签
            [weakSelf addDigestNewTag:tag_content.text];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

/**
 画虚线

 @param label 视图
 */
- (void)setBorderLine:(UIButton *)label withFrame:(CGRect)frame {
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = SetColor(201, 201, 201, 1).CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:frame].CGPath;
    border.frame = frame;
    //虚线的宽度
    border.lineWidth = 1.f;
    [border setLineCap:kCALineJoinRound];
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    [label.layer addSublayer:border];
}

/**
 添加自定义摘记标签

 @param tag_content 标签名称
 */
- (void)addDigestNewTag:(NSString *)tag_content {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"content_":tag_content};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_label" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"摘记  新标签  添加成功");
            [weakSelf lookDigestTagWithPersonal];
        }else {
            NSLog(@"摘记  新标签  添加失败");
        }
    } FailureBlock:^(id error) {
        NSLog(@"摘记  新标签  添加失败");
    }];
}

/**
 查看个人的摘记标签
 */
- (void)lookDigestTagWithPersonal {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_abstract_label" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.data_array = [responseObject[@"data"][@"custom_label_"] arrayByAddingObjectsFromArray:responseObject[@"data"][@"backend_label_"]];
            [weakSelf.tableview reloadData];
            weakSelf.back_view.hidden = NO;
        }
    } FailureBlock:^(id error) {
        
    }];
}

/**
 绑定标签到摘记
 */
- (void)bindTagToDigestAction {
    if (self.choose_bind_tag_id) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *param = @{@"id_":self.digest_id,@"label_id_list_":@[self.choose_bind_tag_id]};
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_abstract_label" Dic:param SuccessBlock:^(id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1) {
                [weakSelf.back_view removeFromSuperview];
                [weakSelf.collectionview.mj_header beginRefreshing];
            }
        } FailureBlock:^(id error) {
            
        }];
    }else {
        [self showHUDWithTitle:@"未选择标签！！！"];
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
