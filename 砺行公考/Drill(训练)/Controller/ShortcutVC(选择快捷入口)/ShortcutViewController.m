//
//  ShortcutViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShortcutViewController.h"
#import "ShortcutTableViewCell.h"
#import "DrillCollectionViewCell.h"
#import "ShortcutModel.h"

@interface ShortcutViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *showDataArray;

@property (nonatomic, strong) NSMutableArray *noShowDataArray;

@property (nonatomic, strong) UIView *header_view;

//最后选取的分类模块ID
@property (nonatomic, strong) NSString *last_categoryModel_string;

@end

@implementation ShortcutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    //初始化
    self.showDataArray = [NSMutableArray arrayWithCapacity:1];
    self.noShowDataArray = [NSMutableArray arrayWithCapacity:1];
    self.last_categoryModel_string = @"1";
    
    [self setViewUI];
}

- (void)setViewUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 30, 5, 30);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 40.0;
    CGFloat width = (SCREENBOUNDS.width - 180) / 4;
    layout.itemSize = CGSizeMake(width, width + 25);
    layout.headerReferenceSize = CGSizeMake(SCREENBOUNDS.width, 40.0);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionview registerClass:[DrillCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo((width + 25) * 2 + 10 + 10 + 40);
    }];
    
    [self.view addSubview:self.header_view];
    [self.header_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionview.mas_bottom);
        make.left.equalTo(weakSelf.collectionview.mas_left);
        make.right.equalTo(weakSelf.collectionview.mas_right);
        make.height.mas_equalTo(50);
    }];
    [self setTableviewHeaderView:self.header_view];
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShortcutTableViewCell class] forCellReuseIdentifier:@"tableCell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_view.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    
    //从数据库里面查询要显示的数据
    [self getShortcutVCFromDataBase];
    
    //根据分类模块ID  获取数据
    [self getShortcutVCFromDataBase:@"1"];
}

#pragma mark ----- collectionview  delegate   datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShortcutModel *model = self.showDataArray[indexPath.row];
    DrillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.isShowDeleteButton = YES;
    cell.imageV.image = [UIImage imageNamed:model.imageNamed];
    cell.label.text = model.title;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @"我的模块";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
    return header_view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ShortcutModel *model = self.showDataArray[indexPath.row];
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    NSString *update_sql_string = [NSString stringWithFormat:@"update t_shortcut set isShow = '%@' where title = '%@'", @"0", model.title];
    if ([dataBase open]) {
        BOOL success = [dataBase executeUpdate:update_sql_string];
        if (success) {
            NSLog(@"更新成功");
            //刷新显示的数据
            [self getShortcutVCFromDataBase];
            [self getShortcutVCFromDataBase:self.last_categoryModel_string];
        }else {
            NSLog(@"更新失败");
        }
    }
    [dataBase close];
}

#pragma mark ---------- tableview delegate  datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noShowDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShortcutModel *model = self.noShowDataArray[indexPath.row];
    ShortcutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.left_imageview.image = [UIImage imageNamed:model.imageNamed];
    cell.content_label.text = model.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDataArray.count > 6) {
        [self showHUDWithTitle:@"最多只能添加六个快捷入口"];
        return;
    }
    
    ShortcutModel *model = self.noShowDataArray[indexPath.row];
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    NSString *update_sql_string = [NSString stringWithFormat:@"update t_shortcut set isShow = '%@' where title = '%@'", @"1", model.title];
    if ([dataBase open]) {
        BOOL success = [dataBase executeUpdate:update_sql_string];
        if (success) {
            NSLog(@"更新成功");
            [self getShortcutVCFromDataBase:self.last_categoryModel_string];
            [self getShortcutVCFromDataBase];
        }else {
            NSLog(@"更新失败");
        }
    }
    [dataBase close];
}

