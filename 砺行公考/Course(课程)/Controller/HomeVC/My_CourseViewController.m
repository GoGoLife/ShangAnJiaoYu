//
//  My_CourseViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "My_CourseViewController.h"
#import "DrillCollectionViewCell.h"
#import "My_CourseSectionView.h"
#import "MyCourseTableViewCell.h"
#import "MyCourseSectionModel.h"
#import "MyCourseModel.h"
#import "LineTest_Category_Model.h"

@interface My_CourseViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, MyCourseSectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

//选择的课程的数组
@property (nonatomic, strong) NSMutableArray *select_course_array;

//分类模块数据
@property (nonatomic, strong) NSArray *category_model_array;

@end

@implementation My_CourseViewController

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
    NSDictionary *parma = @{
                            @"serial_number_":type_label,
                            @"page_number":page,
                            @"page_size":@"10"
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/find_user_course_list" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"myCourse == %@", responseObject);
        [weakSelf formatData:responseObject[@"data"]];
    } FailureBlock:^(id error) {
        
    }];
}

//整理数据
- (void)formatData:(NSDictionary *)httpData {
    NSMutableArray *section_array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in httpData[@"rows"]) {
        MyCourseSectionModel *sectionModel = [[MyCourseSectionModel alloc] init];
        sectionModel.isSelected = NO;
        sectionModel.my_course_pakeage_id = dic[@"id_"];
        sectionModel.title_string = @"言语理解的基础轮·课程包";
        //课程时长
        NSString *course_date = [NSString stringWithFormat:@"%ld", [dic[@"sum_"] integerValue] / 1000 / 60 / 60];
        sectionModel.detail_string = [NSString stringWithFormat:@"%@·%@·%@", dic[@"type_content"], dic[@"level_content"], course_date];
        sectionModel.finish_string = [NSString stringWithFormat:@"课时完成度 %@%%", @"70"]; //dic[@"plan_"]
        sectionModel.slider_value_string = dic[@"plan_"];
        NSMutableArray *course_array = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *course_dic in dic[@"course_content_list"]) {
            MyCourseModel *model = [[MyCourseModel alloc] init];
            model.myCourse_id = course_dic[@"id_"];
//            model.isStudy = [course_dic[@"status"] integerValue] ? YES : NO;
            model.isStudy = NO;
            model.content_string = course_dic[@"title"];
            [course_array addObject:model];
        }
        sectionModel.my_course_array = [course_array copy];
        [section_array addObject:sectionModel];
    }
    self.dataArray = [section_array copy];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的课程";
    [self setBack];
    //若课程可以选择    右上角出现确定按钮 + 搜索按钮
    if (self.isSelectCourse) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
        UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
        self.navigationItem.rightBarButtonItems = @[right, right1];
    }
    
    self.select_course_array = [NSMutableArray arrayWithCapacity:1];
    
    
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
    self.collectionV.backgroundColor = SetColor(246, 246, 246, 1);
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
//    [self.collectionV selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.estimatedRowHeight = 0;
    self.tableview.estimatedSectionHeaderHeight = 0;
    self.tableview.estimatedSectionFooterHeight = 0;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[MyCourseTableViewCell class] forCellReuseIdentifier:@"myCourseCell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionV.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    //获取课程标签
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LineTest_Category_Model *model = self.category_model_array[indexPath.row];
    [self getHttpData:model.lineTest_category_id Page_index:@"1"];
}

#pragma mark ---- tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MyCourseSectionModel *model = self.dataArray[section];
    return model.isSelected ? model.my_course_array.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCourseSectionModel *courseModel = self.dataArray[indexPath.section];
    MyCourseModel *model = courseModel.my_course_array[indexPath.row];
    MyCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCourseCell"];
    cell.indexPath = indexPath;
    cell.isShowAddButton = self.isSelectCourse;
    cell.backgroundColor = SetColor(246, 246, 246, 1);
    cell.content_label.text = model.content_string;
    cell.tag_label.text = model.tag_string;
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
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 110.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MyCourseSectionModel *model = self.dataArray[section];
    My_CourseSectionView *header_view = [[My_CourseSectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 110)];
    header_view.title_label.text = model.title_string;
    header_view.detail_label.text = model.detail_string;
    header_view.finish_label.text = model.finish_string;
    [header_view.slider setValue:[model.slider_value_string floatValue] animated:YES];
    header_view.section = section;
    header_view.delegate = self;
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = SetColor(246, 246, 246, 1);
    return footer_view;
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

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.isSelectCourse) {
//        MyCourseTableViewCell *cell = (MyCourseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        cell.select_image.backgroundColor = RandomColor;
//    }
//}

#pragma mark --- custom delegate
- (void)touchSelfTargetAction:(NSInteger)section {
    MyCourseSectionModel *model = self.dataArray[section];
    model.isSelected = !model.isSelected;
    [self.tableview reloadData];
//    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
