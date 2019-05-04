//
//  SearchDigestViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SearchDigestViewController.h"
#import "SeachTagCollectionViewCell.h"
#import "CustomTitleView.h"

@interface SearchDigestViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSMutableArray *data_array;

@end

@implementation SearchDigestViewController
//获取用户搜索历史
- (void)getHistoryTag {
    NSDictionary *param = @{@"type_":@"3"};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_note_search_record" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf.data_array replaceObjectAtIndex:0 withObject:responseObject[@"data"]];
            [weakSelf.collectionview reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

/**
 查看个人的摘记标签
 */
- (void)lookDigestTagWithPersonal {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_abstract_label" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSArray *array = [responseObject[@"data"][@"custom_label_"] arrayByAddingObjectsFromArray:responseObject[@"data"][@"backend_label_"]];
            [weakSelf.data_array replaceObjectAtIndex:1 withObject:array];
            [weakSelf.collectionview reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
//    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"取消" target:self action:@selector(cancelSearchAction)];
    self.data_array = [NSMutableArray arrayWithArray:@[@[],@[]]];
    
    CustomTitleView *titleView = [[CustomTitleView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width - 80.0, 32.0)];
    self.navigationItem.titleView = titleView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    [searchBar setBackgroundImage:[self GetImageWithColor:SetColor(246, 246, 246, 1) andHeight:32.0]];
    [searchBar setSearchFieldBackgroundImage:[self GetImageWithColor:SetColor(246, 246, 246, 1) andHeight:32.0] forState:UIControlStateNormal];
    [titleView addSubview:searchBar];
    
    
    __weak typeof(self) weakSelf = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumLineSpacing = 20.0;
    layout.minimumInteritemSpacing = 20.0;
    layout.headerReferenceSize = CGSizeMake(SCREENBOUNDS.width, 40.0);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[SeachTagCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getHistoryTag];
    [self lookDigestTagWithPersonal];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *tag_string = self.data_array[indexPath.section][indexPath.row];
        CGFloat width = [self calculateRowWidth:tag_string withFont:14] + 40.0;
        return CGSizeMake(width, 32.0);
    }else {
        NSString *tag_string = self.data_array[indexPath.section][indexPath.row][@"content_"];
        CGFloat width = [self calculateRowWidth:tag_string withFont:14] + 40.0;
        return CGSizeMake(width, 32.0);
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data_array.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data_array[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SeachTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSString *tag_string = self.data_array[indexPath.section][indexPath.row];
        cell.tag_label.backgroundColor = SetColor(246, 246, 246, 1);
        cell.tag_label.textColor = [UIColor blackColor];
        cell.tag_label.text = tag_string;
    }else {
        NSString *tag_string = self.data_array[indexPath.section][indexPath.row][@"content_"];
        cell.tag_label.backgroundColor = ButtonColor;
        cell.tag_label.textColor = WhiteColor;
        cell.tag_label.text = tag_string;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
    if (indexPath.section == 0) {
        self.returnSearchContentWithTagID(self.data_array[indexPath.section][indexPath.row], @[], @"1");
    }else {
        self.returnSearchContentWithTagID(@"", @[self.data_array[indexPath.section][indexPath.row][@"id_"]], @"2");
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    if (indexPath.section == 0) {
        label.textColor = DetailTextColor;
    }else {
        label.textColor = ButtonColor;
    }
    label.text = @[@"历史搜索",@"标签搜索"][indexPath.section];
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left).offset(20);
        make.centerY.equalTo(header.mas_centerY);
    }];
    return header;
}

#pragma mark --- searchBar delegate ---
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.returnSearchContentWithTagID(searchBar.text, @[], @"1");
    [self addSearchHistory:searchBar.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSearchHistory:(NSString *)string {
    NSDictionary *param = @{@"content_":string,@"type_":@"3"};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_note_search_record" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"新增历史搜索文本成功");
        }else {
            NSLog(@"新增历史搜索文本失败");
        }
    } FailureBlock:^(id error) {
        NSLog(@"新增历史搜索文本失败");
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
