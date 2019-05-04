//
//  AfterClassWork_MoreViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "AfterClassWork_MoreViewController.h"
#import "DrillCollectionViewCell.h"
#import "AfterClassWorkTableViewCell.h"
#import "LineTest_Category_Model.h"
#import "AfterClassWorkModel.h"

@interface AfterClassWork_MoreViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, strong) UITableView *tableview;

//选择的课程的数组
@property (nonatomic, strong) NSMutableArray *select_course_array;

@property (nonatomic, strong) NSArray *category_model_array;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AfterClassWork_MoreViewController

/**
 获取课程标签
 */
- (void)getCourseLabel {
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/find_course_lable_list" Dic:@{} SuccessBlock:^(id responseObject) {
        NSLog(@"course label == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            __weak typeof(self) weakSelf = self;
            for (NSDictionary *dic in responseObject[@"data"]) {
                LineTest_Category_Model *model = [[LineTest_Category_Model alloc] init];
                model.lineTest_category_id = dic[@"serial_number_"];
                model.lineTest_category_content = dic[@"content_"];
                model.lineTest_category_path = dic[@"path_"];
                [array addObject:model];
            }
            weakSelf.category_model_array = [array copy];
            [weakSelf.collectionV reloadData];
            
            //默认获取第一大分类的数据
            LineTest_Category_Model *model = array[0];
            [weakSelf getHttpData:model.lineTest_category_id Page_index:@"1"];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//获取后台数据
- (void)getHttpData:(NSString *)type_label Page_index:(NSString *)page {
    [self showHUD];
    NSDictionary *parma = @{
                            @"serial_number_":type_label,
                            @"page_number":page,
                            @"page_size":@"50"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/find_user_homework_list" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"after class work == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf formatData:responseObject[@"data"]];
        }
        [weakSelf hidden];
    } FailureBlock:^(id error) {
        [weakSelf hidden];
    }];
}

//整理数据
- (void)formatData:(NSDictionary *)httpData {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in httpData[@"rows"]) {
        AfterClassWorkModel *model = [[AfterClassWorkModel alloc] init];
        model.work_id = dic[@"id_"];
        model.work_type = dic[@"lable_content"];
        model.work_name = dic[@"title_"];
        [array addObject:model];
    }
    self.dataArray = [array copy];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课后作业";
    [self setBack];
    self.select_course_array = [NSMutableArray arrayWithCapacity:1];
    
    //若课程可以选择    右上角出现确定按钮 + 搜索按钮
    if (self.isSelectCourse) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
        UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
        self.navigationItem.rightBarButtonItems = @[right, right1];
    }
    
    //添加collectionview
    __weak typeof(self) weakSelf = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30);
    layout.minimumLineSpacing = 40;
    layout.minimumInteritemSpacing = 40.0;
    CGFloat width = (SCREENBOUNDS.width - 180) / 4;
    layout.itemSize = CGSizeMake(width, width + 25);
    
    self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionV.backgroundColor = [UIColor whiteColor];
    self.collectionV.pagingEnabled = YES;
    /// 设置此属性为yes 不满一屏幕 也能滚动
    self.collectionV.alwaysBounceHorizontal = YES;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    [self.collectionV registerClass:[DrillCollectionViewCell class] forCellWithReuseIdentifier:@"drill"];
    [self.view addSubview:self.collectionV];
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(width + 25 + 20);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[AfterClassWorkTableViewCell class] forCellReuseIdentifier:@"afterClassCell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionV.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self getCourseLabel];
}

#pragma mark ----- collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.category_model_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LineTest_Category_Model *model = self.category_model_array[indexPath.row];
    DrillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"drill" forIndexPath:indexPath];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.lineTest_category_path] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.label.text = model.lineTest_category_content;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ----- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AfterClassWorkModel *model = self.dataArray[indexPath.row];
    AfterClassWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"afterClassCell"];
    cell.title_label.text = [NSString stringWithFormat:@"%@-%@", model.work_type, model.work_name];
    cell.tag_label.text = @"";
    cell.isShowAddButton = self.isSelectCourse;
    if (self.isSelectCourse) {
        if ([self.select_course_array containsObject:indexPath]) {
            cell.select_image.image = [UIImage imageNamed:@"select_yes"];
        }else {
            cell.select_image.image = [UIImage imageNamed:@"select_no"];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = SetColor(246, 246, 246, 1);
    for (UIView *vv in header_view.subviews) {
        [vv removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(10);
    label.textColor = SetColor(189, 189, 189, 1);
    label.text = @"TIPS：只有完成听课的课程作业才会出现在下方";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header_view.mas_centerX);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
    return header_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelectCourse) {
        if ([self.select_course_array containsObject:indexPath]) {
            [self.select_course_array removeObject:indexPath];
        }else {
            [self.select_course_array addObject:indexPath];
        }
        [self.tableview reloadData];
    }
}

#pragma mark ----- 当课程可以选择时   需要的方法
- (void)saveAction {
    
}

- (void)searchAction {
    
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
