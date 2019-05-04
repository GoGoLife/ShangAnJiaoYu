//
//  SearchViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/17.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SearchViewController.h"
#import <SKTagView.h>
#import "Course_TwoTableViewCell.h"
#import <IQKeyboardManager.h>
#import "SortView.h"

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableview;

//历史搜索
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) SKTagView *tagView;

@property (nonatomic, strong) SortView *sort_view;

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
//    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"购物车" target:self action:@selector(pushShoppingCartAction)];

    UIView *titleV = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width - 50, 40)];
    titleV.backgroundColor = WhiteColor;
    
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:FRAME(0, 5, titleV.bounds.size.width, 30)];
    search.delegate = self;
    search.tintColor = [UIColor whiteColor];
    search.barTintColor = [UIColor clearColor];
    UIImage *backImage = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0];
    search.backgroundImage = backImage;
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    searchTextField = [[[search.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = SetColor(246, 246, 246, 1);
    search.placeholder = @"输入关键词...";
    [titleV addSubview:search];
    
    self.navigationItem.titleView = titleV;
    
    //第一次加载视图
    [self setFirstView];
    
    __weak typeof(self) weakSelf = self;
    self.sort_view = [[SortView alloc] init];
    self.sort_view.hidden = YES;
    [self.view addSubview:self.sort_view];
    [self.sort_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.hidden = YES;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[Course_TwoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sort_view.mas_bottom);
        make.left.equalTo(weakSelf.sort_view.mas_left);
        make.right.equalTo(weakSelf.sort_view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}

#pragma mark --- search delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.label.hidden = YES;
    self.tagView.hidden = YES;
    self.sort_view.hidden = NO;
    self.tableview.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.label.hidden = YES;
    self.tagView.hidden = YES;
    self.sort_view.hidden = NO;
    self.tableview.hidden = NO;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Course_TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
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
    return [[UIView alloc] init];
}



//第一次加载视图    历史搜索
- (void)setFirstView {
    __weak typeof(self) weakSelf = self;
    self.label = [[UILabel alloc] init];
    self.label.font = SetFont(14);
    self.label.textColor = DetailTextColor;
    self.label.text = @"历史搜索";
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    [self.tagView removeAllTags];
    self.tagView = [[SKTagView alloc] init];
    self.tagView.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    self.tagView.lineSpacing = 20.0;
    self.tagView.interitemSpacing = 10.0;
    self.tagView.preferredMaxLayoutWidth = SCREENBOUNDS.width - 40;
    //加载tagview
//    [self setTagViewWithData:@[@"rrrrrrr", @"eeeee", @"wwwwwww", @"qqqqq", @"ccccc"]];
    for (NSString *string in @[@"rrrrrrr", @"eeeee", @"wwwwwww", @"qqqqq", @"ccccc"]) {
        SKTag *tag = [[SKTag alloc] initWithText:string];
        tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
        tag.cornerRadius = 3.0;
        tag.font = SetFont(14);
        tag.borderWidth = 0;
        tag.bgColor = SetColor(246, 246, 246, 1);
        tag.enable = YES;
        [weakSelf.tagView addTag:tag];
    }
    
    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    //点击tag回调
    self.tagView.didTapTagAtIndex = ^(NSUInteger index) {
        
    };
    
//    // 获取刚才加入所有tag之后的内在高度
//    CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
//    NSLog(@"高度%lf",tagHeight);
//    // 根据已经得到的内在高度给SKTagView创建frame
//    self.tagView.frame = CGRectMake(0, 30, SCREENBOUNDS.width, tagHeight);
//    [self.tagView layoutSubviews];
//    [self.view addSubview:self.tagView];
}

//根据数据加载tagview
- (void)setTagViewWithData:(NSArray *)dataArray {
    __weak typeof(self) weakSelf = self;
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SKTag *tag = [[SKTag alloc] initWithText:dataArray[idx]];
        tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
        tag.cornerRadius = 3.0;
        tag.font = SetFont(14);
        tag.borderWidth = 0;
        tag.bgColor = SetColor(246, 246, 246, 1);
        tag.enable = YES;
        [weakSelf.tagView addTag:tag];
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