#pragma mark ----- 设置tableview上的四个分类模块
- (void)setTableviewHeaderView:(UIView *)header_view {
    NSArray *array = @[@"解题训练", @"课程模块", @"考伴互动", @"我的互动"];
    CGFloat width = (SCREENBOUNDS.width - 100) / 4;
    for (NSInteger index = 1; index <= 4; index++) {
        UIButton *modelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        modelButton.frame = FRAME(20 + (width + 20) * (index - 1), 10, width, 33);
        modelButton.titleLabel.font = SetFont(16);
        [modelButton setTitleColor:DetailTextColor forState:UIControlStateNormal];
        if (index == 1) {
            [modelButton setTitleColor:ButtonColor forState:UIControlStateNormal];
        }
        [modelButton setTitle:array[index - 1] forState:UIControlStateNormal];
        modelButton.tag = index;
        [modelButton addTarget:self action:@selector(touchModelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [header_view addSubview:modelButton];
    }
}

#pragma mark ---- 点击分类模块按钮  绑定的方法
- (void)touchModelButtonAction:(UIButton *)sender {
    for (UIButton *button in self.header_view.subviews) {
        if (![button isKindOfClass:[UIButton class]]) {
            continue;
        }
        if (button.tag == sender.tag) {
            [button setTitleColor:ButtonColor forState:UIControlStateNormal];
        }else {
            [button setTitleColor:DetailTextColor forState:UIControlStateNormal];
        }
    }
    
    NSString *model_id = [NSString stringWithFormat:@"%ld", sender.tag];
    [self getShortcutVCFromDataBase:model_id];
    self.last_categoryModel_string = model_id;
}

//在数据库中查找需要显示的快捷入口
- (void)getShortcutVCFromDataBase {
    [self.showDataArray removeAllObjects];
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    //拼接SQL语句
    NSString *search_sql_string = [NSString stringWithFormat:@"select * from t_shortcut where isShow = '%@'", @"1"];
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:search_sql_string];
        while ([result next]) {
            ShortcutModel *model = [[ShortcutModel alloc] init];
            NSString *imageNamed = [result stringForColumn:@"imageNamed"];
            NSString *imageUrl = [result stringForColumn:@"imageUrl"];
            NSString *title = [result stringForColumn:@"title"];
            NSString *isShow = [result stringForColumn:@"isShow"];
            NSString *categoryModel = [result stringForColumn:@"categoryModel"];
            NSString *targetVCNamed = [result stringForColumn:@"targetVCNamed"];
            NSString *targetData = [result stringForColumn:@"targetData"];
            model.imageNamed = imageNamed;
            model.imageUrl = imageUrl;
            model.title = title;
            model.isShow = isShow;
            model.categoryModel = categoryModel;
            model.targetVCNamed = targetVCNamed;
            model.targetData = targetData;
            [self.showDataArray addObject:model];
        }
        [self.collectionview reloadData];
    }
    //关闭数据库
    [dataBase close];
}

/**
 根据分类模块ID查询
 在数据库中查找不需要显示的快捷入口

 @param model_id 分类模块ID
 */
- (void)getShortcutVCFromDataBase:(NSString *)model_id {
    [self.noShowDataArray removeAllObjects];
    //获取数据库文件
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    //拼接SQL语句
    NSString *search_sql_string = [NSString stringWithFormat:@"select * from t_shortcut where isShow = '%@' and categoryModel = '%@'", @"0", model_id];
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:search_sql_string];
        while ([result next]) {
            ShortcutModel *model = [[ShortcutModel alloc] init];
            NSString *imageNamed = [result stringForColumn:@"imageNamed"];
            NSString *imageUrl = [result stringForColumn:@"imageUrl"];
            NSString *title = [result stringForColumn:@"title"];
            NSString *isShow = [result stringForColumn:@"isShow"];
            NSString *categoryModel = [result stringForColumn:@"categoryModel"];
            NSString *targetVCNamed = [result stringForColumn:@"targetVCNamed"];
            NSString *targetData = [result stringForColumn:@"targetData"];
            model.imageNamed = imageNamed;
            model.imageUrl = imageUrl;
            model.title = title;
            model.isShow = isShow;
            model.categoryModel = categoryModel;
            model.targetVCNamed = targetVCNamed;
            model.targetData = targetData;
            [self.noShowDataArray addObject:model];
        }
        [self.tableview reloadData];
    }
    //关闭数据库
    [dataBase close];
}

#pragma mark ------ 懒加载
- (UIView *)header_view {
    if (!_header_view) {
        _header_view = [[UIView alloc] init];
        _header_view.backgroundColor = WhiteColor;
    }
    return _header_view;
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
